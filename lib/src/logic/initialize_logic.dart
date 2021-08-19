//import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:mpos/src/utils/logger_utils.dart' as loggin;
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:mpos/src/database/database.dart';
import 'package:mpos/src/database/numerador_database.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/database/transaccion_database.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:window_size/window_size.dart';
import 'package:permission_handler/permission_handler.dart';

inicializar(BuildContext context) async {
  try {
    MposBD mposBD = new MposBD();
    await mposBD.initDb();

    ParametroDatabase parametroDatabase = new ParametroDatabase();
    await parametroDatabase.createBaseParametros();
    Parametro paramDiasEliminarTickets =
        await parametroDatabase.getParametro(6);

    NumeradorDatabase numeradorDatabase = new NumeradorDatabase();
    await numeradorDatabase.createBaseNumeradores();

    TransaccionDatabase trnDb = new TransaccionDatabase();
    Duration diasEliminarTickets =
        new Duration(days: int.parse(paramDiasEliminarTickets.valor) * -1);
    await trnDb.deleteTrnsByDate(diasEliminarTickets);

    if (utils.isMobile(context)) {
      firebaseConfig();
      inicializarPermisos(context);
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white54, statusBarBrightness: Brightness.light));
  } on HiveError catch (e) {
    print(e);
  } catch (e, s) {
    loggin.loguearError(e, s);
  }
}

inicializarHive() async {
  if (!utils.isWeb()) {
    String appDocumentDirectory = "";
    appDocumentDirectory = await utils.obtenerPathHive();
    Hive.init(appDocumentDirectory);
  }
}

inicializarSizeWindows() {
  if (utils.isWindowsDesktop() ||
      utils.isLinuxDesktop() ||
      utils.isMacOSDesktop()) {
    setWindowMinSize(const Size(1000, 800));
    setWindowMaxSize(const Size(1200, 1000));
  }
}

firebaseConfig() async {
  await Firebase.initializeApp();
  try {
    // final RemoteConfig remoteConfig = RemoteConfig.instance;
    // await remoteConfig.setConfigSettings(RemoteConfigSettings(
    //   minimumFetchInterval: Duration(milliseconds: 10000),
    //   fetchTimeout: Duration(seconds: 5),
    // ));
    // await remoteConfig.fetch();
    // await remoteConfig.activate();

    // String paramURLAdminWeb = remoteConfig.getString('PARAM_URL_ADMINWEB');
    // String paramURLConcentrador =
    //     remoteConfig.getString('PARAM_URL_CONCENTRADOR');
    // ParametroDatabase parametroDb = new ParametroDatabase();
    // Box parametroBox = await parametroDb.getAllParametros();
    // if (paramURLConcentrador != null && paramURLConcentrador.isNotEmpty) {
    //   Parametro _urlConcentrador = parametroBox.get(4);
    //   if (_urlConcentrador.valor != paramURLConcentrador) {
    //     _urlConcentrador.valor = paramURLConcentrador;
    //     await parametroDb.updateParametro(4, _urlConcentrador);
    //   }
    // }
    // if (paramURLAdminWeb != null && paramURLAdminWeb.isNotEmpty) {
    //   Parametro _urlAdminWeb = parametroBox.get(3);
    //   if (_urlAdminWeb.valor != paramURLAdminWeb) {
    //     _urlAdminWeb.valor = paramURLAdminWeb;
    //     await parametroDb.updateParametro(3, _urlAdminWeb);
    //   }

    //   if (parametroDb.parametroBox.isOpen) {
    //     await parametroDb.dispose();
    //   }
    //   }
  } catch (e, s) {
    loggin.loguearError(e, s);
  }
}

inicializarPermisos(BuildContext context) async {
  if (utils.isMobile(context)) {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      print("Es necesario asignar permisos.");
      if (await Permission.storage.request().isGranted) {
        print("Se asignaron.");
      } else
        print("No se asignaron.");
    }
  }
}
