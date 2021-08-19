import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/bloc/datos_cierre_lote_respuesta_bloc.dart';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mpos/src/bloc/datos_cierre_lote_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/cierre_lote_database.dart';
import 'package:mpos/src/database/empresa_database.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/logic/webservice_logic.dart';
import 'package:mpos/src/logic/xml/logic_xmlwebservice.dart';
import 'package:mpos/src/modelo/cierre_lote_modelo.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/styles/menu_styles.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;

class SideBar {
  static Widget drawSideBar(BuildContext context) {
    final bloc = Provider.loginBloc(context);
    String usuario, email = "";
    if (bloc.empresa != null && bloc.empresa.nombre.isNotEmpty) {
      usuario = bloc.empresa.nombre;
    } else {
      if (utils.isWeb())
        _cerrarSesion(context);
      else
        usuario = "No disponible";
    }
    if (bloc.empresa != null && bloc.empresa.usuarioLogueado.isNotEmpty) {
      email = bloc.empresa.usuarioLogueado;
    } else {
      email = "No disponible";
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(usuario),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                "assets/images/cebrita.png",
                fit: BoxFit.fill,
                height: 58,
              ),
            ),
            otherAccountsPictures: <Widget>[
              CircleAvatar(
                backgroundColor: utils.isMobile(context)
                    ? Colors.white
                    : Color.fromRGBO(110, 10, 0, 1.0),
                child: IconButton(
                  icon: Icon(Icons.close_sharp),
                  iconSize: 20.0,
                  color: Color.fromRGBO(110, 10, 0, 1.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
          _drawListTile(
              context, 'Operar', 'ingreso_importe', Icons.shopping_cart_outlined),
          utils.sizedBoxSeparator(),
          _drawListTile(context, 'Tickets', 'ticket_list', Icons.topic_rounded),
          utils.sizedBoxSeparator(),
          _drawListTile(
              context, 'Cierres de Lote', 'cierre_lote', Icons.vpn_key),
          utils.sizedBoxSeparator(),
          _drawListTilePostearCierre(
              context, 'Realizar Cierre', Icons.create_new_folder_outlined),
          utils.sizedBoxSeparator(),
          _drawListTile(context, 'Configuración', 'configuration_manager',
              Icons.settings),
          utils.sizedBoxSeparator(),
          _drawListTile(context, 'Informes', 'chart', Icons.data_usage),
          utils.sizedBoxSeparator(),
          _drawListTileUrlAdminWeb('Administración Web', Icons.open_in_browser),
          utils.sizedBoxSeparator(),
          _drawListTile(context, 'Contacto', 'contacto', Icons.email_outlined),
          utils.sizedBoxSeparator(),
          _drawListTile(context, 'Salir', 'login', Icons.logout),
          utils.sizedBoxSeparator(),
        ],
      ),
    );
  }

  static _drawListTile(
      BuildContext context, String title, String page, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListTile(
        title: Text(
          title,
          style: MenuStyles.menueMedium,
        ),
        trailing: Icon(
          icon,
          size: 30.0,
          color: Color.fromRGBO(110, 10, 0, 1.0),
        ),
        onTap: () async {
          switch (page.toUpperCase()) {
            case 'LOGIN':
              {
                await _cerrarSesion(context);
              }
              break;

            case 'CONTACTO':
              {
                await _contactoNad();
              }
              break;

            default:
              {
                Navigator.of(context).pushReplacementNamed(page);
              }
              break;
          }
        },
      ),
    );
  }

  ///    CONTACTO
  static _contactoNad() async {
    const url = 'tel:29170075';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo realizar la llamada';
    }
  }

  ///    URL ADMINWEB
  static _drawListTileUrlAdminWeb(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
          title: Text(
            title,
            style: MenuStyles.menueMedium,
          ),
          trailing: Icon(
            icon,
            size: 30.0,
            color: Color.fromRGBO(110, 10, 0, 1.0),
          ),
          onTap: () async {
            try {
              ParametroDatabase paramDb = new ParametroDatabase();
              Parametro urlAdminWeb = await paramDb.getParametro(3);
              final url = urlAdminWeb.valor + 'login.aspx';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                EasyLoading.showError('No se pudo abrir la url: ' + url);
              }
            } on Exception catch (exception) {
              EasyLoading.showError(exception.toString());
            } catch (error) {
              EasyLoading.showError(error.toString());
            }
          }),
    );
  }

  ///    CERRAR SESION
  static _cerrarSesion(BuildContext context) async {
    _limpiarDatosBloc(context);
    LoginBloc blocLogin = Provider.loginBloc(context);
    blocLogin.changeEmail('');
    Empresa emp = blocLogin.empresa;
    blocLogin.changeEmpresa(emp);
    List<String> lstTerminales = [];
    blocLogin.changeLstTerminal(lstTerminales);
    blocLogin.changePassword('');
    Navigator.of(context).pushNamed('login');
  }

  ///    CIERRE LOTE
  static _drawListTilePostearCierre(
      BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        title: Text(
          title,
          style: MenuStyles.menueMedium,
        ),
        trailing: Icon(
          icon,
          size: 30.0,
          color: Color.fromRGBO(110, 10, 0, 1.0),
        ),
        onTap: () {
          _submitCierreLote(context);
        },
      ),
    );
  }

  static void _submitCierreLote(BuildContext context) async {
    try {
      DatosCierreLote blocCierre = Provider.datosCierreLoteBloc(context);
      EmpresaDatabase empresaDb = new EmpresaDatabase();
      Empresa emp = await empresaDb.getEmpresa(1);
      blocCierre.changeEmpresaCodigo(emp.codigo);
      blocCierre.changeEmpresaHash(emp.hash);
      blocCierre.changeTermCod(emp.codigoTerminal);

      String xml = ensamblarXMLCierreLote(emp);
      _postearCierre(context, xml);
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  static void _postearCierre(BuildContext context, String xml) async {
    DatosCierreLote blocCierre = Provider.datosCierreLoteBloc(context);
    bool posteada = await callWSPostearCierreLote(context, xml);
    if (posteada) {
      if (blocCierre.respuesta.finalizado) {
        if (blocCierre.respuesta.estado.toUpperCase().contains("CANCELADA")) {
          if (blocCierre.respuesta.mensajeError.isEmpty)
            EasyLoading.showError(blocCierre.respuesta.estado);
          else
            EasyLoading.showError(blocCierre.respuesta.mensajeError);
        } else {
          EasyLoading.showSuccess(blocCierre.respuesta.estado);
          await _insertCierreLoteDB(context, blocCierre);
          Navigator.of(context).pushReplacementNamed('cierre_lote');
        }
      } else {
        EasyLoading.showError(blocCierre.respuesta.mensajeError);
      }
    } else {
      if (blocCierre.respuesta == null) {
        DatosCierreLoteRespuesta blocResp =
            Provider.datosCierreLoteRespuestaBloc(context);
        EasyLoading.showError(blocResp.mensajeError);
      } else {
        EasyLoading.showError(blocCierre.respuesta.mensajeError);
      }
    }
  }

  static Future<void> _insertCierreLoteDB(
      BuildContext context, DatosCierreLote blocCierre) async {
    CierreLoteDatabase cierreDb = new CierreLoteDatabase();
    CierreLote cierre;
    try {
      cierre = _cargarDatosCierre(blocCierre);
      await cierreDb.insertCierreLote(cierre);
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  static CierreLote _cargarDatosCierre(DatosCierreLote blocCierre) {
    CierreLote cierre = new CierreLote();
    cierre.codigoRespuesta = blocCierre.respuesta.codigoRespuesta;
    cierre.estado = blocCierre.respuesta.estado;
    cierre.fecha = blocCierre.respuesta.fecha;
    cierre.mensajeRespuesta = blocCierre.respuesta.mensajeError;
    cierre.segundosConsultar = 0;
    cierre.token = blocCierre.respuesta.tokenNro;
    cierre.user = blocCierre.user;
    cierre.xmlRespuesta = blocCierre.respuesta.xmlRespuesta;
    return cierre;
  }

  static _limpiarDatosBloc(BuildContext context) {
    DatosTransaccionBloc blocTrn = Provider.datosTransaccionBloc(context);
    blocTrn.clear();
  }
}
