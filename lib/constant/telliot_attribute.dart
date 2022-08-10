import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

abstract class TelliotAttribute {
  static Uuid get readName =>
      Uuid.parse('00002a29-0000-1000-8000-00805f9b34fb');
  static Uuid get readModelNumber =>
      Uuid.parse('00002a24-0000-1000-8000-00805f9b34fb');
  static Uuid get readFW => Uuid.parse('00002a26-0000-1000-8000-00805f9b34fb');
  static Uuid get readSW => Uuid.parse('00002a28-0000-1000-8000-00805f9b34fb');
  static Uuid get sensorData =>
      Uuid.parse('74737663-2d73-656e-736f-72732d303033');
  static Uuid get settingData =>
      Uuid.parse('74737663-2d73-6574-7469-6e672d303032');
  static Uuid get readBatteryLevel =>
      Uuid.parse('00002a19-0000-1000-8000-00805f9b34fb');
}
