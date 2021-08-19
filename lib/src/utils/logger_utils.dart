import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;

void loguearError(Exception source, StackTrace stackTrace) async {
  if (!utils.isWeb()) {
    try {
      ParametroDatabase parametroDb = new ParametroDatabase();
      Box parametroBox;
      parametroBox = await parametroDb.initParametro();

      Parametro paramUrlConcentrador = parametroBox.get(4);
      Parametro paramUrlAdminWeb = parametroBox.get(3);
      Parametro loginUser = parametroBox.get(5);

      String parametrosActuales = "PARAMETROS ACTUALES:" +
          "\n" +
          "<URL CONCENTRADOR=" +
          paramUrlConcentrador.valor +
          "/>\n";
      parametrosActuales +=
          "<URL ADMIN WEB= " + paramUrlAdminWeb.valor + "/>\n";
      parametrosActuales += "<LOGIN USER= " +
          (loginUser.valor == null ? "NO DISPONIBLE" : loginUser.valor) +
          "/>\n";
      parametrosActuales += ".\n" + source.toString();
      FirebaseCrashlytics.instance
          .recordError(new Exception(parametrosActuales), stackTrace);
      FirebaseCrashlytics.instance.sendUnsentReports();
    } catch (e) {
      if (!utils.isWeb()) EasyLoading.showError("Error: " + e.toString());
    }
  }
}
