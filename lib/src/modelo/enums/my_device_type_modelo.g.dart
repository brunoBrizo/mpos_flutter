// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_device_type_modelo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyDeviceTypeAdapter extends TypeAdapter<MyDeviceType> {
  @override
  final int typeId = 9;

  @override
  MyDeviceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MyDeviceType.Android;
      case 1:
        return MyDeviceType.IOS;
      case 2:
        return MyDeviceType.Windows;
      case 3:
        return MyDeviceType.Blackberry;
      default:
        return MyDeviceType.Android;
    }
  }

  @override
  void write(BinaryWriter writer, MyDeviceType obj) {
    switch (obj) {
      case MyDeviceType.Android:
        writer.writeByte(0);
        break;
      case MyDeviceType.IOS:
        writer.writeByte(1);
        break;
      case MyDeviceType.Windows:
        writer.writeByte(2);
        break;
      case MyDeviceType.Blackberry:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyDeviceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
