import 'package:hive/hive.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';

class EmpresaDatabase {
  Box empresaBox;

  Future<Box> initEmpresa() async {
    try {
      empresaBox = await Hive.openBox('empresa');
      return empresaBox;
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + error.toString());
    }
  }

  Future<Empresa> getEmpresa(int index) async {
    Empresa emp;
    try {
      empresaBox = await Hive.openBox('empresa');
      emp = await empresaBox.get(index);
    } on Exception catch (exception) {
      throw new Exception('Error obteniendo empresa: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error obteniendo empresa: ' + error.toString());
    }
    return emp;
  }

  Future<void> insertEmpresa(int index, Empresa empresa) async {
    try {
      await empresaBox.clear();
      await empresaBox.put(index, empresa);
    } on Exception catch (exception) {
      throw new Exception('Error guardando empresa: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error guardando empresa: ' + error.toString());
    }
  }

  Future updateEmpresa(int index, Empresa empresa) async {
    try {
      empresaBox = await Hive.openBox('empresa');
      await empresaBox.put(index, empresa);
    } on Exception catch (exception) {
      throw new Exception(
          'Error actualizando empresa: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error actualizando empresa: ' + error.toString());
    }
  }

  Future deleteEmpresa(int index) async {
    try {
      empresaBox = await Hive.openBox('empresa');
      await empresaBox.delete(index);
    } on Exception catch (exception) {
      throw new Exception('Error borrando empresa: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error borrando empresa: ' + error.toString());
    }
  }

  Future deleteAllEmpresas() async {
    try {
      empresaBox = await Hive.openBox('empresa');
      await empresaBox.clear();
      await this.dispose();
    } on Exception catch (exception) {
      throw new Exception('Error borrando empresas: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error borrando empresas: ' + error.toString());
    }
  }

  Future<void> dispose() async {
    try {
      await empresaBox.compact();
      await empresaBox.close();
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + error.toString());
    }
  }
}
