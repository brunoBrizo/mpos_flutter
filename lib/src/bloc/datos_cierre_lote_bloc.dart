import 'dart:async';
import 'package:mpos/src/bloc/datos_cierre_lote_respuesta_bloc.dart';
import 'package:rxdart/rxdart.dart';

class DatosCierreLote {
  final _empresaCodigoController = BehaviorSubject<String>();
  final _empresaHashController = BehaviorSubject<String>();
  final _termCodController = BehaviorSubject<String>();
  final _respuestaController = BehaviorSubject<DatosCierreLoteRespuesta>();
  final _userController = BehaviorSubject<String>();
  final _mensajeErrorController = BehaviorSubject<String>();

  //recuperar datos del stream
  Stream<String> get empresaCodigoStream => _empresaCodigoController.stream;
  Stream<String> get empresaHashStream => _empresaHashController.stream;
  Stream<String> get termCodStream => _termCodController.stream;
  Stream<DatosCierreLoteRespuesta> get respuestaStream =>
      _respuestaController.stream;
  Stream<String> get userStream => _userController.stream;
  Stream<String> get mensajeErrorStream => _mensajeErrorController.stream;

  //insertar valores al stream
  Function(String) get changeEmpresaCodigo => _empresaCodigoController.sink.add;
  Function(String) get changeEmpresaHash => _empresaHashController.sink.add;
  Function(String) get changeTermCod => _termCodController.sink.add;
  Function(DatosCierreLoteRespuesta) get changeRespuesta =>
      _respuestaController.sink.add;
  Function(String) get changeUser => _userController.sink.add;
  Function(String) get changeMensajeError => _mensajeErrorController.sink.add;

  //obtener ultimo valor ingresado del stream
  String get empresaCodigo => _empresaCodigoController.value;
  String get empresaHash => _empresaHashController.value;
  String get termCod => _termCodController.value;
  DatosCierreLoteRespuesta get respuesta => _respuestaController.value;
  String get user => _userController.value;
  String get mensajeError => _mensajeErrorController.value;

  dispose() {
    _empresaCodigoController?.close();
    _empresaHashController?.close();
    _termCodController?.close();
    _respuestaController?.close();
    _userController?.close();
    _mensajeErrorController?.close();
  }
}
