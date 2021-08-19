import 'package:hive/hive.dart';
import 'package:mpos/src/modelo/enums/my_device_type_modelo.dart';
part 'my_device_modelo.g.dart';

@HiveType(typeId: 8)
class MyDevice {
  @HiveField(0)
  MyDeviceType deviceType;
  @HiveField(1)
  String deviceId;
  @HiveField(2)
  String deviceToken;
  @HiveField(3)
  String deviceName;
}

/*

CREATE TABLE [Device] ( 
  [DeviceType]  SMALLINT    NOT NULL, 
  [DeviceId]    CHAR(128)    NOT NULL, 
  [DeviceToken] CHAR(1000)    NOT NULL, 
  [DeviceName]  CHAR(128)    NOT NULL, 
     PRIMARY KEY ( [DeviceType],[DeviceId] ))
*/
