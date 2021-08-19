import 'package:hive/hive.dart';
part 'empresa_modelo.g.dart';

@HiveType(typeId: 2)
class Empresa {
  @HiveField(0)
  String rut;
  @HiveField(1)
  String razonSocial;
  @HiveField(2)
  String nombre;
  @HiveField(3)
  String codigo;
  @HiveField(4)
  String hash;
  @HiveField(5)
  String token;
  @HiveField(6)
  String codigoTerminal;
  @HiveField(7)
  String cierreCentralizado;
  @HiveField(8)
  int id;
  @HiveField(9)
  String usuarioLogueado;
  @HiveField(10)
  String usuarioLogueadoPassword;
  @HiveField(11)
  bool solicitarSignature;

  Empresa(
      this.rut,
      this.razonSocial,
      this.nombre,
      this.codigo,
      this.hash,
      this.token,
      this.codigoTerminal,
      this.cierreCentralizado,
      this.id,
      this.usuarioLogueado,
      this.usuarioLogueadoPassword,
      this.solicitarSignature);
}
