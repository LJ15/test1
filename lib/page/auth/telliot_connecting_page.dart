import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../component/common_app_bar.dart';
import '../../component/widget/telliot_progress_indicator.dart';
import '../../constant/telliot_colors.dart';
import 'select_wifi_page.dart';
import '../../state/bluetooth_device_state.dart';
import 'package:provider/provider.dart';

class TelliotConnectingPage extends StatefulWidget {
  final DiscoveredDevice _targetDevice;
  final MaterialPageRoute route;
  final bool flag;

  TelliotConnectingPage(this._targetDevice, this.flag, {this.route});
  @override
  _TelliotConnectingPageState createState() => _TelliotConnectingPageState();
}

class _TelliotConnectingPageState extends State<TelliotConnectingPage> {
  final infoService = Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb');
  final settingService = Uuid.parse('696f7465-6474-656c-6c69-6f742d303031');
  final batteryService = Uuid.parse('0000180f-0000-1000-8000-00805f9b34fb');

  @override
  void initState() {
    super.initState();
    _connecting();
  }

  /// 텔리엇을 연결한다.
  /// 연결이 완료되면 네트워크 슬롯이 있는페이지로 이동하며
  /// 텔리엇 ID를 API를 통해 서버로 전달하는 과정을 구현해야 한다.
  /// 실패할 경우 다이얼로그를 띄우고 메인페이지로 이동한다.
  void _connecting() async {
    print("===================================>telliot_connecting_page의 _connecting()");
    try {
      context.read<BlueState>().connectTelliot(
          context: context,
          device: widget._targetDevice,
          afterConnectFunction: () => Navigator.pushReplacement(
            context,
            widget.route ??
                MaterialPageRoute(
                  builder: (context) => SelectWifiPage(
                    widget.flag,
                    deviceId: widget._targetDevice.id,
                    deviceName: widget._targetDevice.name,
                  ),
                ),
          ),
          disconnectFunction: () async {
            context.read<BlueState>().disconnectTelliot();

            Navigator.pop(context, false);
          });
    } catch (e, s) {
      print(e);
      print(s);

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        color: TelliotColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              !context.watch<BlueState>().connected ? '텔리엇에 연결 중이에요.' : '',
              style: TextStyle(
                  color: TelliotColors.primary, fontSize: 24, height: 31 / 24),
            ),
            SizedBox(
              height: 40,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 8,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/chat_cloud.png', scale: 2),
                      if (!context.watch<BlueState>().connected)
                        Container(
                          child: Center(
                            child: TelliotProgressIndicator(
                              label: '잠시만 기다려주세요.',
                              labelStyle: TextStyle(
                                  fontSize: 12,
                                  height: 14 / 12,
                                  color: TelliotColors.gray1),
                              width: 20,
                              height: 26,
                              stroke: 6,
                            ),
                          ),
                        ),
                      if (context.watch<BlueState>().connected)
                        Column(
                          children: [
                            Text('연결이 완료되었어요!'),
                            Image.asset(
                              'assets/check.png',
                              color: TelliotColors.primary,
                              scale: 3,
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                Image.asset(
                  'assets/loading_background.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
