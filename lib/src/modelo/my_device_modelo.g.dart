// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_device_modelo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyDeviceAdapter extends TypeAdapter<MyDevice> {
  @override
  final int typeId = 8;

  @override
  MyDevice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyDevice()
      ..deviceType = fields[0] as MyDeviceType
      ..deviceId = fields[1] as String
      ..deviceToken = fields[2] as String
      ..deviceName = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, MyDevice obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.deviceType)
      ..writeByte(1)
      ..write(obj.deviceId)
      ..writeByte(2)
      ..write(obj.deviceToken)
      ..writeByte(3)
      ..write(obj.deviceName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyDeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
