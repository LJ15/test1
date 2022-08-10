import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../component/dialog/error_dialog.dart';
import '../component/dialog/notify_dialog.dart';
import '../constant/telliot_attribute.dart';
import 'package:utf/utf.dart';

class BlueState extends ChangeNotifier {
  // ChangeNotifier : 청취자에게 변경 알림을 제공해줌
  final flutterReactiveBle = FlutterReactiveBle(); //초기화

  // StreamSubscription : 스트림과 이벤트의 연결고리, 이벤트에 변경이 생기면 처리함.
  // 새로운 이벤트가 생기거나, 에러가 생기면 StreamSubscription에서 이를 처리한다.
  // 이벤트 처리를 콜백을 정해서 한다.
  // ConnectionStateUpdate : Status update for a specific BLE device.
  StreamSubscription<ConnectionStateUpdate> get connection => _connection;

  int get lastDevice => _lastDevice;

  String get lastId => _lastId;

  bool get connected => _isConnected;

  bool get loading => _loading;

  String get name => _name;

  int get battery => _battery;

  String get modelNumber => _modelNumber;

  String get firmwareVersion => _FWVersion;

  Map<String, dynamic> get deviceMap => _userToHistoryDeviceMap;

  Map<String, List<int>> get dataList => _dataList;

  // listen 하기 전엔 Stream이 이벤트 소스와 연결되어 있다.
  Stream<ConnectionStateUpdate> _currentConnectionStream;

  // listen 한 후엔 StreamSubscription과 EventSource가 연결됨..
  StreamSubscription<ConnectionStateUpdate> _connection;
  Map<String, List<int>> _dataList = {};

  bool _isConnected = false;
  int _lastDevice;
  String _lastId;

  // QualifiedCharacteristic : 블루투스 읽기/쓰기에 사용
  QualifiedCharacteristic _readName;
  QualifiedCharacteristic _readModelNumber;
  QualifiedCharacteristic _readFW;
  QualifiedCharacteristic _readSW;
  QualifiedCharacteristic _setting;
  QualifiedCharacteristic _sensor;
  QualifiedCharacteristic _readBattery;

  // deviceInformation
  String _name;
  int _battery;
  String _modelNumber;
  String _FWVersion;

  // user information
  Map<String, dynamic> _userToHistoryDeviceMap = {};

  /// ios loading
  bool _loading = false;

  //블루투스를 연결하면 BluetoothDevice 정보를 storage에
  //jsonEncode해서 저장해보고
  //자동로그인 시점에서 jsonDecode 하여 연결 가능 여부를 살핀다.
  //만약 가능하다면 연결하는 방식으로 해볼것.

  final settingUrl = '74737663-2d73-6574-7469-6e672d303032';
  final sensorUrl = '74737663-2d73-656e-736f-72732d303033';
  final infoService = Uuid.parse('0000180A-0000-1000-8000-00805f9b34fb');
  final settingService = Uuid.parse('696f7465-6474-656c-6c69-6f742d303031');
  final batteryService = Uuid.parse('0000180F-0000-1000-8000-00805f9b34fb');

  void connectSuccessResetName() async {
    _name = null; // 디바이스 이름
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줌..
  }

  Future<void> getTelliotName() async {
    try {
      if (Platform.isAndroid) {
        final name = await readData(char: _readName);
        _name = name;
        return;
      }
      flutterReactiveBle.readCharacteristic(_readName);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTelliotModelNumber() async {
    try {
      if (Platform.isAndroid) {
        final modelNumber = await readData(char: _readModelNumber);
        _modelNumber = modelNumber;
        return;
      }
      flutterReactiveBle.readCharacteristic(_readModelNumber);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTelliotFW() async {
    try {
      if (Platform.isAndroid) {
        final firmware = await readData(char: _readFW);
        _FWVersion = firmware;
        return;
      }
      flutterReactiveBle.readCharacteristic(_readFW);
    } catch (e) {
      print(e);
    }
  }

  void setDevice(String id) async {
    // FlutterSecureStorage : 자동 로그인 기능을 가능하게 함. 기기에 로그인 정보가 저장되게 함.
    FlutterSecureStorage storage = FlutterSecureStorage();
    _lastId = id;

    await storage.write(key: 'device', value: id);
  }

  void addData(Map<String, List<int>> data) {
    _dataList.addAll(data);
    notifyListeners();
  }

  void connectTelliot({
    BuildContext context,
    DiscoveredDevice device,
    void Function() afterConnectFunction,
    Future<void> Function() disconnectFunction,
  }) async {
    FlutterSecureStorage storage = FlutterSecureStorage();

    // 이미 블루투스가 연결되어 있다면 연결을 끊어라!
    if (_currentConnectionStream != null) {
      print(
          "===================================>bluetooth_device_state의 connectTelliot()에서 ");
      await disconnectTelliot();
    }

    // 블루투스 연결
    _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
        id: device.id,
        withServices: [infoService, settingService, batteryService],
        prescanDuration: Duration(seconds: 25),
        connectionTimeout: Duration(seconds: 30),
        servicesWithCharacteristicsToDiscover: {
          infoService: [
            TelliotAttribute.readName,
            TelliotAttribute.readModelNumber,
            TelliotAttribute.readSW,
            TelliotAttribute.readFW,
          ],
          settingService: [
            TelliotAttribute.settingData,
            TelliotAttribute.sensorData,
          ],
          batteryService: [TelliotAttribute.readBatteryLevel],
        });

    await storage.write(key: 'device', value: device.id);

    _connection = _currentConnectionStream.listen((connectedDevice) async {
      var id = connectedDevice.deviceId.toString();

      switch (connectedDevice.connectionState) {
        case DeviceConnectionState.connecting:
          {
            print(
                "===================================>bluetooth_device_state의 connectTelliot()에서 ");
            print('isConnecting...');
            break;
          }
        case DeviceConnectionState.connected:
          _readName = QualifiedCharacteristic(
              serviceId: infoService,
              characteristicId: TelliotAttribute.readName,
              deviceId: id);
          _readModelNumber = QualifiedCharacteristic(
              serviceId: infoService,
              characteristicId: TelliotAttribute.readModelNumber,
              deviceId: id);
          _readFW = QualifiedCharacteristic(
              serviceId: infoService,
              characteristicId: TelliotAttribute.readFW,
              deviceId: id);
          _readSW = QualifiedCharacteristic(
              serviceId: infoService,
              characteristicId: TelliotAttribute.readSW,
              deviceId: id);
          _setting = QualifiedCharacteristic(
              serviceId: settingService,
              characteristicId: TelliotAttribute.settingData,
              deviceId: id);
          _sensor = QualifiedCharacteristic(
              serviceId: settingService,
              characteristicId: TelliotAttribute.sensorData,
              deviceId: id);
          _readBattery = QualifiedCharacteristic(
              serviceId: batteryService,
              characteristicId: TelliotAttribute.readBatteryLevel,
              deviceId: id);
          final dataStream =
              flutterReactiveBle.subscribeToCharacteristic(_setting);
          // if (Platform.isAndroid) {
          //   await flutterReactiveBle.clearGattCache(device.id);
          // }
          await Future.delayed(Duration(milliseconds: 300));

          try {
            flutterReactiveBle
                .writeCharacteristicWithResponse(_setting, value: [0x21]);
          } catch (e, s) {
            print("==========================>bt write error");
            print(e);
            print(s);
            if (disconnectFunction != null) {
              disconnectFunction();
              return;
            }

            await ErrorDialog.show(
              context,
              message: '페어링 상태가 아닙니다.\n페어링 상태로 진입 후 다시 시도해주세요.',
            );

            Navigator.pop(context);

            disconnectTelliot();
            return;
          }

          _isConnected = true;
          notifyListeners();

          if (afterConnectFunction != null) afterConnectFunction();
          if (Platform.isIOS) {
            final stream = flutterReactiveBle.characteristicValueStream;

            stream.listen((data) {
              final _targetChar = data.characteristic;
              data.result.iif(success: (result) {
                print('');
                _loading = true;
                notifyListeners();
                if (_targetChar.characteristicId == Uuid([0x2a, 0x29])) {
                  _name = String.fromCharCodes(result);
                  notifyListeners();
                } else if (_targetChar.characteristicId == Uuid([0x2a, 0x19])) {
                  _battery = result[0];
                  notifyListeners();
                } else if (_targetChar.characteristicId == Uuid([0x2a, 0x24])) {
                  _modelNumber = String.fromCharCodes(result);
                  notifyListeners();
                } else if (_targetChar.characteristicId == Uuid([0x2a, 0x26])) {
                  _FWVersion = String.fromCharCodes(result);
                  notifyListeners();
                } else {}
                _loading = false;
                notifyListeners();
              }, failure: (failure) {
                _loading = false;
                notifyListeners();
              });
            });
          }

          dataStream.listen((data) {
            print('');
            switch (data.first) {
              case 0x81:
                {
                  _dataList.addAll({'addWifi': data});
                  print('addwifi : $data');
                  notifyListeners();
                  break;
                }
              case 0x82:
                {
                  _dataList.addAll({'removeWifi': data});
                  print('removewifi : $data');
                  notifyListeners();
                  break;
                }
              case 0x83:
                {
                  _dataList.addAll({'connectWifi': data});
                  print('connectwifi : $data');
                  notifyListeners();
                  break;
                }
              case 0x84:
                {
                  _dataList.addAll({'getWifiList': data});
                  print('getWifiList : $data');
                  notifyListeners();
                  break;
                }
              case 0x85:
                {
                  if (data.last == 0xAF) {
                    //0xAF = Countinue
                    _dataList.addAll({'scanWifi1': data});
                    print('scanwifi : $data');
                    notifyListeners();
                    //print('스캔 1: $data');
                  } else if (data.last == 0xCF) {
                    //0xCF = Finish
                    _dataList.addAll({'scanWifi2': data});
                    print('scanwifi2 : $data');
                    notifyListeners();
                    //print('스캔 2: $data');
                  }
                  break;
                }
              case 0xA1:
                {
                  _dataList.addAll({'version': data});
                  print('version : $data');
                  notifyListeners();
                  break;
                }
              case 0xA5:
                {
                  _dataList.addAll({'update': data});
                  print('update : $data');
                  notifyListeners();
                  break;
                }
              case 0xB1:
                {
                  _dataList.addAll({'alarm': data});
                  print('alarm : $data');
                  notifyListeners();
                  break;
                }
              case 0xF1:
                {
                  _dataList.addAll({'retrieve': data});
                  print('retrieve : $data');
                  notifyListeners();
                  break;
                }

              default:
                throw '잘못된 요청입니다.';
            }
          }, onError: (e) {
            if (disconnectFunction != null) {
              disconnectFunction();
              return;
            }
          });
          break;

        case DeviceConnectionState.disconnecting:
          break;
        case DeviceConnectionState.disconnected:
          {
            _isConnected = false;
            notifyListeners();
            // throw 'why';
            print('context.widget: ${context.widget}');
            Fluttertoast.showToast(msg: '텔리엇과의 연결이 끊어졌습니다.');
          }
      }
      notifyListeners();
    }, onError: (e, s) async {
      print(e);
      print(s);
      if (disconnectFunction != null) {
        disconnectFunction();
        return;
      }
      await ErrorDialog.show(context,
          message: '텔리엇 연결에 실패하였습니다.\n텔리엇을 확인 후 다시 시도해주세요.');
      disconnectTelliot();

      Navigator.pop(context);
    });
  }

  void notifyConnected(bool connectState) {
    _isConnected = connectState;
    notifyListeners();
  }

  Future<dynamic> readData(
      {QualifiedCharacteristic char, bool rawData = false}) async {
    final _targetChar = await flutterReactiveBle.readCharacteristic(char);
    if (rawData) return _targetChar;
    return String.fromCharCodes(
        _targetChar); // fromCharCodes : 유니코드 값을 문자열로 반환 (Android)
  }

  Future<void> writeAndGetResponseData(
      {QualifiedCharacteristic char, List<int> data}) async {
    if (char == null) return null;
    // 되돌아오는 응답이 있을 경우 사용
    await flutterReactiveBle.writeCharacteristicWithResponse(char, value: data);
    notifyListeners();
  }

  Future<int> changeWifiPassword({
    String wifiName,
    String password,
    int slotIndex,
    List<int> security,
    int wifiChannel,
  }) async {
    final _targetChar = _setting;
    final data = [
      0x01,
      slotIndex,
      wifiName.length,
      ...utf8.encode(wifiName),
      ...security,
      password.length,
      ...utf8.encode(password),
      wifiChannel,
      1,
    ];
    // _targetChar.onValueChangedStream
    // 이 부분 사용해서 데이터 얻어오는걸로.
    await flutterReactiveBle.writeCharacteristicWithResponse(_targetChar,
        value: data);
    final addData = _dataList['addWifi'];
    if (addData == null) {
      throw new ErrorDescription('알 수 없는 오류가 발생했습니다.');
    }
    if (addData.last != 16) throw new ErrorDescription('와이파이 비밀번호 변경에 실패했습니다.');
    return addData.last;
  }

  /// Sending to Telliot
  /// for Connect and Add WIFI Network.

  Future<int> addWifiRequest(
      {int slotIndex,
      String wifiName,
      List<int> wifiSecurity,
      String password,
      int channelNumber,
      bool isInitConnection}) async {
    int isInit = isInitConnection ? 1 : 0;

    List<int> encodeName = utf8.encode(wifiName);

    final data = [
      0x01,
      slotIndex,
      //wifiName.length,
      encodeName.length,
      ...utf8.encode(wifiName),
      ...wifiSecurity,
      password.length,
      ...utf8.encode(password),
      channelNumber,
      isInit
    ];

    await writeAndGetResponseData(char: _setting, data: data);
    final addWifi = _dataList['addWifi'];
    if (addWifi == null) {
      _dataList.addAll({'addWifi': addWifi});
      notifyListeners();
      throw new ErrorDescription('알 수 없는 오류가 발생했습니다.');
    }
    if (addWifi.last != 16) {
      _dataList.addAll({'addWifi': addWifi});
      notifyListeners();
      print(_dataList);
      throw new ErrorDescription('와이파이 연결에 실패했습니다.');
    }
    return addWifi.last;
  }

  Future<dynamic> removeWififromTelliot({int slotIndex}) async {
    final data = [0x02, slotIndex];

    await writeAndGetResponseData(char: _setting, data: data);

    final response = _dataList['removeWifi'];
    if (response == null || response.first != 0x82)
      throw new ErrorDescription('오류가 발생했습니다.');
    print({
      'code': response.first,
      if (response.length != 1) 'result': response.last
    });
    return {
      'code': response.first,
      if (response.length != 1) 'result': response.last
    };
  }

  Future<dynamic> connectWifiRequest({int slotIndex}) async {
    final data = [0x03, slotIndex];

    await writeAndGetResponseData(char: _setting, data: data);

    final response = _dataList['connectWifi'];
    if (response == null || response.first != 0x83)
      throw new ErrorDescription('오류가 발생했습니다.');

    return {
      'code': response.first,
      if (response.length != 1) 'result': response.last
    };
  }

  /// Getting to Telliot
  /// Registered Wifi Data.

  Future<List<Map<String, dynamic>>> getWifiList() async {
    print(
        "===================================>bluetooth_device_state의 _getWifiList()");
    final data = [0x04];

    await flutterReactiveBle.writeCharacteristicWithResponse(_setting,
        value: data);

    List<int> response = _dataList['getWifiList'];
    if (response == null) return [];

    final List<Map<String, dynamic>> formatData = [];

    response = response.sublist(1);
    final count = response.first;
    response = response.sublist(1);
    for (var i = 0; i < count; i++) {
      final index = response.first;
      response = response.sublist(1);

      final length = response.first;
      response = response.sublist(1);

      final name = response.sublist(0, length);
      response = response.sublist(length);
      final connected = response.first;
      response = response.sublist(1);
      formatData.add({
        'index': index,
        'name': utf8.decode(name),
        //'name': String.fromCharCodes(name),
        'status': connected,
      });
    }
    print('formatData: $formatData');
    return formatData;
  }

  /// Get result which of scan wifi data from Telliot.
  /// The number of times the data is received depends on the last value.

  Future<List<Map<String, dynamic>>> scanWifi({BuildContext context}) async {
    print(
        "===================================>bluetooth_device_state의 _scanWifi()");
    final data = [0x05];

    await Future.wait([
      flutterReactiveBle.writeCharacteristicWithResponse(_setting, value: data)
    ]);

    List<Map<String, dynamic>> formatData = [];
    //if (response == null || response.first != 0x85)
    //  throw new ErrorDescription('오류가 발생했습니다.');

    if (_dataList['scanWifi1'] == null && _dataList['scanWifi2'] == null)
      return [];
    else if (dataList['scanWifi1'] != null && dataList['scanWifi2'] != null) {
      final List<int> response1 = _dataList['scanWifi1'];
      final List<int> response2 = dataList['scanWifi2'];

      final scanResult result1 = await dataWifi(response1, context: null);
      final scanResult result2 = await dataWifi(response2, context: null);

      formatData = (result1.formatDataResult() + result2.formatDataResult());
    } else if (dataList['scanWifi1'] == null && dataList['scanWifi2'] != null) {
      final List<int> response = dataList['scanWifi2'];
      final scanResult result = await dataWifi(response, context: null);

      formatData = (result.formatDataResult());
    }
    return formatData;
  }

  Future<scanResult> dataWifi(List<int> response,
      {BuildContext context}) async {
    List<Map<String, dynamic>> formatData = [];
    print(response.sublist(1));
    response = response.sublist(1);
    final count = response.first;

    //if (count == 0xFF) throw new ErrorDescription('와이파이 스캔중입니다.');
    if (count > 0x0a || count < 0) {
      new ErrorDescription('wifi 재검색이 필요합니다.');
      //return [];
    } else {
      response = response.sublist(1);

      try {
        for (var i = 0; i < count; i++) {
          if (response.length < 7) break;
          final resultLength = (2 + 4 + 1 + 1 + response[7]);
          final signal = response.sublist(0, 2);
          final security = response.sublist(2, 6);
          final channel = response.sublist(6, 7);
          if (response.length < resultLength + 1) break;
          final name = response.sublist(8, resultLength);

          response = response.sublist(resultLength);

          formatData.add({
            'index': i,
            'name': utf8.decode(name),
            //'name': String.fromCharCodes(name),
            'signal': signal,
            'security': security,
            'channel': channel.first,
          });
        }
      } catch (e, s) {
        print(e);
        print(s);
        NotifyDialog.show(context, message: '와이파이 찾기에 실패했습니다.');
      }
      return new scanResult(response, formatData);
    }
  }

  Future<void> getBatteryLevel() async {
    if (Platform.isAndroid) {
      final battery = await readData(char: _readBattery, rawData: true);
      _battery = battery.first;
      return;
    }
    readData(char: _readBattery, rawData: true);
  }

  Future<dynamic> getIdAndVersion() async {
    await writeAndGetResponseData(char: _setting, data: [0x21]);

    List<int> response = _dataList['version'];

    // if (response == null || response.first != 161)
    //   throw new ErrorDescription('올바르지 않은 요청입니다.');
    if (response == null) return {};
    final code = response.first;
    response = response.sublist(1);
    Map<String, dynamic> dataFormat = {};

    for (int i = 0; i < 2; i++) {
      final type = response.first == 2 ? 'version' : 'id';
      response = response.sublist(1);
      final name = response.sublist(1, response.first + 1);
      response = response.sublist(response.first + 1);

      dataFormat.addAll({
        type: String.fromCharCodes(name),
      });
    }

    return {'code': code, 'data': dataFormat};
  }

  Future<dynamic> getTime({List<int> alarm, onOff, hour, minute}) async {
    final data = [0x31, alarm, onOff[0], hour[0], minute[0]];
    await writeAndGetResponseData(char: _setting, data: data);

    final response = _dataList['alarm'];

    return response;
  }

  Future<void> requestUpdateFW() async {
    await writeAndGetResponseData(char: _setting, data: [0x25]);

    final response = _dataList['update'];
    if (response == null || response.first != 0xA5)
      throw new ErrorDescription('올바르지 않은 요청입니다.');

    if (response.last == 0x01) throw new ErrorDescription('업데이트 요청이 실패했습니다');

    //true이면 업데이트 진행
    // Map<String, dynamic> dataFormat = {
    //   'code': response.first,
    //   'type': response.
    // };
  }

  Future<void> disconnectTelliot() async {
    print(
        "===================================>bluetooth_device_state의 _disconnectTelliot()");
    if (_connection != null) {
      await _connection?.cancel();
      _connection = null;
      _isConnected = false;
      _lastId = null;
    }
    notifyListeners();
  }
}

class scanResult {
  List<int> responseResult;
  List<Map<String, dynamic>> formatResult = [];

  scanResult(List<int> responseResult, List<Map<String, dynamic>> formatResult)
      : this.responseResult = responseResult,
        this.formatResult = formatResult;

  List<int> scanWifiResult() => responseResult;

  List<Map<String, dynamic>> formatDataResult() => formatResult;
}
