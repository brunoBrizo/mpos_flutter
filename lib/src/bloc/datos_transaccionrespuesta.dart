import 'dart:async';
import 'package:mpos/src/modelo/enums/tipo_transaccion.dart';
import 'package:rxdart/rxdart.dart';

class DatosTransaccionRespuestaBloc {
  final _idController = BehaviorSubject<int>();
  final _userController = BehaviorSubject<String>();
  final _fechaController = BehaviorSubject<DateTime>();
  final _tipoTransaccionController = BehaviorSubject<TipoTransaccion>();
  final _monedaController = BehaviorSubject<int>();
  final _montoController = BehaviorSubject<double>();
  final _nroAutorizacionController = BehaviorSubject<String>();
  final _ticketController = BehaviorSubject<int>();
  final _nroFacturaController = BehaviorSubject<int>();
  final _cuotasController = BehaviorSubject<int>();
  final _facturaMontoController = BehaviorSubject<double>();
  final _facturaMontoGravadoController = BehaviorSubject<double>();
  final _facturaMontoIvaController = BehaviorSubject<double>();
  final _montoPropinaController = BehaviorSubject<double>();
  final _decretoLeyMontoController = BehaviorSubject<double>();
  final _firmarVoucherController = BehaviorSubject<bool>();
  final _tarjetaNumeroController = BehaviorSubject<String>();
  final _tarjetaNombreController = BehaviorSubject<String>();
  final _tarjetaTitularController = BehaviorSubject<String>();
  final _tarjetaIdController = BehaviorSubject<int>();
  final _aprobadaController = BehaviorSubject<bool>();
  final _midController = BehaviorSubject<String>();
  final _terminalIdController = BehaviorSubject<int>();
  final _fueDevueltoController = BehaviorSubject<bool>();
  final _tokenNroController = BehaviorSubject<String>();
  final _codigoRespuestaController = BehaviorSubject<String>();
  final _mensajeRespuestaController = BehaviorSubject<String>();
  final _voucherController = BehaviorSubject<String>();

  //recuperar datos del stream
  Stream<int> get idStream => _idController.stream;
  Stream<String> get userStream => _userController.stream;
  Stream<DateTime> get fechaStream => _fechaController.stream;
  Stream<TipoTransaccion> get tipoTransaccionStream =>
      _tipoTransaccionController.stream;
  Stream<int> get monedaStream => _monedaController.stream;
  Stream<double> get montoStream => _montoController.stream;
  Stream<String> get nroAutorizacionStream => _nroAutorizacionController.stream;
  Stream<int> get ticketStream => _ticketController.stream;
  Stream<int> get nroFacturaStream => _nroFacturaController.stream;
  Stream<int> get cuotasStream => _cuotasController.stream;
  Stream<double> get facturaMontoStream => _facturaMontoController.stream;
  Stream<double> get facturaMontoGravadoStream =>
      _facturaMontoGravadoController.stream;
  Stream<double> get facturaMontoIvaStream => _facturaMontoIvaController.stream;
  Stream<double> get montoPropinaStream => _montoPropinaController.stream;
  Stream<double> get decretoLeyMontoStream => _decretoLeyMontoController.stream;
  Stream<bool> get firmarVoucherStream => _firmarVoucherController.stream;
  Stream<String> get tarjetaNumeroStream => _tarjetaNumeroController.stream;
  Stream<String> get tarjetaNombreStream => _tarjetaNombreController.stream;
  Stream<int> get tarjetaIdStream => _tarjetaIdController.stream;
  Stream<String> get tarjetaTitularStream => _tarjetaTitularController.stream;
  Stream<bool> get aprobadaStream => _aprobadaController.stream;
  Stream<String> get midStream => _midController.stream;
  Stream<int> get terminalIdStream => _terminalIdController.stream;
  Stream<bool> get fueDevueltoStream => _fueDevueltoController.stream;
  Stream<String> get tokenNroStream => _tokenNroController.stream;
  Stream<String> get codigoRespuestaStream => _codigoRespuestaController.stream;
  Stream<String> get mensajeRespuestaStream =>
      _mensajeRespuestaController.stream;
  Stream<String> get voucherStream => _voucherController.stream;

  //insertar valores al stream
  Function(int) get changeId => _idController.sink.add;
  Function(String) get changeUser => _userController.sink.add;
  Function(DateTime) get changeFecha => _fechaController.sink.add;
  Function(TipoTransaccion) get changeTipoTransaccion =>
      _tipoTransaccionController.sink.add;
  Function(int) get changeMoneda => _monedaController.sink.add;
  Function(double) get changeMonto => _montoController.sink.add;
  Function(String) get changeNroAutorizacion =>
      _nroAutorizacionController.sink.add;
  Function(int) get changeTicket => _ticketController.sink.add;
  Function(int) get changeNroFactura => _nroFacturaController.sink.add;
  Function(int) get changeCuotas => _cuotasController.sink.add;
  Function(double) get changeFacturaMonto => _facturaMontoController.sink.add;
  Function(double) get changeFacturaMontoGravado =>
      _facturaMontoGravadoController.sink.add;
  Function(double) get changeFacturaMontoIva =>
      _facturaMontoIvaController.sink.add;
  Function(double) get changeMontoPropina => _montoPropinaController.sink.add;
  Function(double) get changeDecretoLeyMonto =>
      _decretoLeyMontoController.sink.add;
  Function(bool) get changeFirmarVoucher => _firmarVoucherController.sink.add;
  Function(String) get changeTarjetaNumero => _tarjetaNumeroController.sink.add;
  Function(String) get changeTarjetaNombre => _tarjetaNombreController.sink.add;
  Function(int) get changeTarjetaId => _tarjetaIdController.sink.add;
  Function(String) get changeTarjetaTitular =>
      _tarjetaTitularController.sink.add;
  Function(bool) get changeAprobada => _aprobadaController.sink.add;
  Function(String) get changeMID => _midController.sink.add;
  Function(int) get changeTerminalId => _terminalIdController.sink.add;
  Function(bool) get changeFueDevuelto => _fueDevueltoController.sink.add;
  Function(String) get changeTokenNro => _tokenNroController.sink.add;
  Function(String) get changeCodigoRespuesta =>
      _codigoRespuestaController.sink.add;
  Function(String) get changeMensajeRespuesta =>
      _mensajeRespuestaController.sink.add;
  Function(String) get changeVoucher => _voucherController.sink.add;

  //obtener ultimo valor ingresado del stream
  int get id => _idController.value;
  String get user => _userController.value;
  DateTime get fecha => _fechaController.value;
  TipoTransaccion get tipoTransaccion => _tipoTransaccionController.value;
  int get moneda => _monedaController.value;
  double get monto => _montoController.value;
  String get nroAutorizacion => _nroAutorizacionController.value;
  int get ticket => _ticketController.value;
  int get nroFactura => _nroFacturaController.value;
  int get cuotas => _cuotasController.value;
  double get facturaMonto => _facturaMontoController.value;
  double get facturaMontoGravado => _facturaMontoGravadoController.value;
  double get facturaMontoIva => _facturaMontoIvaController.value;
  double get montoPropina => _montoPropinaController.value;
  double get decretoLeyMonto => _decretoLeyMontoController.value;
  bool get firmarVoucher => _firmarVoucherController.value;
  String get tarjetaNumero => _tarjetaNumeroController.value;
  String get tarjetaNombre => _tarjetaNombreController.value;
  int get tarjetaId => _tarjetaIdController.value;
  String get tarjetaTitular => _tarjetaTitularController.value;
  bool get aprobada => _aprobadaController.value;
  String get mid => _midController.value;
  int get terminalId => _terminalIdController.value;
  bool get fueDevuelto => _fueDevueltoController.value;
  String get tokenNro => _tokenNroController.value;
  String get codigoRespuesta => _codigoRespuestaController.value;
  String get mensajeRespuesta => _mensajeRespuestaController.value;
  String get voucher => _voucherController.value;

  dispose() {
    _idController?.close();
    _userController?.close();
    _fechaController?.close();
    _tipoTransaccionController?.close();
    _monedaController?.close();
    _montoController?.close();
    _nroAutorizacionController?.close();
    _ticketController?.close();
    _nroFacturaController?.close();
    _cuotasController?.close();
    _facturaMontoController?.close();
    _facturaMontoGravadoController?.close();
    _facturaMontoIvaController?.close();
    _montoPropinaController?.close();
    _decretoLeyMontoController?.close();
    _firmarVoucherController?.close();
    _tarjetaNumeroController?.close();
    _tarjetaNombreController?.close();
    _tarjetaIdController?.close();
    _tarjetaTitularController?.close();
    _aprobadaController?.close();
    _midController?.close();
    _terminalIdController?.close();
    _fueDevueltoController?.close();
    _tokenNroController?.close();
    _codigoRespuestaController?.close();
    _mensajeRespuestaController?.close();
    _voucherController?.close();
  }
}
