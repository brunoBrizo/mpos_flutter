import 'package:hive/hive.dart';
part 'moneda_modelo.g.dart';

//asegurarse de tener un insert siempre en la sqlite con los valores de la moneda

@HiveType(typeId: 5)
class Moneda {
  @HiveField(0)
  int value;
  @HiveField(1)
  String nombre;
  @HiveField(2)
  String abreviacion;

  int getValue() {
    return value;
  }

  String getNombre() {
    return nombre;
  }

  String getAbreviacion() {
    return abreviacion;
  }

  Moneda(this.value, this.nombre, this.abreviacion);
}
