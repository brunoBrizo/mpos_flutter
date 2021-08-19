// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaccion_modelo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransaccionAdapter extends TypeAdapter<Transaccion> {
  @override
  final int typeId = 4;

  @override
  Transaccion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaccion()
      ..id = fields[0] as int
      ..user = fields[1] as String
      ..fecha = fields[2] as DateTime
      ..tipo = fields[3] as TipoTransaccion
      ..moneda = fields[4] as Moneda
      ..monto = fields[5] as double
      ..nroAutorizacion = fields[6] as String
      ..ticket = fields[7] as int
      ..nroFactura = fields[8] as int
      ..cuotas = fields[9] as int
      ..facturaMonto = fields[10] as double
      ..facturaMontoGravado = fields[11] as double
      ..facturaMontoIva = fields[12] as double
      ..montoPropina = fields[13] as double
      ..decretoLeyMonto = fields[14] as double
      ..firmarVoucher = fields[15] as bool
      ..tarjetaNumero = fields[16] as String
      ..tarjetaNombre = fields[17] as String
      ..tarjetaTitular = fields[18] as String
      ..aprobada = fields[19] as bool
      ..mid = fields[20] as String
      ..terminalId = fields[21] as int
      ..fueDevuelto = fields[22] as bool
      ..empCod = fields[23] as String
      ..termCod = fields[24] as String
      ..tokenNro = fields[25] as String
      ..tokenSegundosConsultar = fields[26] as int
      ..codigoRespuesta = fields[27] as String
      ..mensajeRespuesta = fields[28] as String
      ..ticketOriginal = fields[29] as int;
  }

  @override
  void write(BinaryWriter writer, Transaccion obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.fecha)
      ..writeByte(3)
      ..write(obj.tipo)
      ..writeByte(4)
      ..write(obj.moneda)
      ..writeByte(5)
      ..write(obj.monto)
      ..writeByte(6)
      ..write(obj.nroAutorizacion)
      ..writeByte(7)
      ..write(obj.ticket)
      ..writeByte(8)
      ..write(obj.nroFactura)
      ..writeByte(9)
      ..write(obj.cuotas)
      ..writeByte(10)
      ..write(obj.facturaMonto)
      ..writeByte(11)
      ..write(obj.facturaMontoGravado)
      ..writeByte(12)
      ..write(obj.facturaMontoIva)
      ..writeByte(13)
      ..write(obj.montoPropina)
      ..writeByte(14)
      ..write(obj.decretoLeyMonto)
      ..writeByte(15)
      ..write(obj.firmarVoucher)
      ..writeByte(16)
      ..write(obj.tarjetaNumero)
      ..writeByte(17)
      ..write(obj.tarjetaNombre)
      ..writeByte(18)
      ..write(obj.tarjetaTitular)
      ..writeByte(19)
      ..write(obj.aprobada)
      ..writeByte(20)
      ..write(obj.mid)
      ..writeByte(21)
      ..write(obj.terminalId)
      ..writeByte(22)
      ..write(obj.fueDevuelto)
      ..writeByte(23)
      ..write(obj.empCod)
      ..writeByte(24)
      ..write(obj.termCod)
      ..writeByte(25)
      ..write(obj.tokenNro)
      ..writeByte(26)
      ..write(obj.tokenSegundosConsultar)
      ..writeByte(27)
      ..write(obj.codigoRespuesta)
      ..writeByte(28)
      ..write(obj.mensajeRespuesta)
      ..writeByte(29)
      ..write(obj.ticketOriginal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransaccionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
