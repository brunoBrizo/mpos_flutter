import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/database.dart';
import 'package:mpos/src/database/empresa_database.dart';
import 'package:mpos/src/database/numerador_database.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/logic/biometrics_logic.dart';
import 'package:mpos/src/logic/webservice_logic.dart';
import 'package:mpos/src/logic/xml/logic_xmlwebservice.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/modelo/enums/tipo_parametro.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/utils/popup_multiselect_utils.dart';
import 'package:mpos/src/utils/logger_utils.dart' as loggin;
import 'package:mpos/src/utils/general_utils.dart' as utils;

login(BuildContext context, LoginBloc bloc) async {
  try {
    if ((bloc.email == null || bloc.email.isEmpty) &&
        (bloc.password == null || bloc.password.isEmpty)) {
      bool loginResult = (utils.isWeb() || utils.isWindowsDesktop())
          ? false
          : await authLogin(context);
      if (!loginResult) EasyLoading.showError('Ingrese usuario y contraseña');
    } else if (bloc.email.isEmpty || bloc.password.isEmpty) {
      EasyLoading.showError('Ingrese usuario y contraseña');
    } else {
      EasyLoading.show(dismissOnTap: false, status: "Autenticando");
      var loginStr = bloc.email.toLowerCase().trim() + ':' + bloc.password;
      var loginBytes = utf8.encode(loginStr);
      var loginBase64 = base64.encode(loginBytes);
      String xml = ensamblarXMLLogin(loginBase64);

      //evaluo si es la primera vez en el dispositivo
      EmpresaDatabase empDb = new EmpresaDatabase();
      Empresa empLogueada = await empDb.getEmpresa(1);
      if (empLogueada == null) {
        bloc.changeIsFirstTime(true);
      } else {
        bloc.changeIsFirstTime(false);
      }

      llamarWsLogin(context, xml);
    }
  } catch (e, s) {
    loggin.loguearError(e, s);
  }
}

Future<bool> authLogin(BuildContext context) async {
  if (utils.isWeb() || utils.isWindowsDesktop())
    return false;
  else {
    bool loginResult = false;
    EmpresaDatabase empDb = new EmpresaDatabase();
    Empresa emp = await empDb.getEmpresa(1);

    if (emp == null) {
      loginResult = false;
    } else {
      if (emp.usuarioLogueado != null && emp.usuarioLogueadoPassword != null) {
        if (emp.usuarioLogueado.isNotEmpty &&
            emp.usuarioLogueadoPassword.isNotEmpty) {
          if (isBiometricAvailable() == null) {
            loginResult = false;
          } else {
            Provider.loginBloc(context).changeEmpresa(emp);
            getListOfBiometricTypes();
            authenticateUser(context, emp);
          }
        } else {
          loginResult = false;
        }
      } else {
        loginResult = false;
      }
    }
    return loginResult;
  }
}

llamarWsLogin(BuildContext context, String xml) async {
  LoginBloc bloc = Provider.loginBloc(context);
  try {
    bool redireccionar;

    await callWSLogin(context, xml);
    int errorCod = bloc.errorCod;
    String errorMsg = bloc.errorMsg;
    Empresa emp = bloc.empresa;
    EmpresaDatabase empDb = new EmpresaDatabase();
    Empresa empLogueada = await empDb.getEmpresa(1);
    String terminalEnUso = '';
    String usuarioEnUso = '';
    bool limpiarBD = false;
    List<String> lstTerminal = bloc.lstTerminal;

    if (errorCod != 1) {
      EasyLoading.showError(errorMsg);
      redireccionar = false;
    } else {
      EasyLoading.dismiss();
      if (empLogueada != null) {
        terminalEnUso = empLogueada.codigoTerminal;
        usuarioEnUso = empLogueada.usuarioLogueado;
        if (empLogueada.rut != emp.rut || usuarioEnUso != emp.usuarioLogueado) {
          limpiarBD = true;
          empLogueada = null;
        }
      }

      if (emp.codigoTerminal.isNotEmpty) {
        if (terminalEnUso != null &&
            terminalEnUso.isNotEmpty &&
            emp.codigoTerminal != terminalEnUso) {
          limpiarBD = true;
        }
        redireccionar = true;
      } else {
        bool asociarTerm = false;
        if (lstTerminal.length == 0) {
          EasyLoading.showError("No se encontraron terminales para asociar.");
          redireccionar = false;
        } else if (lstTerminal.length == 1) {
          if (terminalEnUso.isNotEmpty && terminalEnUso != lstTerminal[0]) {
            limpiarBD = true;
          }
          emp.codigoTerminal = lstTerminal[0];
          redireccionar = true;
        } else {
          String terminal = await showMultiSelect(context, lstTerminal);
          if (terminalEnUso.isNotEmpty && terminal != terminalEnUso) {
            limpiarBD = true;
          }
          emp.codigoTerminal = terminal;
          asociarTerm = true;
        }
        if (asociarTerm) {
          String xmlAsociarTerminal = ensamblarXMLAsociarTerminal(emp);
          redireccionar =
              await callWSAsociarTerminal(context, xmlAsociarTerminal);
        }
      }
    }

    if (limpiarBD) {
      await MposBD.deleteAll();
      ParametroDatabase paramDb = new ParametroDatabase();
      await paramDb.createBaseParametros();
      NumeradorDatabase numDb = NumeradorDatabase();
      await numDb.createBaseNumeradores();
    }

    if (redireccionar) {
      guardarDatosEmpresa(emp);
      ParametroDatabase paramDb = new ParametroDatabase();
      Parametro paramLogin =
          new Parametro(TipoParametro.LoginEmail, bloc.email);
      paramDb.updateParametro(5, paramLogin);

      //TODO: implementar llamada a ws de admin web para consumir transacciones si es la primera vez en el dispositivo

      bloc.changeIsFirstTime(false);
      Navigator.pushReplacementNamed(context, 'home');
    }
  } on Exception catch (exception) {
    EasyLoading.showError(exception.toString());
  } catch (error) {
    EasyLoading.showError(error.toString());
  }
}

guardarDatosEmpresa(Empresa emp) async {
  try {
    EmpresaDatabase empDb = new EmpresaDatabase();
    await empDb.initEmpresa();
    await empDb.insertEmpresa(1, emp);
  } on Exception catch (exception) {
    EasyLoading.showError(exception.toString());
  } catch (error) {
    EasyLoading.showError(error.toString());
  }
}

Future<String> showMultiSelect(
    BuildContext context, List<String> lstTerminal) async {
  String terminal;
  final items = <MultiSelectDialogItem<int>>[];

  int i = 0;
  for (String terminal in lstTerminal) {
    items.add(MultiSelectDialogItem(i, terminal));
    i++;
  }
  final selectedValues = await showDialog<Set<int>>(
    context: context,
    builder: (BuildContext context) {
      return MultiSelectDialog(
        items: items,
      );
    },
  );

  if (selectedValues != null) {
    for (int x in selectedValues.toList()) {
      terminal = lstTerminal[x];
    }
  }

  return terminal;
}
