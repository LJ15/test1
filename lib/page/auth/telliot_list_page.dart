import 'dart:async';

import 'package:flutter/services.dart';

//import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../api/user_api.dart';
import '../../component/common_app_bar.dart';
import '../../component/dialog/error_dialog.dart';
import '../../component/dialog/notify_dialog.dart';
import '../../component/widget/telliot_progress_indicator.dart';
import '../../component/widget/telliot_slot_component.dart';
import '../../model/pairing_telliot.dart';
import 'select_wifi_page.dart';
import 'telliot_connecting_page.dart';
import 'package:provider/provider.dart';
import '../../state/auth_state.dart';
import '../../state/bluetooth_device_state.dart';
import '../../constant/telliot_colors.dart';

class TelliotListPage extends StatefulWidget {
  TelliotListPage(this.flag);

  final bool flag;

  @override
  _TelliotListPageState createState() => _TelliotListPageState();
}

class _TelliotListPageState extends State<TelliotListPage> {
  final flutterReactiveBle = FlutterReactiveBle();
  bool _connecting;
  bool _scanning = false;
  List<DiscoveredDevice> _scanResultList = [];
  StreamSubscription _scanStream;
  List<PairingTelliot> _pairingTelliots = [];

  @override
  initState() {
    super.initState();
    _connecting = false;
    _getPairingHistory();
    _startScan();
  }

  @override
  void dispose() {
    print(
        "==============================>telliot_list_page의 dispose(_stopScan())");
    _stopScan();
    super.dispose();
  }

  List<Map<String, dynamic>> _profileList = [
    {
      "profileImage": 'assets/profileImage/profile_1.png',
      "loading": false,
    },
    {
      "profileImage": 'assets/profileImage/profile_2.png',
      "loading": false,
    },
    {
      "profileImage": 'assets/profileImage/profile_3.png',
      "loading": false,
    },
    {
      "profileImage": 'assets/profileImage/profile_4.png',
      "loading": false,
    },
    {
      "profileImage": 'assets/profileImage/profile_5.png',
      "loading": false,
    },
  ];

  void _getPairingHistory() async {
    print(
        "===================================>telliot_list_page의 _getPairingHistory()");
    int _su_seq = context.read<AuthState>().me.su_seq;
    final historyList =
        await UserAPI(context: context).getUserPairingHistory(su_seq: _su_seq);
    setState(() {
      _pairingTelliots = historyList;
    });
  }

  // Future<bool> permission() async {
  //   Map<Permission, PermissionStatus> status =
  //       await [Permission.location].request();
  //
  //   if (await Permission.location.isGranted) {
  //     return Future.value(true);
  //   } else {
  //     return Future.value(false);
  //   }
  // }

  void _startScan() async {
    print(
        "===================================>telliot_list_page의 _startScan()");
    if (await Permission.location.isDenied) {
      await ErrorDialog.show(context,
          message: '위치 권한이 없습니다.\n권한을 허용한 뒤 다시 시도해주세요.');
      Navigator.pop(context);
      return;
    }
    _scanResultList.clear();
    _scanning = true;
    setState(() {});
    _scanStream = flutterReactiveBle.scanForDevices(withServices: [
      Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb'),
      Uuid.parse('696f7465-6474-656c-6c69-6f742d303031'),
      Uuid.parse('0000180f-0000-1000-8000-00805f9b34fb'),
    ], scanMode: ScanMode.lowLatency).listen(
      (device) {
        // 주변에 있는 텔리엇을 검색합니다.
        // 이 부분에서 텔리엇의 device id(ios: UUID, android: Mac Address)를 받습니다.
        // 검색 결과에 해당 결과값이 없을경우(중복 방지)
        if (_scanResultList
            .where((result) => result.name == device.name)
            .isEmpty) {
          // 등록된 텔리엇과 검색된 디바이스가 일치하지 않을 경우(중복 방지)
          if (_pairingTelliots.isEmpty ||
              _pairingTelliots.singleWhere((ph) => ph.ph_bt_mac == device.id,
                      orElse: () => null) ==
                  null) {
            setState(
              () {
                _scanResultList.add(device);
              },
            );
          }
        }
      },
    );
  }

  void _stopScan() async {
    print("===================================>telliot_list_page의 _stopScan()");
    await _scanStream.cancel();
    _scanning = false;
    setState(() {});
  }

  void _connectTelliot(DiscoveredDevice result) async {
    print(
        "===================================>telliot_list_page의 _connectTelliot()");
    final targetDevice = result;
    _stopScan();
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelliotConnectingPage(
            targetDevice, widget.flag
          ),
        ),
      );
    } catch (e) {
      print('error: $e');
      await NotifyDialog.show(context, message: '텔리엇 연결에 실패했습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        checkFunction: () async {
          _stopScan();
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
        color: TelliotColors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '텔리엇 등록',
                style: TextStyle(
                    fontSize: 24,
                    color: TelliotColors.primary,
                    height: 31.06 / 24),
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                '등록할 텔리엇을 선택하세요',
                style: TextStyle(
                    fontSize: 15,
                    height: 17.58 / 15,
                    color: TelliotColors.black),
              ),
              SizedBox(
                height: 69,
              ),
              if (_pairingTelliots.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '등록된 텔리엇',
                      style: TextStyle(
                          fontSize: 15,
                          height: 17.58 / 15,
                          color: TelliotColors.black),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Column(
                      children: [
                        ..._pairingTelliots.map(
                          (telliot) {
                            final isScanned = _scanResultList.singleWhere(
                                        (scaned) =>
                                            scaned.id == telliot.ph_bt_mac,
                                        orElse: () => null) !=
                                    null ||
                                (context.read<BlueState>().lastId != null &&
                                    context.read<BlueState>().lastId ==
                                        telliot.ph_telliot_id);
                            print(isScanned);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  _stopScan();
                                  if (context.read<BlueState>().lastId !=
                                          null &&
                                      context.read<BlueState>().lastId ==
                                          telliot.ph_telliot_id) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SelectWifiPage(
                                            widget.flag,
                                            telliotHistory:
                                                telliot.ph_seq.toString(),
                                            deviceName: telliot.ph_telliot_name,
                                            deviceId: telliot.ph_telliot_id,
                                          );
                                        },
                                      ),
                                    );
                                    return;
                                  } else {
                                    final device = _scanResultList.singleWhere(
                                        (result) =>
                                            result.id == telliot.ph_bt_mac,
                                        orElse: () => null);
                                    if (device != null) {
                                      _connectTelliot(device);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: '주변에 해당 텔리엇이 존재하지 않습니다.');
                                    }
                                  }
                                },
                                child: TelliotSlotComponent(
                                  telliot.ph_telliot_name,
                                  _profileList[telliot.ph_seq % 5]
                                      ['profileImage'],
                                  backgroundColor: isScanned
                                      ? TelliotColors.primary
                                      : TelliotColors.gray1,
                                  historySeq: telliot.ph_seq,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '등록 가능한 텔리엇',
                    style: TextStyle(
                        fontSize: 15,
                        height: 17.58 / 15,
                        color: TelliotColors.black),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (!_scanning)
                        _startScan();
                      // FlutterBlue.instance.startScan(
                      //     // timeout: Duration(seconds: 4),
                      //     withServices: [
                      //       Guid('696f7465-6474-656c-6c69-6f742d303031')
                      //     ]);
                      else
                        _stopScan();
                    },
                    child: Container(
                      color: TelliotColors.transparent,
                      child: _scanning
                          ? Center(
                              child: TelliotProgressIndicator(
                                  width: 20, stroke: 6))
                          : Image.asset(
                              'assets/refresh.png',
                              scale: 3,
                              color: TelliotColors.primary,
                            ),
                    ),
                  ),
                  if (_connecting)
                    TelliotProgressIndicator(
                      width: 20,
                      stroke: 6,
                    ),
                  SizedBox(
                    width: 9,
                  )
                ],
              ),
              SizedBox(
                height: 7,
              ),
              if (_scanResultList.isEmpty) Container(),
              Flexible(
                child: Column(
                  children: [
                    ..._scanResultList
                        .asMap()
                        .map(
                          (index, result) => MapEntry(
                            index,
                            _pairingTelliots.isEmpty ||
                                    _pairingTelliots
                                        .where(
                                          (telliot) =>
                                              telliot.ph_bt_mac != result.id,
                                        )
                                        .isNotEmpty
                                ? GestureDetector(
                                    onTap: Feedback.wrapForTap(() {
                                      _connectTelliot(result);
                                    }, context),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: TelliotSlotComponent(
                                          result.name,
                                          _profileList[index % 5]
                                              ["profileImage"]),
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                        .values
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
