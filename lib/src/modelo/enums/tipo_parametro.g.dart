// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_parametro.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TipoParametroAdapter extends TypeAdapter<TipoParametro> {
  @override
  final int typeId = 1;

  @override
  TipoParametro read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoParametro.URL_AdminWeb;
      case 1:
        return TipoParametro.URL_Concentrador;
      case 2:
        return TipoParametro.Notificacion;
      case 3:
        return TipoParametro.Conexion;
      case 4:
        return TipoParametro.LoginEmail;
      case 5:
        return TipoParametro.DiasEliminarTickets;
      case 6:
        return TipoParametro.LoginPassword;
      default:
        return TipoParametro.URL_AdminWeb;
    }
  }

  @override
  void write(BinaryWriter writer, TipoParametro obj) {
    switch (obj) {
      case TipoParametro.URL_AdminWeb:
        writer.writeByte(0);
        break;
      case TipoParametro.URL_Concentrador:
        writer.writeByte(1);
        break;
      case TipoParametro.Notificacion:
        writer.writeByte(2);
        break;
      case TipoParametro.Conexion:
        writer.writeByte(3);
        break;
      case TipoParametro.LoginEmail:
        writer.writeByte(4);
        break;
      case TipoParametro.DiasEliminarTickets:
        writer.writeByte(5);
        break;
      case TipoParametro.LoginPassword:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoParametroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
