// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cierre_lote_modelo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CierreLoteAdapter extends TypeAdapter<CierreLote> {
  @override
  final int typeId = 7;

  @override
  CierreLote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CierreLote()
      ..id = fields[0] as int
      ..token = fields[1] as String
      ..segundosConsultar = fields[2] as int
      ..estado = fields[3] as String
      ..xmlRespuesta = fields[4] as String
      ..fecha = fields[5] as DateTime
      ..user = fields[6] as String
      ..codigoRespuesta = fields[7] as int
      ..mensajeRespuesta = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, CierreLote obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.segundosConsultar)
      ..writeByte(3)
      ..write(obj.estado)
      ..writeByte(4)
      ..write(obj.xmlRespuesta)
      ..writeByte(5)
      ..write(obj.fecha)
      ..writeByte(6)
      ..write(obj.user)
      ..writeByte(7)
      ..write(obj.codigoRespuesta)
      ..writeByte(8)
      ..write(obj.mensajeRespuesta);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CierreLoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
