import 'package:hive/hive.dart';
part 'tipo_transaccion.g.dart';

@HiveType(typeId: 3)
enum TipoTransaccion {
  @HiveField(0)
  Venta,
  @HiveField(1)
  Devolucion
}
