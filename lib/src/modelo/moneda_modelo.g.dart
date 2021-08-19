// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moneda_modelo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonedaAdapter extends TypeAdapter<Moneda> {
  @override
  final int typeId = 5;

  @override
  Moneda read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Moneda(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Moneda obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.abreviacion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonedaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
