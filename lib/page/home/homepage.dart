import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_dispenser/component/common_app_bar.dart';
import 'package:med_dispenser/constant/telliot_colors.dart';

import 'package:med_dispenser/page/auth/init_bluetooth_page.dart';
import 'package:med_dispenser/page/setting/bluetooth_speaker/bluetooth_speaker_scan.dart';
import 'package:med_dispenser/page/setting/guardian_info_page.dart';
import 'package:med_dispenser/page/setting/life_reminder_page.dart';
import 'package:med_dispenser/page/setting/medication_time_page.dart';
import 'package:med_dispenser/page/setting/my_health_info_page.dart';

import '../setting/bluetooth_speaker/DiscoveryPage.dart';
import '../auth/serverpage.dart';
import '../manual_open_page.dart';
import '../put_medicine_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool flag = false;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: 'Robot',
          titleColor: TelliotColors.black,
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 220.0),
                    child: Image(
                      image: AssetImage('assets/robot.png'),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 120),
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MedicationTimePage(
                                              title: '약 먹는 시간 설정',
                                              flag: flag,
                                            )));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: TelliotColors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 23.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon/pill1.png',
                                          height: 46.8,
                                          width: 52.5,
                                        ),
                                        SizedBox(
                                          width: 13.5,
                                        ),
                                        Text(
                                          '약 먹는 시간 설정',
                                          style: TextStyle(
                                            letterSpacing: 0.52,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 27,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PutMedicinePage(title: '약 넣는 방법')));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: TelliotColors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 23.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon/pill2.png',
                                          height: 46.8,
                                          width: 52.5,
                                        ),
                                        SizedBox(
                                          width: 13.5,
                                        ),
                                        Text(
                                          '약 넣는 방법',
                                          style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 0.52,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 27),
                                        ),
                                      ],
                                    ),
                                  ))),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ManualOpenPage(title: '약 꺼내는 방법')));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: TelliotColors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 23.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon/pill3.png',
                                          height: 46.8,
                                          width: 52.5,
                                        ),
                                        SizedBox(
                                          width: 13.5,
                                        ),
                                        Text(
                                          '약 꺼내는 방법',
                                          style: TextStyle(
                                              letterSpacing: 0.52,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 27),
                                        ),
                                      ],
                                    ),
                                  ))),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width * 0.9,
                            color: TelliotColors.gray1,
                          ), // 구분선
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () async {
                                ServerPage.server = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DiscoveryPage();
                                    },
                                  ),
                                );
                                if (ServerPage.server != null) {
                                  print('Discovery -> selected ' +
                                      ServerPage.server.address);
                                } else {
                                  print('Discovery -> no device selected');
                                }
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: TelliotColors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 23.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon/phone_connect.png',
                                          height: 46.8,
                                          width: 52.5,
                                        ),
                                        SizedBox(
                                          width: 13.5,
                                        ),
                                        Text(
                                          '휴대폰 연결하여 듣기',
                                          style: TextStyle(
                                              letterSpacing: 0.52,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 27),
                                        ),
                                      ],
                                    ),
                                  ))),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LifeReminderPage(title: '생활 알림')));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: TelliotColors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 23.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon/life_time.png',
                                          height: 46.8,
                                          width: 52.5,
                                        ),
                                        SizedBox(
                                          width: 13.5,
                                        ),
                                        Text(
                                          '생활알림',
                                          style: TextStyle(
                                              letterSpacing: 0.52,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 27),
                                        ),
                                      ],
                                    ),
                                  ))),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            GuardianInfoPage(
                                              title: '보호자 정보 입력',
                                              flag: flag,
                                            )));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: TelliotColors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 23.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icon/guardian_info.png',
                                          height: 46.8,
                                          width: 52.5,
                                        ),
                                        SizedBox(
                                          width: 13.5,
                                        ),
                                        Text(
                                          '보호자 정보',
                                          style: TextStyle(
                                              letterSpacing: 0.52,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 27),
                                        ),
                                      ],
                                    ),
                                  ))),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MyHealthInfoPage(
                                                title: '나의 건강 정보')));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: TelliotColors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Text(
                                    '나의 건강 정보',
                                    style: TextStyle(
                                        letterSpacing: 0.52,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 27),
                                  )))),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width * 0.9,
                            color: TelliotColors.gray1,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '연결상태',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.31),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              '로봇',
                                              style: TextStyle(
                                                  color: TelliotColors.gray2,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.31),
                                            ),
                                            SizedBox(width: 4,),
                                            Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: TelliotColors.blue,
                                                  border: Border.all(
                                                      color: TelliotColors.skyBlue,
                                                      width: 2
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 14,),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              '리모컨V',
                                              style: TextStyle(
                                                  color: TelliotColors.gray2,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.31),
                                            ),
                                            SizedBox(width: 4,),
                                            Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: TelliotColors.blue,
                                                  border: Border.all(
                                                      color: TelliotColors.skyBlue,
                                                      width: 2
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 14,),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              '리모컨E',
                                              style: TextStyle(
                                                  color: TelliotColors.gray2,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.31),
                                            ),
                                            SizedBox(width: 4,),
                                            Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: TelliotColors.red,
                                                  border: Border.all(
                                                      color: TelliotColors.pink,
                                                      width: 2
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            InitBluetoothPage(
                                              title: '블루투스 연결',
                                              flag: flag,
                                            )));
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      '전체 연결',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          letterSpacing: 0.31),
                                    ),
                                  ))),  // 전체연결 버튼
                          SizedBox(height: 57,),
                          Image.asset('assets/logo_ioted.png',width: 146.5,height: 49,),
                          SizedBox(height: 20,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
