import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:mpos/src/bloc/configuracion_bloc.dart';
import 'package:mpos/src/bloc/provider.dart';
import 'package:mpos/src/database/parametro_database.dart';
import 'package:mpos/src/modelo/enums/tipo_parametro.dart';
import 'package:mpos/src/modelo/parametro_modelo.dart';
import 'package:mpos/src/modelo/notificacion_modelo.dart';
import 'package:mpos/src/pages/sidebar/sidebar_page.dart';
import 'package:mpos/src/styles/title_styles.dart';
import 'package:mpos/src/utils/general_utils.dart' as utils;

class ConfigurationPage extends StatefulWidget {
  ConfigurationPage({Key key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  ParametroDatabase parametroDb = new ParametroDatabase();
  Box parametroBox;
  final formKey = GlobalKey<FormState>();
  Parametro _urlConcentrador;
  Parametro _urlAdminWeb;
  bool fieldControllerUsaAutBiometrica = true;

  //tipo notificacion
  List<Notificacion> _notificaciones = Notificacion.getNotificaciones();
  List<DropdownMenuItem<Notificacion>> _dropdownMenuItemsNotificacion;
  Notificacion _notificacionSelected;

  //urls
  TextEditingController fieldControllerUrlConcentrador;
  TextEditingController fieldControllerUrlAdminWeb;

  @override
  void initState() {
    super.initState();
    fieldControllerUrlConcentrador = TextEditingController();
    fieldControllerUrlAdminWeb = TextEditingController();

    //tipo notificacion
    _dropdownMenuItemsNotificacion =
        buildDropdownMenuItemsNotificacion(_notificaciones);

    _inicializarParams();
  }

  @override
  void dispose() async {
    try {
      super.dispose();
      fieldControllerUrlConcentrador.dispose();
      fieldControllerUrlAdminWeb.dispose();
      if (parametroDb.parametroBox.isOpen) {
        await parametroDb.dispose();
      }
    } catch (error) {}
  }

  _inicializarParams() async {
    try {
      parametroBox = await parametroDb.initParametro();

      Parametro paramNotificacion = parametroBox.get(1);
      int notificacionId = Notificacion.getNotificacionPosition(
          int.tryParse(paramNotificacion.valor));
      _notificacionSelected =
          _dropdownMenuItemsNotificacion[notificacionId].value;

      _urlConcentrador = parametroBox.get(4);
      _urlAdminWeb = parametroBox.get(3);
    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: SideBar.drawSideBar(context),
      appBar: utils.drawAppBar('Configuración', true),
      body: FutureBuilder(
        future: parametroDb.initParametro(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            EasyLoading.showError(snapshot.error.toString());
            Navigator.popAndPushNamed(context, 'home');
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return _drawPage(context);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }

  _drawPage(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Center(
              child: Column(
                children: <Widget>[
                  _drawFirstCard(),
                ],
              ),
            ),
            _drawButtonGuardar(context),
            // _drawButtonGuardar(context),
          ],
        ),
      ),
    );
  }

// -------------- CARDS --------------

  Widget _drawFirstCard() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
      child: Card(
        shadowColor: Colors.black,
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Column(
            children: <Widget>[
              _drawNotificacionDefecto(context),
              //_drawConexionInternet(),
              _drawUsuarioText(),
              _drawUrlConcentrador(context, size),
              _drawUrlAdminWeb(context, size),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
    );
  }

// -------------- TIPO NOTIFICACION --------------

  List<DropdownMenuItem<Notificacion>> buildDropdownMenuItemsNotificacion(
      List notificaciones) {
    List<DropdownMenuItem<Notificacion>> items = [];
    for (Notificacion tipoNotificacion in notificaciones) {
      items.add(
        DropdownMenuItem(
          value: tipoNotificacion,
          child: Text(tipoNotificacion.name),
        ),
      );
    }
    return items;
  }

  Widget _drawNotificacionDefecto(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Row(children: <Widget>[
        Text(
          'Notificación',
          style: TitleStyles.titleSmall,
        ),
        _drawNotificacionCombobox(context)
      ]),
    );
  }

  Widget _drawNotificacionCombobox(BuildContext context) {
    DatosConfiguracion configuracionBloc =
        Provider.datosConfiguracionBloc(context);

    return StreamBuilder(
        stream: configuracionBloc.notificacionStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    new DropdownButton(
                      value: _notificacionSelected,
                      items: _dropdownMenuItemsNotificacion,
                      onChanged: (value) {
                        _notificacionSelected = value;
                        configuracionBloc
                            .changenotificacion(_notificacionSelected);
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  onChangeDropdownItemNotificacion(Notificacion notificacionSelected) async {
    _notificacionSelected = notificacionSelected;
  }

// -------------- DATOS EXTRA --------------
  Widget _drawUsuarioText() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Row(children: <Widget>[
        Text(
          'Usuario',
          style: TitleStyles.titleSmall,
        ),
        SizedBox(
          width: size.width * 0.01,
        ),
        _drawUsuario()
      ]),
    );
  }

  Widget _drawUsuario() {
    Size size = MediaQuery.of(context).size;
    final bloc = Provider.loginBloc(context);
    String usuarioActual = bloc.empresa.usuarioLogueado;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: size.width * 0.55,
            child: Center(
                child: Text(usuarioActual.toString(),
                    style: TitleStyles.titleSmall)),
          ),
        ],
      ),
    );
  }

  Widget _drawUrlConcentrador(BuildContext context, Size size) {
    DatosConfiguracion configuracionBloc =
        Provider.datosConfiguracionBloc(context);
    configuracionBloc.changeUrlConcentrador(_urlConcentrador.valor);
    return StreamBuilder(
      stream: configuracionBloc.urlConcentradorStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.only(right: 20.0, top: 15.0),
            child: TextField(
              enabled: false,
              controller: fieldControllerUrlConcentrador
                ..text = configuracionBloc.urlConcentrador
                ..selection = TextSelection.collapsed(
                    offset: fieldControllerUrlConcentrador.text.length),
              keyboardType: TextInputType.url,
              readOnly: false,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'URL Concentrador',
                labelStyle: TextStyle(fontSize: 19.0),
              ),
            ));
      },
    );
  }

  Widget _drawUrlAdminWeb(BuildContext context, Size size) {
    DatosConfiguracion configuracionBloc =
        Provider.datosConfiguracionBloc(context);
    configuracionBloc.changeUrlAdminWeb(_urlAdminWeb.valor);
    return StreamBuilder(
      stream: configuracionBloc.urlAdminWebStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.only(right: 20.0, top: 15.0),
            child: TextField(
              enabled: false,
              controller: fieldControllerUrlAdminWeb
                ..text = configuracionBloc.urlAdminWeb
                ..selection = TextSelection.collapsed(
                    offset: fieldControllerUrlAdminWeb.text.length),
              keyboardType: TextInputType.url,
              readOnly: false,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'URL AdminWeb',
                  labelStyle: TextStyle(fontSize: 19.0)),
            ));
      },
    );
  }

// -------------- BUTTONS --------------
  Widget _drawButtonGuardar(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
        child: Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Container(
            child: ButtonTheme(
                height: size.height * 0.08,
                minWidth: size.width * 0.6,
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.save,
                    size: size.width * size.height * 0.00011,
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(110, 10, 0, 1.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  label: Text(
                    'Guardar',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _guardar(context);
                  },
                ))),
      ),
    ));
  }

  _guardar(BuildContext context) async {
    try {
      // DatosConfiguracion configuracionBloc =
      //    Provider.datosConfiguracionBloc(context);
      Parametro paramNotificacion = new Parametro(
          TipoParametro.Notificacion, _notificacionSelected.id.toString());
      await parametroDb.updateParametro(1, paramNotificacion);

      /* URLS no modificables por el cliente
      _urlConcentrador.valor = configuracionBloc.urlConcentrador;
      _urlAdminWeb.valor = configuracionBloc.urlAdminWeb;
      if (_urlAdminWeb.valor.isEmpty || _urlConcentrador.valor.isEmpty) {
        EasyLoading.showError('Las URL no pueden estar vacías');
      } else {
        await parametroDb.updateParametro(4, _urlConcentrador);
        await parametroDb.updateParametro(3, _urlAdminWeb);
        EasyLoading.showSuccess('Configuración guardada');
      }*/

    } on Exception catch (exception) {
      EasyLoading.showError(exception.toString());
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }
}
