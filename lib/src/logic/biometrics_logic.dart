import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/logic/xml/logic_xmlwebservice.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/utils/logger_utils.dart' as loggin;
import 'auth_login_logic.dart';

Future<bool> isBiometricAvailable() async {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  bool isAvailable = false;
  try {
    isAvailable = await _localAuthentication.canCheckBiometrics;
  } on PlatformException catch (e, s) {
    loggin.loguearError(e, s);
  }
  return isAvailable;
}

Future<void> getListOfBiometricTypes() async {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  List<BiometricType> listOfBiometrics;
  try {
    listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
  } on PlatformException catch (e, s) {
    loggin.loguearError(e, s);
  }

  return listOfBiometrics;
}

Future<void> authenticateUser(BuildContext context, Empresa empresa) async {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool isAuthenticated = false;
  try {
    isAuthenticated = await _localAuthentication.authenticate(
      biometricOnly: true,
      localizedReason: "Debe autenticarse para acceder al sistema",
      useErrorDialogs: true,
      androidAuthStrings: AndroidAuthMessages(
          signInTitle: 'mPOS NAD',
          biometricHint: 'Huella dactilar',
          cancelButton: "Cancelar"),
      stickyAuth: true,
    );
  } on PlatformException catch (e, s) {
    loggin.loguearError(e, s);
  }

  if (isAuthenticated) {
    LoginBloc bloc = Provider.loginBloc(context);
    bloc.changeEmpresa(empresa);
    if (empresa.usuarioLogueado.isEmpty ||
        empresa.usuarioLogueadoPassword.isEmpty) {
      EasyLoading.showError('Ingrese usuario y contraseña');
    } else {
      EasyLoading.show(dismissOnTap: false, status: "Autenticando");
      var loginStr = empresa.usuarioLogueado.toLowerCase() +
          ':' +
          empresa.usuarioLogueadoPassword;
      var loginBytes = utf8.encode(loginStr);
      var loginBase64 = base64.encode(loginBytes);
      String xml = ensamblarXMLLogin(loginBase64);
      llamarWsLogin(context, xml);
    }
  }
}
