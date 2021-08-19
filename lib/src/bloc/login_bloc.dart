import 'dart:async';
import 'package:mpos/src/bloc/validators.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _errorCodController = BehaviorSubject<int>();
  final _errorMsgController = BehaviorSubject<String>();
  final _empresaController = BehaviorSubject<Empresa>();
  final _lstTerminalController = BehaviorSubject<List<String>>();
  final _isFirstTime = BehaviorSubject<bool>();

  //recuperar datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);
  Stream<int> get errorCodStream => _errorCodController.stream;
  Stream<String> get errorMsgStream => _errorMsgController.stream;
  Stream<Empresa> get empresaStream => _empresaController.stream;
  Stream<List<String>> get lstTerminalStream => _lstTerminalController.stream;
  Stream<bool> get isFirstTimeStream => _isFirstTime.stream;
  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  //insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(int) get changeErrorCod => _errorCodController.sink.add;
  Function(String) get changeErrorMsg => _errorMsgController.sink.add;
  Function(Empresa) get changeEmpresa => _empresaController.sink.add;
  Function(bool) get changeIsFirstTime => _isFirstTime.sink.add;
  Function(List<String>) get changeLstTerminal =>
      _lstTerminalController.sink.add;

  //obtener ultimo valor ingresado del stream
  String get email => _emailController.value;
  String get password => _passwordController.value;
  int get errorCod => _errorCodController.value;
  String get errorMsg => _errorMsgController.value;
  bool get isFirstTime => _isFirstTime.value;
  Empresa get empresa => _empresaController.value;
  List<String> get lstTerminal => _lstTerminalController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _errorMsgController?.close();
    _errorCodController?.close();
    _empresaController?.close();
    _lstTerminalController?.close();
    _isFirstTime?.close();
  }
}
