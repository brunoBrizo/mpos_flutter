// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empresa_modelo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmpresaAdapter extends TypeAdapter<Empresa> {
  @override
  final int typeId = 2;

  @override
  Empresa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Empresa(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as int,
      fields[9] as String,
      fields[10] as String,
      fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Empresa obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.rut)
      ..writeByte(1)
      ..write(obj.razonSocial)
      ..writeByte(2)
      ..write(obj.nombre)
      ..writeByte(3)
      ..write(obj.codigo)
      ..writeByte(4)
      ..write(obj.hash)
      ..writeByte(5)
      ..write(obj.token)
      ..writeByte(6)
      ..write(obj.codigoTerminal)
      ..writeByte(7)
      ..write(obj.cierreCentralizado)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.usuarioLogueado)
      ..writeByte(10)
      ..write(obj.usuarioLogueadoPassword)
      ..writeByte(11)
      ..write(obj.solicitarSignature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmpresaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
