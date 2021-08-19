import 'package:hive/hive.dart';
import 'package:mpos/src/database/numerador_database.dart';
import 'package:mpos/src/modelo/cierre_lote_modelo.dart';
import 'package:mpos/src/modelo/numerador_modelo.dart';

class CierreLoteDatabase {
  Box cierreBox;

  Future<Box> initCierreLote() async {
    try {
      cierreBox = await Hive.openBox('cierrelote');

      cierreBox.values
          .toList()
          .cast<CierreLote>()
          .sort((a, b) => -a.fecha.compareTo(b.fecha));
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la DB del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la DB del dispositivo: ' + error.toString());
    }

    return cierreBox;
  }

  Future<CierreLote> getCierreLote(int index) async {
    CierreLote cierre;
    try {
      cierreBox = await Hive.openBox('cierrelote');
      cierre = await cierreBox.get(index);
    } on Exception catch (exception) {
      throw new Exception(
          'Error obteniendo cierre de lote: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error obteniendo cierre de lote: ' + error.toString());
    }

    return cierre;
  }

  Future<void> insertCierreLote(CierreLote cierre) async {
    try {
      NumeradorDatabase numeradorDatabase = new NumeradorDatabase();
      Box numeradorBox = await numeradorDatabase.initNumerador();
      Numerador numerador = await numeradorBox.get(2);
      cierre.id = numerador.value;
      numerador.value += 1;
      numeradorDatabase.updateNumerador(2, numerador);

      cierreBox = await Hive.openBox('cierrelote');
      await cierreBox.put(cierre.id, cierre);
    } on Exception catch (exception) {
      throw new Exception(
          'Error guardando cierre de lote: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error guardando cierre de lote: ' + error.toString());
    }
  }

  Future updateCierreLote(int index, CierreLote cierre) async {
    try {
      cierreBox = await Hive.openBox('cierrelote');
      await cierreBox.put(index, cierre);
    } on Exception catch (exception) {
      throw new Exception(
          'Error actualizando cierre de lote: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error actualizando cierre de lote: ' + error.toString());
    }
  }

  Future deleteCierreLoteByIndex(int index) async {
    try {
      cierreBox = await Hive.openBox('cierrelote');
      await cierreBox.deleteAt(index);
    } on Exception catch (exception) {
      throw new Exception(
          'Error borrando cierre de lote: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error borrando cierre de lote: ' + error.toString());
    }
  }

  Future deleteAllCierres() async {
    try {
      cierreBox = await Hive.openBox('cierrelote');
      await cierreBox.clear();
      await this.dispose();
    } on Exception catch (exception) {
      throw new Exception(
          'Error borrando cierres de lote: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error borrando cierres de lote: ' + error.toString());
    }
  }

  Future<void> dispose() async {
    try {
      await cierreBox.compact();
      await cierreBox.close();
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la DB del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la DB del dispositivo: ' + error.toString());
    }
  }

  Future<void> insertDummyCierres() async {
    int i = 1;
    while (i < 10) {
      CierreLote cierre = new CierreLote();
      cierre.codigoRespuesta = 10;
      cierre.estado = 'FIN';
      cierre.id = i;
      cierre.mensajeRespuesta = 'CIERRE OK!';
      cierre.segundosConsultar = 120;
      cierre.token = 'wfewefwefwefwefwf';
      cierre.user = 'bbrizolara7@gmail.com';
      cierre.xmlRespuesta = 'wefwefwefwefwefwefwefwefwefwefwef';
      cierre.fecha = new DateTime.now();
      await insertCierreLote(cierre);
      i++;
    }
  }
}
