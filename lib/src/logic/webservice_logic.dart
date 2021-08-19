import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mpos/src/bloc/datos_cierre_lote_bloc.dart';
import 'package:mpos/src/bloc/datos_cierre_lote_respuesta_bloc.dart';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/datos_transaccionrespuesta.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/logic/xml/logic_xmlwebservice.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'dart:convert';
import 'package:xml/xml.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/utils/logger_utils.dart' as loggin;
import 'package:mpos/src/utils/general_utils.dart' as utils;

//transaccion
Future<bool> callWSPostearTransaccion(BuildContext context, String xml) async {
  bool postearTransaccion = false;
  DatosTransaccionBloc bloc = Provider.datosTransaccionBloc(context);
  try {
    ParametroDatabase parametroDb = new ParametroDatabase();
    Box paramBox = await parametroDb.getAllParametros();
    Parametro paramUrlConcentrador = await paramBox.get(4); //url concentrador
    String urlPostear =
        paramUrlConcentrador.valor + 'TarjetasTransaccion_400.svc';
    Map<String, String> headers = {
      'Content-Type': 'text/xml',
      'SoapAction':
          'http://tempuri.org/ITarjetasTransaccion_400/PostearTransaccion'
    };

    http.Response response = await http.post(
      Uri.parse(urlPostear),
      headers: headers,
      body: xml,
    );

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);

      Iterable<XmlElement> lst =
          document.findAllElements("PostearTransaccionResult");

      String tokenNro, mensajeRespuesta, codigoRespuesta;
      int tokenSegundosConsultar;

      if (lst.isNotEmpty) {
        for (XmlElement elem in lst.first.children) {
          if (elem.name.local == "Resp_MensajeError")
            mensajeRespuesta = elem.text;
          if (elem.name.local == "TokenSegundosConsultar")
            tokenSegundosConsultar = int.parse(elem.text);
          if (elem.name.local == "Resp_CodigoRespuesta")
            codigoRespuesta = elem.text;
          if (elem.name.local == "TokenNro") tokenNro = elem.text;
        }
      }

      bloc.changeCodigoRespuesta(codigoRespuesta);
      bloc.changeMensajeRespuesta(mensajeRespuesta);
      bloc.changeTokenNro(tokenNro);
      bloc.changeTokenSegundos(tokenSegundosConsultar);
      EasyLoading.init();
      if (codigoRespuesta == "0") {
        bool finalizada = false;
        double progreso = 0.1;
        while (!finalizada) {
          if ((progreso + 0.1) >= 1) progreso = 0.1;
          EasyLoading.showProgress((progreso += 0.1),
              status:
                  mensajeRespuesta + "\nConsultando estado a concentrador.");

          String xml = ensamblarXMLConsultarTransaccion(tokenNro);

          finalizada =
              await callWSConsultarTransaccion(context, bloc, xml, urlPostear);
          if (!finalizada) {
            if (utils.isWeb()) {
              await new Future.delayed(
                  new Duration(seconds: bloc.tokenSegundos));
            } else {
              sleep(new Duration(seconds: bloc.tokenSegundos));
            }
          }
        }

        if (bloc.transaccionAprobada)
          postearTransaccion = true;
        else
          postearTransaccion = false;
      }
    } else {
      throw new Exception(
          "WSConcentrador responde error: " + response.statusCode.toString());
    }
  } on Exception catch (e, s) {
    loggin.loguearError(e, s);
    bloc.changeCodigoRespuesta('100');
    bloc.changeMensajeRespuesta(
        'Error iniciando transacción. No se pudo establecer conexión con el servidor. ' +
            e.toString());
    postearTransaccion = false;
  } catch (error) {
    bloc.changeMensajeRespuesta(
        'Error iniciando transacción. No se pudo establecer conexión con el servidor. ' +
            error.toString());
  }
  return postearTransaccion;
}

Future<bool> callWSConsultarTransaccion(BuildContext context,
    DatosTransaccionBloc bloc, String xml, String urlPostear) async {
  bool finalizada = false;
  try {
    Map<String, String> headers = {
      'Content-Type': 'text/xml;charset=UTF-8',
      'SoapAction':
          'http://tempuri.org/ITarjetasTransaccion_400/ConsultarTransaccion'
    };
    http.Response response = await http.post(
      Uri.parse(urlPostear),
      headers: headers,
      body: xml,
    );

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      Iterable<XmlElement> lst =
          document.findAllElements("ConsultarTransaccionResult");

      if (lst.isNotEmpty) {
        for (XmlElement elem in lst.first.children) {
          if (elem.name.local == "MsgRespuesta")
            bloc.changeMensajeRespuesta(elem.text);
          if (elem.name.local == "Resp_EstadoAvance")
            bloc.changeEstadoAvanceConcentrador(elem.text);
          if (elem.name.local == "Resp_TransaccionFinalizada")
            bloc.changeTransaccionFinalizada(
                (elem.text.toUpperCase() == "TRUE") ? true : false);
          if (elem.name.local == "TokenSegundosConsultar")
            bloc.changeTokenSegundos(int.parse(elem.text));
          if (elem.name.local == "Resp_CodigoRespuesta")
            bloc.changeCodigoRespuesta(elem.text);
          if (elem.name.local == "TokenNro") bloc.changeTokenNro(elem.text);
          if (elem.name.local == "Aprobada")
            bloc.changeTransaccionAprobada(
                (elem.text.toUpperCase() == "TRUE") ? true : false);
        }
      }
      if (bloc.transaccionFinalizada) {
        insertarDatosTrnRespuestaBloc(context, lst, bloc);
        finalizada = true;
      } else
        finalizada = false;
    } else {
      throw new Exception(
          "WSConcentrador responde error: " + response.statusCode.toString());
    }
  } on Exception catch (e, s) {
    loggin.loguearError(e, s);
    finalizada = true;
    bloc.changeMensajeRespuesta(
        'Error consultando transacción. Error ' + e.toString());
  } catch (error) {
    finalizada = true;
    bloc.changeMensajeRespuesta(
        'Error consultando transacción. Error: ' + error.toString());
  }
  return finalizada;
}

void insertarDatosTrnRespuestaBloc(BuildContext context,
    Iterable<XmlElement> respuesta, DatosTransaccionBloc blocTrn) {
  DatosTransaccionRespuestaBloc blocResp =
      Provider.datosTransaccionRespuestaBloc(context);
  LoginBloc blocLogin = Provider.loginBloc(context);

  for (XmlElement elem in respuesta.first.children) {
    if (elem.name.local == "Aprobada")
      blocResp
          .changeAprobada((elem.text.toUpperCase() == "TRUE") ? true : false);
    if (elem.name.local == "Resp_CodigoRespuesta")
      blocResp.changeCodigoRespuesta(elem.text);
    if (elem.name.local == "Voucher") blocResp.changeVoucher(elem.text);
    if (elem.name.local == "MsgRespuesta")
      blocResp.changeMensajeRespuesta(elem.text);
  }

  if (blocResp.aprobada) {
    blocResp.changeNroFactura(blocTrn.numFactura);
    blocResp.changeUser(blocLogin.email);
    blocResp.changeTipoTransaccion(blocTrn.tipoTransaccion);
    blocResp.changeMoneda(blocTrn.moneda);
    blocResp.changeFueDevuelto(false);
    for (XmlElement elem in respuesta.first.children) {
      if (elem.name.local == "TransaccionId")
        blocResp.changeId(int.tryParse(elem.text));

      if (elem.name.local == "NroAutorizacion")
        blocResp.changeNroAutorizacion(elem.text);
      if (elem.name.local == "Ticket")
        blocResp.changeTicket(int.tryParse(elem.text));
      if (elem.name.local == "TokenNro") blocResp.changeTokenNro(elem.text);
      if (elem.name.local == "TarjetaId")
        blocResp.changeTarjetaId(int.tryParse(elem.text));

      //aca la parte de DatosTransaccion
      if (elem.name.local == "DatosTransaccion") {
        XmlElement datosTrn = elem;

        for (XmlNode elemDatos in datosTrn.nodes) {
          if (elemDatos.firstChild != null) {
            if (elemDatos.firstChild.parentElement.name.local == "Cuotas")
              blocResp.changeCuotas(int.tryParse(elemDatos.text));
            if (elemDatos.firstChild.parentElement.name.local == "Monto")
              blocResp.changeMonto(double.tryParse(elemDatos.text) / 100);
            if (elemDatos.firstChild.parentElement.name.local == "MontoPropina")
              blocResp
                  .changeMontoPropina(double.tryParse(elemDatos.text) / 100);
            if (elemDatos.firstChild.parentElement.name.local ==
                "DecretoLeyMonto")
              blocResp
                  .changeDecretoLeyMonto(double.tryParse(elemDatos.text) / 100);
            if (elemDatos.firstChild.parentElement.name.local == "TarjetaNro")
              blocResp.changeTarjetaNumero(elemDatos.text);

            // //aca la parte de extendida
            if (elemDatos.firstChild.parentElement.name.local == "Extendida") {
              for (XmlElement elemExtendida in elemDatos.children) {
                if (elemExtendida.name.local == "TransaccionFechaHora")
                  blocResp.changeFecha(DateTime.tryParse(elemExtendida.text));
                if (elemExtendida.name.local == "FacturaMonto")
                  blocResp.changeFacturaMonto(
                      double.tryParse(elemExtendida.text) / 100);
                if (elemExtendida.name.local == "FacturaMontoGravado")
                  blocResp.changeFacturaMontoGravado(
                      double.tryParse(elemExtendida.text) / 100);
                if (elemExtendida.name.local == "FacturaMontoIVA")
                  blocResp.changeFacturaMontoIva(
                      double.tryParse(elemExtendida.text) / 100);
                if (elemExtendida.name.local == "FirmarVoucher")
                  blocResp.changeFirmarVoucher(
                      (elemExtendida.text.toUpperCase() == "TRUE")
                          ? true
                          : false);
                if (elemExtendida.name.local == "TarjetaNombre")
                  blocResp.changeTarjetaNombre(elemExtendida.text);
                if (elemExtendida.name.local == "TarjetaTitular")
                  blocResp.changeTarjetaTitular(elemExtendida.text);
                if (elemExtendida.name.local == "MerchantID")
                  blocResp.changeMID(elemExtendida.text);
                if (elemExtendida.name.local == "TerminalID")
                  blocResp.changeTerminalId(int.tryParse(elemExtendida.text));
              }
            }
          }
        }
      }
    }
  }
  blocTrn.changerespuestaTransaccion(blocResp);
}

//cierre de lote
Future<bool> callWSPostearCierreLote(BuildContext context, String xml) async {
  bool postearCierreLote = false;
  DatosCierreLote blocCierre = Provider.datosCierreLoteBloc(context);
  try {
    ParametroDatabase parametroDb = new ParametroDatabase();
    Box paramBox = await parametroDb.getAllParametros();
    Parametro paramUrlConcentrador = await paramBox.get(4); //url concentrador
    String urlPostear = paramUrlConcentrador.valor + 'TarjetasCierre_400.svc';

    Map<String, String> headers = {
      'Content-Type': 'text/xml;charset=UTF-8',
      'SoapAction': 'http://tempuri.org/ITarjetasCierre_400/PostearCierre'
    };

    http.Response response = await http.post(
      Uri.parse(urlPostear),
      headers: headers,
      body: xml,
    );

    EasyLoading.init();
    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);

      //cambiar valor
      Iterable<XmlElement> lst =
          document.findAllElements("PostearCierreResult");

      String tokenNro, mensajeRespuesta, codigoRespuesta;
      int tokenSegundosConsultar;

      if (lst.isNotEmpty) {
        for (XmlElement elem in lst.first.children) {
          if (elem.name.local == "Resp_MensajeError")
            mensajeRespuesta = elem.text;
          if (elem.name.local == "TokenSegundosConsultar")
            tokenSegundosConsultar = int.parse(elem.text);
          if (elem.name.local == "Resp_CodigoRespuesta")
            codigoRespuesta = elem.text;
          if (elem.name.local == "TokenNro") tokenNro = elem.text;
        }
      }

      if (codigoRespuesta == "0") {
        bool finalizada = false;
        double progreso = 0.1;
        while (!finalizada) {
          if ((progreso + 0.1) >= 1) progreso = 0.1;
          EasyLoading.showProgress((progreso += 0.1),
              status: mensajeRespuesta +
                  "\nConsultando estado a concentrador.\nPor favor espere.");

          String xml = ensamblarXMLConsultarCierreLote(tokenNro);
          finalizada =
              await callWSConsultarCierreLote(context, xml, urlPostear);
          if (utils.isWeb()) {
            await new Future.delayed(
                new Duration(seconds: tokenSegundosConsultar));
          } else {
            sleep(new Duration(seconds: tokenSegundosConsultar));
          }
        }
        if (blocCierre.respuesta != null) {
          bool cierreLoteOk = blocCierre.respuesta.finalizado;
          if (cierreLoteOk)
            postearCierreLote = true;
          else
            postearCierreLote = false;
        }
      }
    } else {
      blocCierre.changeMensajeError("Error posteando cierre de lote. Error " +
          response.statusCode.toString());
      postearCierreLote = false;
    }
  } on Exception catch (e, s) {
    loggin.loguearError(e, s);
    blocCierre.changeMensajeError(
        "Error posteando cierre de lote. Error " + e.toString());
  } catch (error) {
    blocCierre.changeMensajeError(
        "Error posteando cierre de lote. Error " + error.toString());
  }
  return postearCierreLote;
}

Future<bool> callWSConsultarCierreLote(
    BuildContext context, String xml, String urlPostear) async {
  bool finalizada = false;
  DatosCierreLoteRespuesta blocResp =
      Provider.datosCierreLoteRespuestaBloc(context);

  try {
    Map<String, String> headers = {
      'Content-Type': 'text/xml;charset=UTF-8',
      'SoapAction': 'http://tempuri.org/ITarjetasCierre_400/ConsultarCierre'
    };

    http.Response response = await http.post(
      Uri.parse(urlPostear),
      headers: headers,
      body: xml,
    );

    if (response.statusCode == 200) {
      blocResp.changeXmlRespuesta(response.body);
      final document = XmlDocument.parse(response.body);

      Iterable<XmlElement> lst =
          document.findAllElements("ConsultarCierreResult");

      bool cierreRealizado = false;
      if (lst.isNotEmpty) {
        cierreRealizado =
            insertarDatosCierreLoteRespuestaBloc(context, lst, blocResp);
      }

      if (cierreRealizado) {
        finalizada = true;
      } else
        finalizada = false;
    } else {
      throw new Exception(
          "WSConcentrador responde error: " + response.statusCode.toString());
    }
  } on Exception catch (e, s) {
    finalizada = true;
    blocResp.changeMensajeError(
        "Error consultando cierre de lote. " + e.toString());
    loggin.loguearError(e, s);
  } catch (error) {
    finalizada = true;
    blocResp.changeMensajeError(
        "Error consultando cierre de lote. Error " + error.toString());
  }
  return finalizada;
}

bool insertarDatosCierreLoteRespuestaBloc(BuildContext context,
    Iterable<XmlElement> respuesta, DatosCierreLoteRespuesta blocResp) {
  DatosCierreLote blocCierre = Provider.datosCierreLoteBloc(context);
  LoginBloc blocLogin = Provider.loginBloc(context);

  for (XmlElement elem in respuesta.first.children) {
    if (elem.name.local == "Resp_CierreFinalizado")
      blocResp
          .changeFinalizado((elem.text.toUpperCase() == "TRUE") ? true : false);
    if (elem.name.local == "Estado") blocResp.changeEstado(elem.text);
    if (elem.name.local == "Resp_CodigoRespuesta")
      blocResp.changeCodigoRespuesta(int.parse(elem.text));
    if (elem.name.local == "TokenNro") blocResp.changeTokenNro(elem.text);
    if (elem.name.local == "Resp_MensajeError")
      blocResp.changeMensajeError(elem.text);
  }
  blocResp.changeFecha(new DateTime.now());
  blocCierre.changeUser((blocLogin.email == null)
      ? (blocLogin.empresa.usuarioLogueado == null
          ? 'NO DISPONIBLE'
          : blocLogin.empresa.usuarioLogueado)
      : blocLogin.email);
  blocCierre.changeRespuesta(blocResp);
  return blocResp.finalizado;
}

//login
Future<void> callWSLogin(BuildContext context, String xml) async {
  LoginBloc blocLogin = Provider.loginBloc(context);
  try {
    ParametroDatabase parametroDb = new ParametroDatabase();
    Box paramBox = await parametroDb.getAllParametros();
    Parametro paramUrlConcentrador = await paramBox.get(3); //url adminweb
    String urlPostear =
        paramUrlConcentrador.valor + 'services.awsmposlogin.aspx';
    Map<String, String> headers;
    if (utils.isAndroid(context)) {
      headers = {
        'content-type': 'text/xml',
        'SOAPAction':
            'http://tempuri.org/T4WebKBaction/services.AWSMPOSLOGIN.Execute',
      };
    } else if (utils.isWeb()) {
      headers = {};
    }
    http.Response response = await http.post(
      Uri.parse(urlPostear),
      headers: headers,
      body: utf8.encode(xml),
    );
    if (response.statusCode == 200) {
      XmlDocument loginResponseDoc = XmlDocument.parse(response.body);

      Iterable<XmlElement> loginResponse =
          loginResponseDoc.findAllElements("Mposloginresponse");
      Empresa emp =
          new Empresa("", "", "", "", "", "", "", "", 0, "", "", false);
      int errorCod;
      String errorMsg;
      List<String> lstTerminales = [];

      if (loginResponse.isNotEmpty) {
        for (XmlNode elem in loginResponse.first.children) {
          if (elem.nodeType == XmlNodeType.ELEMENT) {
            if ((elem as XmlElement).name.local == "ErrCode") // <> 1 error
              errorCod = int.parse(elem.text);
            if ((elem as XmlElement).name.local == "ErrDsc")
              errorMsg = elem.text;
            if ((elem as XmlElement).name.local == "Hash") emp.hash = elem.text;
            if ((elem as XmlElement).name.local == "Token")
              emp.token = elem.text;

            //if ((elem as XmlElement).name.local == "TerTasaIVA") emp. = elem.text;

            if ((elem as XmlElement).name.local == "TerCod")
              emp.codigoTerminal = elem.text;

            if ((elem as XmlElement).name.local == "EmpID")
              emp.id = int.parse(elem.text);

            if ((elem as XmlElement).name.local == "EmpCod")
              emp.codigo = elem.text;

            if ((elem as XmlElement).name.local == "EmpNom")
              emp.nombre = elem.text;

            if ((elem as XmlElement).name.local == "EmpRUT")
              emp.rut = elem.text;

            if ((elem as XmlElement).name.local == "EmpRazSoc")
              emp.razonSocial = elem.text;

            if ((elem as XmlElement).name.local == 'TermList') {
              XmlElement listaTerminales = elem;

              for (XmlNode item in listaTerminales.children) {
                if (item.nodeType == XmlNodeType.ELEMENT) {
                  if ((item as XmlElement).name.local == "Item") // <> 1 error
                    lstTerminales.add(item.text);
                }
              }
            }
          }
        }
        if (errorCod == 1) {
          if (blocLogin.empresa != null) {
            if ((blocLogin.empresa.usuarioLogueado.isNotEmpty &&
                    blocLogin.empresa.usuarioLogueado != null) &&
                (blocLogin.empresa.usuarioLogueadoPassword != null &&
                    blocLogin.empresa.usuarioLogueadoPassword.isNotEmpty)) {
              emp.usuarioLogueado = blocLogin.empresa.usuarioLogueado;
              if ((blocLogin.empresa.usuarioLogueadoPassword ==
                      blocLogin.password) &&
                  (blocLogin.password != null && blocLogin.password.isNotEmpty))
                emp.usuarioLogueadoPassword =
                    blocLogin.empresa.usuarioLogueadoPassword;
              else if (blocLogin.password != null &&
                  blocLogin.password.isNotEmpty)
                emp.usuarioLogueadoPassword = blocLogin.password;
              else
                emp.usuarioLogueadoPassword =
                    blocLogin.empresa.usuarioLogueadoPassword;
            } else {
              emp.usuarioLogueado = blocLogin.email;
              emp.usuarioLogueadoPassword = blocLogin.password;
            }
          } else {
            emp.usuarioLogueado = blocLogin.email;
            emp.usuarioLogueadoPassword = blocLogin.password;
          }
          blocLogin.changeEmpresa(emp);
          blocLogin.changeLstTerminal(lstTerminales);
        }
        blocLogin.changeErrorCod(errorCod);
        blocLogin.changeErrorMsg(errorMsg);
      }
    } else {
      blocLogin.changeErrorMsg('Error conectando con el servidor. Error: ' +
          response.statusCode.toString());
    }
  } on Exception catch (e, s) {
    loggin.loguearError(e, s);
    blocLogin.changeErrorCod(2);
    blocLogin.changeErrorMsg(
        "Error conectando con el servidor. Error: " + e.toString());
  } catch (error) {
    blocLogin.changeErrorCod(2);
    blocLogin.changeErrorMsg(
        "Error comunicandose con el servidor. Error: " + error.toString());
  }
}

Future<bool> callWSAsociarTerminal(BuildContext context, String xml) async {
  LoginBloc blocLogin = Provider.loginBloc(context);
  bool terminalAsociada;
  try {
    ParametroDatabase parametroDb = new ParametroDatabase();
    Box paramBox = await parametroDb.getAllParametros();
    Parametro paramUrlConcentrador = await paramBox.get(3); //url adminweb
    String urlPostear =
        paramUrlConcentrador.valor + 'services.aWSMPOSAsociarTerminal.aspx';
    Map<String, String> headers;
    if (utils.isAndroid(context)) {
      headers = {
        'content-type': 'text/xml',
        'SOAPAction':
            'http://tempuri.org/T4WebKBaction/services.AWSMPOSASOCIARTERMINAL.Execute',
      };
    } else if (utils.isWeb()) {
      headers = {};
    }
    http.Response response = await http.post(
      Uri.parse(urlPostear),
      headers: headers,
      body: utf8.encode(xml),
    );

    if (response.statusCode == 200) {
      XmlDocument asociarTermResponseDoc = XmlDocument.parse(response.body);

      Iterable<XmlElement> asociarTermResponse =
          asociarTermResponseDoc.findAllElements("Mposasocterresponse");
      int errorCod;
      String errorMsg;

      if (asociarTermResponse.isNotEmpty) {
        for (XmlNode elem in asociarTermResponse.first.children) {
          if (elem.nodeType == XmlNodeType.ELEMENT) {
            // if ((elem as XmlElement).name.local == "TerTasaIVA")
            //   errorCod = int.parse(elem.text);
            if ((elem as XmlElement).name.local == "ErrCode")
              errorCod = int.parse(elem.text);
            if ((elem as XmlElement).name.local == "ErrDsc")
              errorMsg = elem.text;
          }
        }
        if (errorCod == 1) {
          terminalAsociada = true;
        }
        blocLogin.changeErrorCod(errorCod);
        blocLogin.changeErrorMsg(errorMsg);
      }
    } else {
      blocLogin.changeErrorMsg('Error conectando con el servidor. Error: ' +
          response.statusCode.toString());
      terminalAsociada = false;
    }
  } on Exception catch (e, s) {
    loggin.loguearError(e, s);
    blocLogin.changeErrorCod(2);
    blocLogin.changeErrorMsg(
        "Error conectando con el servidor. Error: " + e.toString());
  } catch (error) {
    blocLogin.changeErrorCod(2);
    blocLogin.changeErrorMsg(
        "Error conectando con el servidor. Error: " + error.toString());
  }
  return terminalAsociada;
}
