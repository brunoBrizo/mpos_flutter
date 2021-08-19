import 'dart:async';
import 'package:rxdart/rxdart.dart';

class DatosCierreLoteRespuesta {
  final _tokenNroController = BehaviorSubject<String>();
  final _fechaController = BehaviorSubject<DateTime>();
  final _estadoController = BehaviorSubject<String>();
  final _finalizadoController = BehaviorSubject<bool>();
  final _codigoRespuestaController = BehaviorSubject<int>();
  final _mensajeErrorController = BehaviorSubject<String>();
  final _xmlRespuestaController = BehaviorSubject<String>();

  //recuperar datos del stream
  Stream<String> get tokenNroStream => _tokenNroController.stream;
  Stream<DateTime> get fechaStream => _fechaController.stream;
  Stream<String> get estadoStream => _estadoController.stream;
  Stream<bool> get finalizadoStream => _finalizadoController.stream;
  Stream<String> get xmlRespuestaStream => _xmlRespuestaController.stream;
  Stream<String> get mensajeErrorStream => _mensajeErrorController.stream;
  Stream<int> get codigoRespuestaStream => _codigoRespuestaController.stream;

  //insertar valores al stream
  Function(String) get changeTokenNro => _tokenNroController.sink.add;
  Function(DateTime) get changeFecha => _fechaController.sink.add;
  Function(String) get changeEstado => _estadoController.sink.add;
  Function(bool) get changeFinalizado => _finalizadoController.sink.add;
  Function(String) get changeXmlRespuesta => _xmlRespuestaController.sink.add;
  Function(String) get changeMensajeError => _mensajeErrorController.sink.add;
  Function(int) get changeCodigoRespuesta =>
      _codigoRespuestaController.sink.add;

  //obtener ultimo valor ingresado del stream
  String get tokenNro => _tokenNroController.value;
  DateTime get fecha => _fechaController.value;
  String get estado => _estadoController.value;
  bool get finalizado => _finalizadoController.value;
  String get xmlRespuesta => _xmlRespuestaController.value;
  String get mensajeError => _mensajeErrorController.value;
  int get codigoRespuesta => _codigoRespuestaController.value;

  dispose() {
    _tokenNroController?.close();
    _fechaController?.close();
    _estadoController?.close();
    _finalizadoController?.close();
    _xmlRespuestaController?.close();
    _mensajeErrorController?.close();
    _codigoRespuestaController?.close();
  }
}
