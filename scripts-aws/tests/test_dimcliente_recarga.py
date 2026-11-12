"""Pruebas locales: validacion y control transaccional; no conectan con AWS."""
import csv
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location(
    "recarga", ROOT / "scripts-aws/invacom-load-dimcliente-recarga.py"
)
recarga = importlib.util.module_from_spec(spec)
spec.loader.exec_module(recarga)


def customer(customer_id=1, name="Ana Perez"):
    return dict(CustomerId=customer_id, NombreCompleto=name,
                Pais="Costa Rica", Estado="Sin dato", Ciudad="Alajuela")


class FakeConnection:
    """Doble JDBC para probar commit/rollback, sin simular el motor MySQL."""
    def __init__(self, fail=False):
        self.fail = fail
        self.committed = self.rolled_back = self.closed = False
        self.calls = 0

    def setAutoCommit(self, enabled):
        assert enabled is False

    def prepareStatement(self, sql):
        assert sql == recarga.UPSERT
        return self

    def setQueryTimeout(self, seconds):
        assert seconds > 0

    def setInt(self, index, value):
        assert index == 1 and type(value) is int

    def setString(self, index, value):
        assert 2 <= index <= 5 and isinstance(value, str)

    def executeUpdate(self):
        self.calls += 1
        if self.fail and self.calls == 2:
            raise RuntimeError("Fallo de escritura de prueba")

    def commit(self):
        self.committed = True

    def rollback(self):
        self.rolled_back = True

    def close(self):
        self.closed = True


class RecargaTests(unittest.TestCase):
    def test_repetidos_identicos_se_consolidan(self):
        self.assertEqual(len(recarga.validate_rows([customer(), customer()])), 1)

    def test_mismo_id_con_diferentes_atributos_se_rechaza(self):
        with self.assertRaises(ValueError):
            recarga.validate_rows([customer(), customer(name="Otro nombre")])

    def test_datos_invalidos_no_llegan_al_destino(self):
        for row in (customer(None), customer(0), customer(True),
                    customer(name=""), customer(name="a" * 201)):
            with self.subTest(row=row), self.assertRaises(ValueError):
                recarga.validate_rows([row])
        with self.assertRaises(ValueError):
            recarga.validate_rows([])

    def test_csv_real_conserva_59_clientes_y_29_estados_sin_dato(self):
        with (ROOT / "chinook_digital_store/Customer.csv").open(
            encoding="utf-8-sig", newline=""
        ) as source:
            rows = [dict(
                CustomerId=int(row["CustomerId"]),
                NombreCompleto=(row["FirstName"].strip() + " " + row["LastName"].strip()).strip(),
                Pais=row["Country"].strip(),
                Estado=row["State"].strip() or "Sin dato",
                Ciudad=row["City"].strip(),
            ) for row in csv.DictReader(source)]
        validated = recarga.validate_rows(rows)
        self.assertEqual(len(validated), 59)
        self.assertEqual(sum(row[3] == "Sin dato" for row in validated), 29)

    def test_lote_exitoso_se_confirma(self):
        connection = FakeConnection()
        recarga.write_transaction(connection, recarga.validate_rows([customer()]))
        self.assertTrue(connection.committed and connection.closed)
        self.assertFalse(connection.rolled_back)

    def test_fallo_parcial_solicita_rollback(self):
        connection = FakeConnection(fail=True)
        with self.assertRaises(RuntimeError):
            recarga.write_transaction(connection, recarga.validate_rows([customer(1), customer(2)]))
        self.assertTrue(connection.rolled_back and connection.closed)
        self.assertFalse(connection.committed)


if __name__ == "__main__":
    unittest.main()
