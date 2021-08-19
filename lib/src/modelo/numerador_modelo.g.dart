// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'numerador_modelo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NumeradorAdapter extends TypeAdapter<Numerador> {
  @override
  final int typeId = 6;

  @override
  Numerador read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Numerador(
      fields[1] as String,
      fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Numerador obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.nombre);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumeradorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
