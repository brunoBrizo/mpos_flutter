import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/src/bloc/datos_cierre_lote_bloc.dart';
import 'package:mpos/src/bloc/datos_cierre_lote_respuesta_bloc.dart';
import 'package:mpos/src/bloc/datos_transaccion_bloc.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/cierre_lote_database.dart';
import 'package:mpos/src/database/empresa_database.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/logic/webservice_logic.dart';
import 'package:mpos/src/logic/xml/logic_xmlwebservice.dart';
import 'package:mpos/src/modelo/cierre_lote_modelo.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_Background()],
      ),
      // bottomNavigationBar: _CustomBottomNavigation(),
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 0.8],
                  colors: [Color(0xff2E305F), Color(0xff202333)])),
        ),
        Positioned(left: -30, top: -100, child: _PinkBox()),
        _Body()
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  const _PinkBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            color: Colors.pink,
            gradient: LinearGradient(colors: [
              Color.fromRGBO(236, 98, 188, 1),
              Color.fromRGBO(251, 142, 172, 1)
            ])),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: _PageTitle(),
          ),
          _CardTable()
        ],
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    final String userText = usuario.toUpperCase() + ' (' + email + ')';
    return SafeArea(
      bottom: false,
      child: Container(
        //width: 290,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 27,
              child: Image.asset(
                "assets/images/cebrita.png",
                fit: BoxFit.fill,
                width: 37,
                height: 37,
                //height: 58,
              ),
            ),
            Expanded(
              child: Text(
                userText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await _cerrarSesion(context);
              },
              child: Icon(
                Icons.logout,
                size: 37.0,
                color: Colors.white,
                semanticLabel: 'sdsdsd',
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
class _CustomBottomNavigation extends StatelessWidget {
  const _CustomBottomNavigation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color.fromRGBO(55, 57, 84, 1),
        unselectedItemColor: Color.fromRGBO(116, 117, 152, 1),
        selectedItemColor: Colors.pink,
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 25,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.pie_chart_outline,
                size: 25,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.supervised_user_circle,
                size: 25,
              ),
              label: ''),
        ]);
  }
}
*/

class _CardTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _SingleCard(
            color: Colors.blue,
            text: 'Operar',
            icon: Icons.shopping_cart_outlined,
            page: 'ingreso_importe',
          ),
          _SingleCard(
            color: Colors.purpleAccent,
            text: 'Tickets',
            icon: Icons.topic_rounded,
            page: 'ticket_list',
          )
        ]),
        TableRow(children: [
          _SingleCard(
              color: Colors.purple,
              text: 'Realizar Cierre',
              icon: Icons.create_new_folder_outlined,
              page: '',
              onPressed: _submitCierreLote),
          _SingleCard(
            color: Colors.pinkAccent,
            text: 'Cierres de Lote',
            icon: Icons.vpn_key,
            page: 'cierre_lote',
          )
        ]),
        TableRow(children: [
          _SingleCard(
            color: Colors.purple,
            text: 'Informes',
            icon: Icons.data_usage,
            page: 'chart',
          ),
          _SingleCard(
              color: Colors.purpleAccent,
              text: 'Administración Web',
              onPressed: _launchAdminWeb,
              page: '',
              icon: Icons.open_in_browser)
        ]),
        TableRow(children: [
          _SingleCard(
              color: Colors.purpleAccent,
              text: 'Configuración',
              page: 'configuration_manager',
              icon: Icons.settings),
          _SingleCard(
            color: Colors.purple,
            text: 'Contacto',
            page: 'contacto',
            icon: Icons.email_outlined,
          ),
        ])
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String page;
  final Function onPressed;

  _SingleCard(
      {@required this.color,
      @required this.icon,
      @required this.text,
      @required this.page,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.page.isEmpty) {
          this.onPressed();
        } else {
          _redirect(context, page);
        }
      },
      child: Container(
        margin: EdgeInsets.all(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(62, 66, 107, 0.7),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: this.color,
                    child: Icon(
                      this.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                    radius: 25,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    this.text,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///    HELPERS
_cerrarSesion(BuildContext context) async {
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

_limpiarDatosBloc(BuildContext context) {
  DatosTransaccionBloc blocTrn = Provider.datosTransaccionBloc(context);
  blocTrn.clear();
}

_redirect(BuildContext context, String redirectTo) async {
  switch (redirectTo.toUpperCase()) {
    case 'LOGIN':
      {
        await _cerrarSesion(context);
      }
      break;

    case 'CONTACTO':
      {
        //await _contactoNad();
      }
      break;

    default:
      {
        Navigator.of(context).pushReplacementNamed(redirectTo);
      }
      break;
  }
}

void _submitCierreLote(BuildContext context) async {
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

void _postearCierre(BuildContext context, String xml) async {
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

Future<void> _insertCierreLoteDB(
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

CierreLote _cargarDatosCierre(DatosCierreLote blocCierre) {
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

void _launchAdminWeb() async {
  {
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
  }
}
