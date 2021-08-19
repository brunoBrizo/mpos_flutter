import 'package:hive/hive.dart';
import 'package:mpos/src/database/numerador_database.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:mpos/src/modelo/moneda_modelo.dart';
import 'package:mpos/src/modelo/numerador_modelo.dart';
import 'package:mpos/src/modelo/transaccion_modelo.dart';

class TransaccionDatabase {
  Box trnBox;

  Future<Box> initTrn() async {
    try {
      trnBox = await Hive.openBox('transaccion');

      trnBox.values
          .toList()
          .cast<Transaccion>()
          .sort((a, b) => -a.fecha.compareTo(b.fecha));
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + error.toString());
    }

    return trnBox;
  }

  Future<Transaccion> getTrn(int index) async {
    Transaccion trn;
    try {
      trnBox = await Hive.openBox('transaccion');
      trn = await trnBox.get(index);
    } on Exception catch (exception) {
      throw new Exception(
          'Error obteniendo transaccion: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error obteniendo transaccion: ' + error.toString());
    }
    return trn;
  }

  Future<List<Transaccion>> getAllTrn(DateTime fecha) async {
    List<Transaccion> trnList = [];
    try {
      trnBox = await Hive.openBox('transaccion');
      trnList = trnBox.values
          .cast<Transaccion>()
          .where((element) =>
              (element.fecha.year.compareTo(fecha.year) == 0) &&
              (element.fecha.month.compareTo(fecha.month) == 0) &&
              (element.fecha.day.compareTo(fecha.day) == 0))
          .toList();
    } on Exception catch (exception) {
      throw new Exception(
          'Error obteniendo transacciones: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error obteniendo transacciones: ' + error.toString());
    }
    return trnList;
  }

  Future setTrnDevuelta(int ticketNro) async {
    try {
      trnBox = await Hive.openBox('transaccion');
      Transaccion trn;
      int index;
      for (index = 1; index <= trnBox.length; index++) {
        trn = await trnBox.get(index);
        if (trn.ticket == ticketNro) {
          break;
        }
      }
      trn.fueDevuelto = true;
      await updateTrn(index, trn);
    } on Exception catch (exception) {
      throw new Exception(
          'Error actualizando transaccion: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error actualizando transaccion: ' + error.toString());
    }
  }

  Future<void> insertTrn(Transaccion trn) async {
    try {
      NumeradorDatabase numeradorDatabase = new NumeradorDatabase();
      Box numeradorBox = await numeradorDatabase.initNumerador();
      Numerador numerador = await numeradorBox.get(1);

      trn.id = numerador.value;
      numerador.value += 1;
      numeradorDatabase.updateNumerador(1, numerador);
      trnBox = await Hive.openBox('transaccion');
      await trnBox.put(trn.id, trn);
    } on Exception catch (exception) {
      print("insertTrn EXCEPTION: " + exception.toString());
      throw new Exception(
          'Error guardando transaccion: ' + exception.toString());
    } catch (error) {
      print("insertTrn ERROR: " + error.toString());
      throw new Exception('Error guardando transaccion: ' + error.toString());
    }
  }

  Future updateTrn(int index, Transaccion trn) async {
    try {
      trnBox = await Hive.openBox('transaccion');
      await trnBox.put(index, trn);
    } on Exception catch (exception) {
      throw new Exception(
          'Error actualizando transaccion: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error actualizando transaccion: ' + error.toString());
    }
  }

  Future deleteTrnByIndex(int index) async {
    try {
      trnBox = await Hive.openBox('transaccion');
      await trnBox.delete(index);
    } on Exception catch (exception) {
      throw new Exception(
          'Error eliminando transaccion: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error eliminando transaccion: ' + error.toString());
    }
  }

  Future deleteTrnsByDate(Duration duration) async {
    try {
      trnBox = await Hive.openBox('transaccion');
      for (Transaccion trn in trnBox.values) {
        Duration durationAux = trn.fecha.difference(DateTime.now());
        if (durationAux.inDays <= duration.inDays) {
          await trnBox.delete(trn.id);
        }
      }
    } on Exception catch (exception) {
      print('Error eliminando tickets: ' + exception.toString());
    } catch (error) {
      print('Error eliminando tickets: ' + error.toString());
    }
  }

  Future deleteAllTrns() async {
    try {
      trnBox = await Hive.openBox('transaccion');
      await trnBox.clear();
      await this.dispose();
    } on Exception catch (exception) {
      throw new Exception(
          'Error eliminando transacciones: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error eliminando transacciones: ' + error.toString());
    }
  }

  Future<void> dispose() async {
    try {
      await trnBox.compact();
      await trnBox.close();
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la DB del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la DB del dispositivo: ' + error.toString());
    }
  }

  Future<void> insertDummyTrns() async {
    int i = 1;
    while (i < 10) {
      Transaccion trn = new Transaccion();
      trn.id = i;
      trn.ticket = i;
      trn.fecha = new DateTime.now();
      trn.monto = 500;
      trn.tipo = TipoTransaccion.Venta;
      trn.moneda = new Moneda(1, 'pesos', 'uss');
      trn.tarjetaNombre = 'VISA';
      trn.nroAutorizacion = '123456789';
      trn.cuotas = 5;
      trn.fueDevuelto = false;
      await insertTrn(trn);
      i++;
    }
  }
}
