import 'package:hive/hive.dart';
import 'package:mpos/src/database/cierre_lote_database.dart';
import 'package:mpos/src/database/empresa_database.dart';
import 'package:mpos/src/database/numerador_database.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/database/transaccion_database.dart';
import 'package:mpos/src/modelo/cierre_lote_modelo.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/modelo/enums/cierre_lote_estado.dart';
import 'package:mpos/src/modelo/enums/my_device_type_modelo.dart';
import 'package:mpos/src/modelo/enums/tipo_parametro.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:mpos/src/modelo/moneda_modelo.dart';
import 'package:mpos/src/modelo/my_device_modelo.dart';
import 'package:mpos/src/modelo/numerador_modelo.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/modelo/transaccion_modelo.dart';

class MposBD {
  //registrar adapters
  //cada uno tiene su identificador comentado, NO SE DEBE MODIFICAR el valor
  Future<void> initDb() async {
    if (!Hive.isAdapterRegistered(0))
      Hive.registerAdapter(ParametroAdapter()); //0
    if (!Hive.isAdapterRegistered(1))
      Hive.registerAdapter(TipoParametroAdapter()); //1
    if (!Hive.isAdapterRegistered(2))
      Hive.registerAdapter(EmpresaAdapter()); //2
    if (!Hive.isAdapterRegistered(3))
      Hive.registerAdapter(TipoTransaccionAdapter()); //3
    if (!Hive.isAdapterRegistered(4))
      Hive.registerAdapter(TransaccionAdapter()); //4
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(MonedaAdapter()); //5
    if (!Hive.isAdapterRegistered(6))
      Hive.registerAdapter(NumeradorAdapter()); //6
    if (!Hive.isAdapterRegistered(7))
      Hive.registerAdapter(CierreLoteAdapter()); //7
    if (!Hive.isAdapterRegistered(8))
      Hive.registerAdapter(MyDeviceAdapter()); //8
    if (!Hive.isAdapterRegistered(9))
      Hive.registerAdapter(MyDeviceTypeAdapter()); //9
    if (!Hive.isAdapterRegistered(10))
      Hive.registerAdapter(CierreLoteEstadoAdapter()); //10
  }

  static deleteAll() async {
    try {
      EmpresaDatabase empDb = new EmpresaDatabase();
      await empDb.deleteAllEmpresas();
      TransaccionDatabase trnDb = new TransaccionDatabase();
      await trnDb.deleteAllTrns();
      ParametroDatabase paramDb = new ParametroDatabase();
      await paramDb.deleteAllParametros();
      NumeradorDatabase numDb = new NumeradorDatabase();
      await numDb.deleteAllNumeradores();
      CierreLoteDatabase cierreDb = new CierreLoteDatabase();
      await cierreDb.deleteAllCierres();
    } catch (error) {}
  }
}
