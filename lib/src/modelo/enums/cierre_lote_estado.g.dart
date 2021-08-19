// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cierre_lote_estado.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CierreLoteEstadoAdapter extends TypeAdapter<CierreLoteEstado> {
  @override
  final int typeId = 10;

  @override
  CierreLoteEstado read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CierreLoteEstado.Pendiente;
      case 1:
        return CierreLoteEstado.Realizado;
      default:
        return CierreLoteEstado.Pendiente;
    }
  }

  @override
  void write(BinaryWriter writer, CierreLoteEstado obj) {
    switch (obj) {
      case CierreLoteEstado.Pendiente:
        writer.writeByte(0);
        break;
      case CierreLoteEstado.Realizado:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CierreLoteEstadoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
