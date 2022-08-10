import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_dispenser/constant/telliot_colors.dart';
import 'package:med_dispenser/page/home/homepage.dart';
import 'package:med_dispenser/page/setting/medication_time_page.dart';

import '../../component/common_app_bar.dart';

class GuardianInfoPage extends StatefulWidget {
  GuardianInfoPage({Key key, this.title, this.flag}) : super(key: key);

  final String title;
  final bool flag;

  @override
  _GuardianInfoPageState createState() => _GuardianInfoPageState();
}

class _GuardianInfoPageState extends State<GuardianInfoPage> {
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '보호자 정보 입력',
        titleColor: TelliotColors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text('전화번호1'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: value1,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Text('전화번호2'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: value2,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (widget.flag == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MedicationTimePage(
                                      title: '약 먹는 시간 설정', flag: widget.flag),
                            ));
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      }
                    },
                    child: Text('완료')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
