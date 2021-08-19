import 'package:hive/hive.dart';
part 'my_device_type_modelo.g.dart';

@HiveType(typeId: 9)
enum MyDeviceType {
  @HiveField(0)
  Android,
  @HiveField(1)
  IOS,
  @HiveField(2)
  Windows,
  @HiveField(3)
  Blackberry
}
