import 'dart:async';
import 'package:mpos/src/bloc/datos_transaccionrespuesta.dart';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:rxdart/rxdart.dart';

class DatosTransaccionBloc {
  final _importeController = BehaviorSubject<double>();
  final _monedaController = BehaviorSubject<int>();
  final _importeFacturaController = BehaviorSubject<double>();
  final _importeGravadoController = BehaviorSubject<double>();
  final _cuotasController = BehaviorSubject<int>();
  final _consumidorFinalController = BehaviorSubject<bool>();
  final _numFacturaController = BehaviorSubject<int>();
  final _empCodController = BehaviorSubject<String>();
  final _termCodController = BehaviorSubject<String>();
  final _empHashController = BehaviorSubject<String>();
  final _tokenNroController = BehaviorSubject<String>();
  final _tokenSegundosController = BehaviorSubject<int>();
  final _mensajeRespuestaController = BehaviorSubject<String>();
  final _codigoRespuestaController = BehaviorSubject<String>();
  final _estadoAvanceConcentradorController = BehaviorSubject<String>();
  final _transaccionFinalizadaController = BehaviorSubject<bool>();
  final _transaccionAprobadaController = BehaviorSubject<bool>();
  final _respuestaTransaccionController =
      BehaviorSubject<DatosTransaccionRespuestaBloc>();
  final _transaccionTipoController = BehaviorSubject<TipoTransaccion>();
  final _ticketOriginal = BehaviorSubject<int>();
  final _signaturePngPath = BehaviorSubject<String>();

  //recuperar datos del stream
  Stream<double> get importeStream => _importeController.stream;
  Stream<int> get monedaStream => _monedaController.stream;
  Stream<double> get importeFacturaStream => _importeFacturaController.stream;
  Stream<double> get importeGravadoStream => _importeGravadoController.stream;
  Stream<int> get cuotasStream => _cuotasController.stream;
  Stream<bool> get consumidorFinalStream => _consumidorFinalController.stream;
  Stream<int> get numFacturaStream => _numFacturaController.stream;
  Stream<String> get empCodStream => _empCodController.stream;
  Stream<String> get termCodStream => _termCodController.stream;
  Stream<String> get empHashStream => _empHashController.stream;
  Stream<String> get tokenNroStream => _tokenNroController.stream;
  Stream<int> get tokenSegundosStream => _tokenSegundosController.stream;
  Stream<String> get mensajeRespuestaStream =>
      _mensajeRespuestaController.stream;
  Stream<String> get codigoRespuestaStream => _codigoRespuestaController.stream;
  Stream<String> get estadoAvanceConcentradorStream =>
      _estadoAvanceConcentradorController.stream;
  Stream<bool> get transaccionFinalizadaStream =>
      _transaccionFinalizadaController.stream;
  Stream<bool> get transaccionAprobadaStream =>
      _transaccionAprobadaController.stream;
  Stream<DatosTransaccionRespuestaBloc> get respuestaTransaccionController =>
      _respuestaTransaccionController.stream;
  Stream<TipoTransaccion> get tipoTransaccionStream =>
      _transaccionTipoController.stream;
  Stream<int> get ticketOriginalStream => _ticketOriginal.stream;
  Stream<String> get signaturePngPathStream => _signaturePngPath.stream;

  //insertar valores al stream
  Function(double) get changeImporte => _importeController.sink.add;
  Function(int) get changeMoneda => _monedaController.sink.add;
  Function(double) get changeImporteFactura =>
      _importeFacturaController.sink.add;
  Function(double) get changeImporteGravado =>
      _importeGravadoController.sink.add;
  Function(int) get changeCuotas => _cuotasController.sink.add;
  Function(bool) get changeConsumidorFinal =>
      _consumidorFinalController.sink.add;
  Function(int) get changeNumFactura => _numFacturaController.sink.add;
  Function(String) get changeEmpCod => _empCodController.sink.add;
  Function(String) get changeTermCod => _termCodController.sink.add;
  Function(String) get changeEmpHashCod => _empHashController.sink.add;
  Function(String) get changeTokenNro => _tokenNroController.sink.add;
  Function(int) get changeTokenSegundos => _tokenSegundosController.sink.add;
  Function(String) get changeMensajeRespuesta =>
      _mensajeRespuestaController.sink.add;
  Function(String) get changeCodigoRespuesta =>
      _codigoRespuestaController.sink.add;
  Function(String) get changeEstadoAvanceConcentrador =>
      _estadoAvanceConcentradorController.sink.add;
  Function(bool) get changeTransaccionFinalizada =>
      _transaccionFinalizadaController.sink.add;
  Function(bool) get changeTransaccionAprobada =>
      _transaccionAprobadaController.sink.add;
  Function(DatosTransaccionRespuestaBloc) get changerespuestaTransaccion =>
      _respuestaTransaccionController.sink.add;
  Function(TipoTransaccion) get changeTipoTransaccion =>
      _transaccionTipoController.sink.add;
  Function(int) get changeTicketOriginal => _ticketOriginal.sink.add;
  Function(String) get changeSignaturePngPath => _signaturePngPath.sink.add;

  //obtener ultimo valor ingresado del stream
  double get importe => _importeController.value;
  int get moneda => _monedaController.value;
  double get importeFactura => _importeFacturaController.value;
  double get importeGravado => _importeGravadoController.value;
  int get cuotas => _cuotasController.value;
  bool get consumidorFinal => _consumidorFinalController.value;
  int get numFactura => _numFacturaController.value;
  String get empCod => _empCodController.value;
  String get termCod => _termCodController.value;
  String get empHash => _empHashController.value;
  String get tokenNro => _tokenNroController.value;
  int get tokenSegundos => _tokenSegundosController.value;
  String get mensajeRespuesta => _mensajeRespuestaController.value;
  String get codigoRespuesta => _codigoRespuestaController.value;
  String get estadoAvanceConcentrador =>
      _estadoAvanceConcentradorController.value;
  bool get transaccionFinalizada => _transaccionFinalizadaController.value;
  bool get transaccionAprobada => _transaccionAprobadaController.value;
  DatosTransaccionRespuestaBloc get respuestaTransaccion =>
      _respuestaTransaccionController.value;
  TipoTransaccion get tipoTransaccion => _transaccionTipoController.value;
  int get ticketOriginal => _ticketOriginal.value;
  String get signaturePngPath => _signaturePngPath.value;

  clear() {
    changeImporte(0);
    changeMoneda(0);
    changeImporteFactura(0);
    changeImporteGravado(0);
    changeCuotas(0);
    changeConsumidorFinal(false);
    changeNumFactura(0);
    changeEmpCod("");
    changeTermCod("");
    changeEmpHashCod("");
    changeTokenNro("");
    changeTokenSegundos(0);
    changeMensajeRespuesta("");
    changeCodigoRespuesta("");
    changeEstadoAvanceConcentrador("");
    changeTransaccionFinalizada(false);
    changeTransaccionAprobada(false);
    changerespuestaTransaccion(new DatosTransaccionRespuestaBloc());
    changeTipoTransaccion(TipoTransaccion.Venta);
    changeTicketOriginal(0);
    changeSignaturePngPath('');
  }

  dispose() {
    _importeController?.close();
    _monedaController?.close();
    _importeFacturaController?.close();
    _importeGravadoController?.close();
    _cuotasController?.close();
    _consumidorFinalController?.close();
    _numFacturaController?.close();
    _empCodController?.close();
    _termCodController?.close();
    _empHashController?.close();
    _tokenNroController?.close();
    _tokenSegundosController?.close();
    _mensajeRespuestaController?.close();
    _codigoRespuestaController?.close();
    _estadoAvanceConcentradorController?.close();
    _transaccionFinalizadaController?.close();
    _transaccionAprobadaController?.close();
    _respuestaTransaccionController?.close();
    _transaccionTipoController?.close();
    _ticketOriginal?.close();
    _signaturePngPath?.close();
  }
}
