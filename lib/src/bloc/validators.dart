import 'dart:async';

class Validators {
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 4) {
      sink.add(password);
    } else {
      sink.addError('Mayor a 4 caracteres');
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError("Email no es correcto");
    }
  });
}
