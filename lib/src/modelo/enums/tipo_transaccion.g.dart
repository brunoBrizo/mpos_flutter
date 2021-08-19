// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_transaccion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TipoTransaccionAdapter extends TypeAdapter<TipoTransaccion> {
  @override
  final int typeId = 3;

  @override
  TipoTransaccion read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoTransaccion.Venta;
      case 1:
        return TipoTransaccion.Devolucion;
      default:
        return TipoTransaccion.Venta;
    }
  }

  @override
  void write(BinaryWriter writer, TipoTransaccion obj) {
    switch (obj) {
      case TipoTransaccion.Venta:
        writer.writeByte(0);
        break;
      case TipoTransaccion.Devolucion:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoTransaccionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
