import 'package:hive/hive.dart';
part 'cierre_lote_estado.g.dart';

@HiveType(typeId: 10)
enum CierreLoteEstado {
  @HiveField(0)
  Pendiente,
  @HiveField(1)
  Realizado
}
