import 'package:flutter/material.dart';

import '../../api/user_api.dart';
import '../../component/common_app_bar.dart';
import '../../component/common_button.dart';
import '../../component/widget/telliot_progress_indicator.dart';
import '../../component/widget/wifi_component.dart';
import '../../constant/telliot_colors.dart';
import '../home/homepage.dart';
import 'scan_wifi_page.dart';
import '../../state/auth_state.dart';
import '../../state/bluetooth_device_state.dart';
import 'package:provider/provider.dart';

class SelectWifiPage extends StatefulWidget {
  final String deviceId;
  final String deviceName;

  ///등록시 저장했던 텔리엇 고유의 id,
  final String telliotHistory;
  final bool setting;
  final bool flag;

  SelectWifiPage(this.flag,
      {this.telliotHistory,
      this.setting = false,
      this.deviceId,
      this.deviceName});

  @override
  _SelectWifiPageState createState() => _SelectWifiPageState();
}

class _SelectWifiPageState extends State<SelectWifiPage> {
  String get deviceId => widget.deviceId;

  String get telliotHistory => widget.telliotHistory;
  BlueState _blueState;
  Future<List<Map<String, dynamic>>> _future;
  bool _fetching;
  bool _saved;

  @override
  initState() {
    super.initState();
    _blueState = context.read<BlueState>();
    _fetching = false;
    _future = _blueState.getWifiList();
    _saved = false;
  }

  Future<bool> _saveTelliot() async {


    try {
      if (telliotHistory != null) return true;
      final telliotId = await context.read<BlueState>().getIdAndVersion();

      final _historyList = await UserAPI(context: context)
          .getUserPairingHistory(su_seq: context.read<AuthState>().me.su_seq);

      final exsisted = _historyList.singleWhere(
          (history) => history.ph_telliot_id == telliotId['data']['id'],
          orElse: () => null);
      // 등록에 성공할 때 반환되는 히스토리 id값(시퀀스).
      if (widget.deviceName != null) {
        final response = telliotHistory ??
            (exsisted != null
                ? exsisted.ph_seq
                : await UserAPI(context: context)
                    .insertTelliotToUserPairingHistory(
                        telliotId: telliotId['data']['id'],
                        telliotName: widget.deviceName,
                        btMac: deviceId));
        context.read<BlueState>().setDevice(telliotId['data']['id']);
        await UserAPI(context: context).connectTelliot(
            historySeq: response is int ? response : int.parse(response));
      }

      if (widget.deviceName != null) {
        context.read<BlueState>().connectSuccessResetName();
        return true;
      }

      return false;
    } catch (e, s) {
      print(e);
      print(s);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(checkFunction: () async {
          if (!_saved) await _saveTelliot();
          if (!widget.setting) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(
                        title: '약공급기로봇',
                      )),
            );
          }
          return Navigator.pop(context);
        }),
        body: _fetching
            ? Center(child: TelliotProgressIndicator(width: 20, stroke: 6))
            : WillPopScope(
                onWillPop: () async {
                  if (!context.read<BlueState>().connected) {
                    Navigator.pop(context);
                    return true;
                  }
                  if (!_saved) await _saveTelliot();
                  if (!widget.setting) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(
                                title: '약공급기로봇',
                              )),
                    );
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                    color: TelliotColors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wi-Fi 네트워크 슬롯 선택',
                          style: TextStyle(
                              color: TelliotColors.primary,
                              fontSize: 24,
                              height: 31 / 24),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '사용할 네트워크 슬롯을 선택하세요.\n(최대 5개까지 등록 가능)',
                          style: TextStyle(
                              color: TelliotColors.black, height: 17.6 / 15),
                        ),
                        SizedBox(height: 59),
                        Row(
                          children: [
                            Text(
                              '네트워크 슬롯',
                              style: TextStyle(
                                  color: TelliotColors.black,
                                  fontSize: 15,
                                  height: 17.6 / 15),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                _future = _blueState.getWifiList();
                                setState(() {});
                              },
                              child: Container(
                                color: TelliotColors.transparent,
                                padding: EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/refresh.png',
                                  scale: 3,
                                  color: TelliotColors.primary,
                                ),
                              ),
                            )
                          ],
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                            initialData: [],
                            future: _future,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done)
                                return Center(
                                  child: TelliotProgressIndicator(
                                    width: 20,
                                    stroke: 6,
                                  ),
                                );
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 7,
                                  ),
                                  if (snapshot.hasData)
                                    ...snapshot.data
                                        .asMap()
                                        .map(
                                          (index, wifi) => MapEntry(
                                            index,
                                            Column(
                                              children: [
                                                WifiComponent(
                                                  onPress: () async {},
                                                  slotIndex: index,
                                                  wifi: wifi,
                                                  isEmpty: false,
                                                  existWifi: true,
                                                  fetch: () async {
                                                    _future = _blueState
                                                        .getWifiList();
                                                    setState(() {});
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .values,
                                  ...List.generate(
                                      5 - (snapshot.data ?? []).length,
                                      (index) {
                                    return Column(
                                      children: [
                                        WifiComponent(
                                          slotIndex: 1,
                                          isEmpty: true,
                                          onPress: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ScanWifiPage(
                                                        index +
                                                            (snapshot.data ??
                                                                    [])
                                                                .length,
                                                        widget.flag),
                                              ),
                                            );
                                            if (result != null) {
                                              _future =
                                                  _blueState.getWifiList();
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    );
                                  }),
                                  SizedBox(
                                    height: 58,
                                  ),
                                  CommonButton(
                                    onPress: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (innerContext) {
                                            _saveTelliot().then((value) {
                                              Navigator.pop(innerContext);
                                              setState(() {
                                                _saved = true;
                                              });
                                            });
                                            return AlertDialog(
                                              content: TelliotProgressIndicator(
                                                width: 20,
                                                stroke: 6,
                                                label: '텔리엇을 등록중입니다.',
                                              ),
                                            );
                                          });
                                      if (!widget.setting)
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  HomePage(
                                                    title: '약공급기로봇',
                                                  )),
                                        );
                                      return Navigator.pop(context);
                                    },
                                    label: '저장',
                                    labelStyle: TextStyle(
                                        color: TelliotColors.white,
                                        fontSize: 18,
                                        height: 21.09 / 18),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 36,
                                      vertical: 14,
                                    ),
                                    radius: 25,
                                    shadow: [
                                      BoxShadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 10,
                                        color: TelliotColors.black
                                            .withOpacity(0.20),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      height: MediaQuery.of(context)
                                          .padding
                                          .bottom),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
