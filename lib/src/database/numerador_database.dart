import 'package:hive/hive.dart';
import 'package:mpos/src/modelo/numerador_modelo.dart';

class NumeradorDatabase {
  Box numeradorBox;

  Future<Box> initNumerador() async {
    try {
      numeradorBox = await Hive.openBox('numerador');
      return numeradorBox;
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + error.toString());
    }
  }

  Future<void> insertNumerador(int index, Numerador numerador) async {
    try {
      await numeradorBox.put(index, numerador);
    } on Exception catch (exception) {
      throw new Exception('Error guardando numerador: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error guardando numerador: ' + error.toString());
    }
  }

  //ya estan cargados desde que se hizo openBox
  Future<Box> getAllNumeradores() async {
    try {
      numeradorBox = await Hive.openBox('numerador');
      return numeradorBox;
    } on Exception catch (exception) {
      throw new Exception(
          'Error obteniendo numeradores: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error obteniendo numeradores: ' + error.toString());
    }
  }

  Future updateNumerador(int index, Numerador numerador) async {
    try {
      numeradorBox = await Hive.openBox('numerador');
      await numeradorBox.put(index, numerador);
    } on Exception catch (exception) {
      throw new Exception(
          'Error actualizando numerador: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error actualizando numerador: ' + error.toString());
    }
  }

  Future<Numerador> getNumerador(int index) async {
    Numerador numerador;
    try {
      numeradorBox = await Hive.openBox('numerador');
      numerador = await numeradorBox.get(index);
    } on Exception catch (exception) {
      throw new Exception(
          'Error obteniendo numerador: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error obteniendo numerador: ' + error.toString());
    }
    return numerador;
  }

  Future<void> deleteAllNumeradores() async {
    try {
      numeradorBox = await Hive.openBox('numerador');
      await numeradorBox.clear();
      await this.dispose();
    } on Exception catch (exception) {
      throw new Exception(
          'Error eliminando numeradores: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error eliminando numeradores: ' + error.toString());
    }
  }

  Future<void> dispose() async {
    try {
      await numeradorBox.compact();
      await numeradorBox.close();
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + error.toString());
    }
  }

  Future<void> createBaseNumeradores() async {
    try {
      numeradorBox = await Hive.openBox('numerador');
      if (numeradorBox.values.length == 0) {
        await numeradorBox.clear();

        Numerador numerador = new Numerador('TRN', 1);
        await insertNumerador(1, numerador);

        numerador = new Numerador('CLOTE', 1);
        await insertNumerador(2, numerador);
      }
      await this.dispose();
    } on Exception catch (exception) {
      throw new Exception(
          'Error creando numeradores base: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error creando numeradores base: ' + error.toString());
    }
  }
}
