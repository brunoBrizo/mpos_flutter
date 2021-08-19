import 'package:hive/hive.dart';
import 'package:mpos/src/modelo/enums/tipo_parametro.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';

class ParametroDatabase {
  Box parametroBox;

  Future<Box> initParametro() async {
    try {
      bool existe = await Hive.boxExists('parametro');
      if (existe) {
        parametroBox = await Hive.openBox('parametro');
        return parametroBox;
      } else {
        throw new Exception('No existe definición para tabla Parametros');
      }
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + error.toString());
    }
  }

  Future<void> insertParametro(int index, Parametro parametro) async {
    try {
      parametroBox = await Hive.openBox('parametro');
      await parametroBox.put(index, parametro);
    } on Exception catch (exception) {
      throw new Exception('Error guardando parametro: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error guardando parametro: ' + error.toString());
    }
  }

  Future<Parametro> getParametro(int index) async {
    try {
      parametroBox = await Hive.openBox('parametro');
      Parametro param = await parametroBox.get(index);
      return param;
    } on Exception catch (exception) {
      throw new Exception(
          'Error obteniendo parametro: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error obteniendo parametro: ' + error.toString());
    }
  }

  //ya estan cargados desde que se hizo openBox
  Future<Box> getAllParametros() async {
    try {
      parametroBox = await Hive.openBox('parametro');
      return parametroBox;
    } on Exception catch (exception) {
      throw new Exception(
          'Error obteniendo parametros: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error obteniendo parametros: ' + error.toString());
    }
  }

  Future updateParametro(int index, Parametro parametro) async {
    try {
      parametroBox = await Hive.openBox('parametro');
      await parametroBox.put(index, parametro);
    } on Exception catch (exception) {
      throw new Exception(
          'Error actualizando parametro: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error actualizando parametro: ' + error.toString());
    }
  }

  Future deleteAllParametros() async {
    try {
      parametroBox = await Hive.openBox('parametro');
      await parametroBox.clear();
      await this.dispose();
    } on Exception catch (exception) {
      throw new Exception('Error borrando parametros: ' + exception.toString());
    } catch (error) {
      throw new Exception('Error borrando parametros: ' + error.toString());
    }
  }

  Future<void> dispose() async {
    try {
      if (parametroBox.isOpen) {
        await parametroBox.compact();
        await parametroBox.close();
      }
    } on Exception catch (exception) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error accediendo a la BD del dispositivo: ' + error.toString());
    }
  }

  Future<void> createBaseParametros() async {
    try {
      parametroBox = await Hive.openBox('parametro');

      if (parametroBox.values.length == 0) {
        parametroBox.clear();
        Parametro parametro = new Parametro(TipoParametro.Notificacion, '3');
        await insertParametro(1, parametro);

        parametro = new Parametro(TipoParametro.Conexion, '2');
        await insertParametro(2, parametro);

        parametro = new Parametro(TipoParametro.URL_AdminWeb,
            'https://wwwi.transact.com.uy/AdminWeb/');
        await insertParametro(3, parametro);

        parametro = new Parametro(TipoParametro.URL_Concentrador,
            'https://wwwi.transact.com.uy/concentrador/');
        await insertParametro(4, parametro);

        parametro = new Parametro(TipoParametro.LoginEmail, '');
        await insertParametro(5, parametro);

        parametro = new Parametro(TipoParametro.DiasEliminarTickets, '20');
        await insertParametro(6, parametro);

        parametro = new Parametro(TipoParametro.LoginPassword, '');
        await insertParametro(7, parametro);
      }
      await this.dispose();
    } on Exception catch (exception) {
      throw new Exception(
          'Error creando parametros por defecto: ' + exception.toString());
    } catch (error) {
      throw new Exception(
          'Error creando parametros por defecto: ' + error.toString());
    }
  }
}
