import 'dart:convert';

import 'package:flutter/material.dart';
import '../../component/common_app_bar.dart';
import '../../component/dialog/notify_dialog.dart';
import '../../component/dialog/password_dialog.dart';
import '../../component/widget/wifi_component.dart';
import '../../constant/telliot_colors.dart';
import '../../state/bluetooth_device_state.dart';
import 'package:provider/provider.dart';

class ScanWifiPage extends StatefulWidget {
  final int _slotIndex;
  final bool flag;

  ScanWifiPage(this._slotIndex, this.flag);

  @override
  _ScanWifiPageState createState() => _ScanWifiPageState();
}

class _ScanWifiPageState extends State<ScanWifiPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _scanning;
  AnimationController _animationController;
  BlueState _blueState;
  List<Map<String, dynamic>> _exsistWifi = [];
  List<Map<String, dynamic>> _scannedWifi = [];

  @override
  initState() {
    super.initState();
    _blueState = context.read<BlueState>();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          });

    _animationController.repeat();
    _scanning = false;
    _scanWifi();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _scanWifi() async {
    setState(() {
      _scanning = true;
      _animationController.repeat();
    });

    try {
      final result = await _blueState.scanWifi(context: context);
      _scannedWifi = result;
      setState(() {
        _scanning = false;
        _animationController.stop();
      });
    } catch (e, s) {
      await NotifyDialog.show(context,
          message: '와이파이 데이터를 가져오는데 실패했습니다.\n페어링 상태를 확인해주세요.');
      Navigator.pop(
        context,
      );

      print("오류");
      print(s);
    }
  }

  /// 와이파이 정보를 텔리엇에 저장한다.
  ///
  /// 비밀번호는 텔리엇에 전달 시, 연결 여부를 받아서 일치 여부를 판단한다.
  ///
  /// 신호 강도에 따라 아이콘을 다르게 표시한다.
  ///
  /// 0 ~ -64dBm => max / -65 ~ -72 dBm => middle => -73dBm > => weak, else => no signal
  Future<void> _connect(String networkName) async {
    await Future.delayed(Duration(seconds: 1));
    final result = await PasswordDialog.show(context, networkName: networkName,
        okFunction: (password) async {
      if (password == '0000') return 200;
      return 404;
    });
    if (result == PasswordDialogResult.ok) {
      Navigator.pop(context, widget._slotIndex);
    }
  }

  Widget _currentNetwork() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            '현재 네트워크',
            style: TextStyle(
                color: TelliotColors.black, fontSize: 15, height: 17.6 / 15),
          ),
        ),
        SizedBox(
          height: 7,
        ),
        ..._exsistWifi.map((wifi) {
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            child: WifiComponent(
              onPress: () => _connect(wifi['name']),
            ),
          );
        }),
      ],
    );
  }

  Widget _scannedNetwork() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '사용 가능한 네트워크',
                style: TextStyle(
                    color: TelliotColors.black,
                    fontSize: 15,
                    height: 17.6 / 15),
              ),
              GestureDetector(
                onTap: Feedback.wrapForTap(() {
                  if (!_scanning) _scanWifi();
                }, context),
                child: RotationTransition(
                  turns: Tween<double>(begin: 1, end: 0)
                      .animate(_animationController),
                  child: Image.asset(
                    'assets/refresh.png',
                    scale: 3,
                    color: TelliotColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Column(
          children: _scanning
              ? [
                  Container(),
                ]
              : _scannedWifi.map((wifi) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(wifi['name']),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: WifiComponent(
                        wifi: wifi,
                        fetch: () async {
                          _scanWifi();
                        },
                        onPress: () async {
                          final result = await PasswordDialog.show(
                            context,
                            networkName: wifi['name'],
                            okFunction: (password) async {
                              try {
                                await context.read<BlueState>().addWifiRequest(
                                      slotIndex: widget._slotIndex,
                                      wifiName: wifi['name'],
                                      wifiSecurity: wifi['security'],
                                      channelNumber: wifi['channel'],
                                      isInitConnection: true,
                                      password: password,
                                    );
                                return 200;
                              } catch (e) {
                                print(e);
                                if (e is ErrorDescription)
                                  await NotifyDialog.show(context,
                                      message: '와이파이 연결에 실패했습니다.');
                                await context
                                    .read<BlueState>()
                                    .removeWififromTelliot(
                                        slotIndex: widget._slotIndex);
                                return 404;
                              }
                              // final resposne = await context
                              //     .read<BlueState>()
                              //     .connectWifiRequest(slotIndex: widget._slotIndex);
                            },
                          );
                          if (result == PasswordDialogResult.ok) {
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                  );
                }).toList(growable: false),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CommonAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        color: TelliotColors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wi-Fi 네트워크 선택',
                style: TextStyle(
                    color: TelliotColors.primary,
                    fontSize: 24,
                    height: 31 / 24),
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                '네트워크 슬롯에 등록하여 텔리엇이 연결할\n네트워크를 선택해 주세요.',
                style: TextStyle(
                    color: TelliotColors.black,
                    fontSize: 15,
                    height: 17.6 / 15),
              ),
              SizedBox(height: 59),
              if (_exsistWifi.isNotEmpty) _currentNetwork(),
              if (_exsistWifi.isNotEmpty)
                SizedBox(
                  height: 39,
                ),
              _scannedNetwork()
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
