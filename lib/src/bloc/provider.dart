import 'package:flutter/material.dart';
import 'package:mpos/src/bloc/configuracion_bloc.dart';
import 'package:mpos/src/bloc/datos_cierre_lote_bloc.dart';
import 'package:mpos/src/bloc/datos_cierre_lote_respuesta_bloc.dart';
import 'package:mpos/src/bloc/datos_transaccionrespuesta.dart';
import 'package:mpos/src/bloc/login_bloc.dart';
import 'datos_transaccion_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  final _loginBloc = LoginBloc();
  final _datosTransaccionBloc = DatosTransaccionBloc();
  final _datosTransaccionRespuestaBloc = DatosTransaccionRespuestaBloc();
  final _datosCierreLoteBloc = DatosCierreLote();
  final _datosCierreLoteRespuestaBloc = DatosCierreLoteRespuesta();
  final _datosConfiguracionBloc = DatosConfiguracion();

//  Provider({Key key, Widget child}) : super(key: key, child: child);

  static LoginBloc loginBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }

  static DatosTransaccionBloc datosTransaccionBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._datosTransaccionBloc;
  }

  static DatosTransaccionRespuestaBloc datosTransaccionRespuestaBloc(
      BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._datosTransaccionRespuestaBloc;
  }

  static DatosCierreLote datosCierreLoteBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._datosCierreLoteBloc;
  }

  static DatosCierreLoteRespuesta datosCierreLoteRespuestaBloc(
      BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._datosCierreLoteRespuestaBloc;
  }

  static DatosConfiguracion datosConfiguracionBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._datosConfiguracionBloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
