import 'dart:async';

import 'package:mpos/src/database/empresa_database.dart';
import 'package:mpos/src/modelo/empresa_modelo.dart';

Future<Empresa> obtenerEmpresaRegistrada() async {
  EmpresaDatabase empDb = new EmpresaDatabase();
  Empresa emp = await empDb.getEmpresa(1);
  return emp;
}

String obtenerUsuarioLogueado() {
  String usuarioLogueado = "No disponible";
  Timer.run(() async {
    Empresa emp = await obtenerEmpresaRegistrada();
    if (emp != null) usuarioLogueado = emp.usuarioLogueado;
  });
  return usuarioLogueado;
}
