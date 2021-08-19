import 'dart:async';
import 'package:mpos/src/modelo/notificacion_modelo.dart';
import 'package:rxdart/rxdart.dart';

class DatosConfiguracion {
  final _notificacionController = BehaviorSubject<Notificacion>();
  final _urlConcentradorController = BehaviorSubject<String>();
  final _urlAdminWebController = BehaviorSubject<String>();

  //recuperar datos del stream
  Stream<Notificacion> get notificacionStream => _notificacionController.stream;
  Stream<String> get urlConcentradorStream => _urlConcentradorController.stream;
  Stream<String> get urlAdminWebStream => _urlAdminWebController.stream;

  //insertar valores al stream
  Function(Notificacion) get changenotificacion =>
      _notificacionController.sink.add;
  Function(String) get changeUrlConcentrador =>
      _urlConcentradorController.sink.add;
  Function(String) get changeUrlAdminWeb => _urlAdminWebController.sink.add;

  //obtener ultimo valor ingresado del stream
  Notificacion get notificacion => _notificacionController.value;
  String get urlConcentrador => _urlConcentradorController.value;
  String get urlAdminWeb => _urlAdminWebController.value;

  dispose() {
    _notificacionController?.close();
    _urlConcentradorController?.close();
    _urlAdminWebController?.close();
  }
}
