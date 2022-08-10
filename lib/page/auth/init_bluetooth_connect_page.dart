import 'package:flutter/material.dart';
import '../../component/common_app_bar.dart';
import '../../component/common_button.dart';
import '../../component/dialog/notify_dialog.dart';
import '../../constant/telliot_colors.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'telliot_list_page.dart';

class InitBluetoothConnectPage extends StatelessWidget {
  InitBluetoothConnectPage(this.flag);

  final bool flag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: StreamBuilder<BluetoothState>(
          stream: Stream.periodic(Duration(seconds: 1))
              .asyncMap((_) => FlutterBluetoothSerial.instance.state),
          builder: (context, snapshot) {
            return Container(
              color: TelliotColors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: ListView(
                children: [
                  Text(
                    '텔리엇의 한/영 버튼을\n길게 7초동안 눌러주세요.',
                    style: TextStyle(
                      fontSize: 24,
                      color: TelliotColors.primary,
                      height: 31 / 24,
                      fontFamily: 'Preahvihear',
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    '텔리엇을 검색하고 등록하기 위해서\n텔리엇을 페어링 모드로 만들어 주세요.\n페어링 모드로 진입하면 텔리엇의 LED가 점등해요.',
                    style: TextStyle(
                      height: 17.58 / 15,
                      fontSize: 15,
                      color: TelliotColors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(),
                  Image.asset('assets/physics.jpg'),
                  CommonButton(
                    label: '다음',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      height: 21 / 18,
                      color: TelliotColors.white,
                    ),
                    radius: 25,
                    shadow: [
                      BoxShadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Color(0xFFAAE0FF).withOpacity(0.25),
                      ),
                    ],
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    activeColor: TelliotColors.primary,
                    onPress: () async {
                      if (snapshot.data == BluetoothState.STATE_OFF) {
                        NotifyDialog.show(context,
                            //message: '블루투스가 꺼져 있습니다. 블루투스 사용을 허용합니다.');
                        message: '블루투스가 꺼져있습니다.\n블루투스를 켜고 시작해주세요.');
                        return;
                      }

                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TelliotListPage(flag)));
                      if (result != null) Navigator.pop(context, result);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 60,
                  )
                ],
              ),
            );
          }),
    );
  }
}
