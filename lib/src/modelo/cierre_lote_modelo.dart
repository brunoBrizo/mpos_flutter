import 'package:hive/hive.dart';
part 'cierre_lote_modelo.g.dart';

@HiveType(typeId: 7)
class CierreLote {
  @HiveField(0)
  int id;
  @HiveField(1)
  String token;
  @HiveField(2)
  int segundosConsultar;
  @HiveField(3)
  String estado;
  @HiveField(4)
  String xmlRespuesta;
  @HiveField(5)
  DateTime fecha;
  @HiveField(6)
  String user;
  @HiveField(7)
  int codigoRespuesta;
  @HiveField(8)
  String mensajeRespuesta;

  //@HiveField(4)
  //MyDevice device;
}
