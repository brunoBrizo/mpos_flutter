import 'package:hive/hive.dart';
part 'numerador_modelo.g.dart';

@HiveType(typeId: 6)
class Numerador {
  @HiveField(0)
  int value;
  @HiveField(1)
  String nombre;

  Numerador(this.nombre, this.value);
}
