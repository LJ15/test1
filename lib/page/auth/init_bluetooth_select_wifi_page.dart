import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_dispenser/page/home/homepage.dart';
import 'package:med_dispenser/page/setting/guardian_info_page.dart';

import '../../component/common_app_bar.dart';

class InitBluetoothSelectWifiPage extends StatefulWidget {
  InitBluetoothSelectWifiPage(
      {Key key, this.title, this.flag})
      : super(key: key);

  final String title;
  final bool flag;

  @override
  _InitBluetoothSelectWifiPageState createState() =>
      _InitBluetoothSelectWifiPageState();
}

class _InitBluetoothSelectWifiPageState
    extends State<InitBluetoothSelectWifiPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  Text(
                    'WIFI 선택해주세요',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('취소')),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (widget.flag == true) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          GuardianInfoPage(
                                              title: '보호자 정보 입력',
                                              flag: widget.flag),
                                    ));
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (route) => false);
                              }
                            },
                            child: Text('완료'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
