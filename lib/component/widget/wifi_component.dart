import 'dart:convert';

import 'package:flutter/material.dart';
import '../../component/dialog/notify_dialog.dart';
import '../../component/dialog/password_dialog.dart';
import '../../component/widget/telliot_progress_indicator.dart';
import '../../constant/telliot_colors.dart';
import '../../state/bluetooth_device_state.dart';
import 'package:provider/provider.dart';

class WifiComponent extends StatefulWidget {
  /// 기기의 id를 전달합니다.
  final int slotIndex;

  /// 눌렀을 때 작동하는 함수를 작성합니다.
  ///
  /// String 변수에는 해당 네트워크의 이름을 전달합니다.
  final Future<void> Function() onPress;

  /// 와이파이가 존재 할 경우 그 데이터를 받습니다
  final Map<String, dynamic> wifi;

  /// 해당 슬롯에 와이파이 정보가 없을 경우 사용합니다.
  ///
  /// 기본 값은 false입니다.
  final bool isEmpty;

  /// 와이파이가 이미 등록이 되었을 경우 설정합니다.
  ///
  /// 기본값은 false 입니다.
  final bool existWifi;

  /// 와이파이 상태가 변경되었을 경우 사용하는 함수입니다.
  final Future<void> Function() fetch;

  /// 와이파이를 보여주는 컴포넌트 입니다.
  ///
  /// isEmpty 파라미터는 해당 컴포넌트에 와이파이 정보가 없을 경우를 의미합니다.
  ///
  /// deviceId는 다음 스캔하는 부분으로 넘겨줄 때 사용합니다.
  ///
  /// 추후에는 기기 정보를 모두 불러올 때 사용할 예정입니다.
  WifiComponent({
    this.slotIndex,
    this.onPress,
    this.isEmpty = false,
    this.existWifi = false,
    this.wifi,
    this.fetch,
  });

  @override
  _WifiComponentState createState() => _WifiComponentState();
}

class _WifiComponentState extends State<WifiComponent> {
  bool _isConnecting;
  String _encoding;

  Future<List<Map<String, dynamic>>> _searchPeriperalWifi() async {
    return await context.read<BlueState>().scanWifi(context: context);
  }

  List<String> _wifiIconList = [
    'assets/wifi/wifi_no_connection.png',
    'assets/wifi/wifi_1.png',
    'assets/wifi/wifi_2.png',
    'assets/wifi/wifi_max.png',
  ];
  @override
  void initState() {
    super.initState();
    _isConnecting = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEmpty)
      return GestureDetector(
        onTap: Feedback.wrapForTap(() async {
          if (widget.onPress != null) await widget.onPress();
        }, context),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: TelliotColors.gray3,
          ),
          child: Center(
            child: Text('네트워크 미등록 슬롯'),
          ),
        ),
      );

    Widget _signalIcon;
    final _signal = widget.wifi.containsKey('signal')
        ? widget.wifi['signal'].first - widget.wifi['signal'].last
        : 0;
    if (widget.existWifi) {
      _signalIcon = Image.asset('assets/wifi/wifi_lock.png',
          scale: 5, color: TelliotColors.white);
    } else if (0 > _signal && _signal >= -64) {
      _signalIcon =
          Image.asset(_wifiIconList[3], scale: 14, color: TelliotColors.white);
    } else if (-64 > _signal && _signal >= -72) {
      _signalIcon =
          Image.asset(_wifiIconList[2], scale: 14, color: TelliotColors.white);
    } else if (-72 > _signal) {
      _signalIcon =
          Image.asset(_wifiIconList[1], scale: 14, color: TelliotColors.white);
    } else
      _signalIcon =
          Image.asset(_wifiIconList[0], scale: 14, color: TelliotColors.white);

    return GestureDetector(
      onTap: Feedback.wrapForTap(() async {
        if (widget.onPress != null) {
          if (_isConnecting) return;
          setState(() {
            _isConnecting = true;
          });
          await widget.onPress();
          setState(() {
            _isConnecting = false;
          });
        }
      }, context),
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.fromLTRB(9, 12, 9, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: TelliotColors.primary,
          ),
          child: Row(
            children: [
              _signalIcon,
              SizedBox(
                width: 12,
              ),
              Container(
                width: constraints.biggest.width -
                    18 -
                    12 -
                    39 -
                    24 -
                    (_isConnecting ? 80 : 0),
                child: Text(
                  widget.wifi['name'],
                  style: TextStyle(
                      color: TelliotColors.white,
                      fontSize: 18,
                      height: 22 / 18),
                ),
              ),
              if (!_isConnecting && widget.existWifi)
                GestureDetector(
                  onTap: () async {
                    final result = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.symmetric(
                                horizontal:
                                MediaQuery.of(context).size.width *
                                    0.22),
                            contentPadding:
                            EdgeInsets.fromLTRB(34, 39, 32, 27),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            content: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery.of(context).size.width *
                                      0.56),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    '네트워크 설정',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: TelliotColors.black,
                                        fontWeight: FontWeight.w700,
                                        height: 22 / 16),
                                  ),
                                  SizedBox(height: 22),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context, 'modify');
                                    },
                                    child: Container(
                                      child: Text(
                                        '비밀번호 수정',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: TelliotColors.black,
                                            fontWeight: FontWeight.w400,
                                            height: 22 / 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, 'remove');
                                    },
                                    child: Container(
                                      child: Text(
                                        '삭제',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: TelliotColors.black,
                                            fontWeight: FontWeight.w400,
                                            height: 22 / 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: Feedback.wrapForTap(() {
                                          Navigator.pop(context);
                                        }, context),
                                        child: Text(
                                          '취소',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: TelliotColors.black,
                                              fontWeight: FontWeight.w400,
                                              height: 22 / 16),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        } ??
                            null);
                    if (result == 'modify') {
                      final _matchWifi = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (buildContext) {
                            _searchPeriperalWifi().then((wifiList) {
                              final _wifi = wifiList.singleWhere(
                                      (wifi) => wifi['name'] == widget.wifi['name'],
                                  orElse: () => null);
                              Navigator.of(buildContext).pop(_wifi);
                            });
                            return AlertDialog(
                              content: TelliotProgressIndicator(
                                  width: 20,
                                  stroke: 6,
                                  label: '와이파이를 찾는 중입니다.', colorList: [],),
                            );
                          });
                      if (_matchWifi == null) {
                        await NotifyDialog.show(context,
                            message: '주변에 해당 와이파이가 존재하지 않습니다.');
                        return;
                      }
                      final response = await PasswordDialog.show(context,
                          networkName: widget.wifi['name'],
                          okFunction: (password) async {
                            try {
                              await context.read<BlueState>().changeWifiPassword(
                                wifiName: widget.wifi['name'],
                                password: password,
                                slotIndex: widget.slotIndex,
                                security: _matchWifi['security'],
                                wifiChannel: _matchWifi['channel'],
                              );
                              return 200;
                            } catch (e) {
                              print(e);
                              NotifyDialog.show(context,
                                  message: '비밀번호를 다시 확인해주세요.');
                              return 404;
                            }
                          }, cancelLabel: '');
                      if (response == PasswordDialogResult.ok) {
                        if (widget.fetch != null) widget.fetch();
                      }
                    }
                    if (result == 'remove') {
                      try {
                        await context
                            .read<BlueState>()
                            .removeWififromTelliot(slotIndex: widget.slotIndex);
                        if (widget.fetch != null) widget.fetch();
                      } catch (e) {
                        print(e);
                        NotifyDialog.show(context, message: e.value.first);
                      }
                    }
                  },
                  child: Image.asset('assets/icon/setting.png',
                      scale: 3.5, color: TelliotColors.white),
                ),
            ],
          ),
        );
      }),
    );
  }
}
