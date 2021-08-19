import 'package:hive/hive.dart';
part 'tipo_parametro.g.dart';

@HiveType(typeId: 1)
enum TipoParametro {
  @HiveField(0)
  URL_AdminWeb,
  @HiveField(1)
  URL_Concentrador,
  @HiveField(2)
  Notificacion,
  @HiveField(3)
  Conexion,
  @HiveField(4)
  LoginEmail,
  @HiveField(5)
  DiasEliminarTickets,
  @HiveField(6)
  LoginPassword
}
