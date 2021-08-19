// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parametro_modelo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParametroAdapter extends TypeAdapter<Parametro> {
  @override
  final int typeId = 0;

  @override
  Parametro read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parametro(
      fields[0] as TipoParametro,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Parametro obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.valor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParametroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
