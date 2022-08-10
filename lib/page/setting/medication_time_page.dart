import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_dispenser/component/common_app_bar.dart';
import 'package:med_dispenser/constant/telliot_colors.dart';
import 'package:med_dispenser/page/home/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationTimePage extends StatefulWidget {
  const MedicationTimePage({Key key, this.title, this.flag}) : super(key: key);

  final String title;
  final bool flag;

  @override
  _MedicationTimePageState createState() => _MedicationTimePageState();
}

class _MedicationTimePageState extends State<MedicationTimePage> {
  bool _isChecked1 = true;
  bool _isChecked2 = true;
  bool _isChecked3 = true;
  String _selectedTime1 = '9:00';
  String _selectedTime2 = '12:00';
  String _selectedTime3 = '18:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '약 먹는 시간 설정',
        titleColor: TelliotColors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: _isChecked1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '아침',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          GestureDetector(
                              onTap: () {
                                Future<TimeOfDay> future = showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                future.then((timeOfDay) {
                                  setState(() {
                                    if (timeOfDay.hour >= 0 &&
                                        timeOfDay.hour <= 9) {
                                      _selectedTime1 =
                                          '0${timeOfDay.hour}:${timeOfDay.minute}';
                                    } else {
                                      _selectedTime1 =
                                          '${timeOfDay.hour}:${timeOfDay.minute}';
                                    }
                                  });
                                });
                              },
                              child: Text(
                                '$_selectedTime1',
                                style: TextStyle(
                                    fontSize: 50, letterSpacing: 1.04),
                              )),
                          Switch(
                              value: _isChecked1,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked1 = value;
                                });
                              }),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '아침',
                            style: TextStyle(
                                color: TelliotColors.gray3,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          Text(
                            '안먹어요',
                            style: TextStyle(
                                color: TelliotColors.gray3,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          Switch(
                              value: _isChecked1,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked1 = value;
                                });
                              }),
                        ],
                      )),
            SizedBox(
              height: 50,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: _isChecked2
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '점심',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          GestureDetector(
                              onTap: () {
                                Future<TimeOfDay> future = showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                future.then((timeOfDay) {
                                  setState(() {
                                    if (timeOfDay.hour >= 0 &&
                                        timeOfDay.hour <= 9) {
                                      _selectedTime2 =
                                          '0${timeOfDay.hour}:${timeOfDay.minute}';
                                    } else {
                                      _selectedTime2 =
                                          '${timeOfDay.hour}:${timeOfDay.minute}';
                                    }
                                  });
                                });
                              },
                              child: Text(
                                '$_selectedTime2',
                                style: TextStyle(
                                    fontSize: 50, letterSpacing: 1.04),
                              )),
                          Switch(
                              value: _isChecked2,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked2 = value;
                                });
                              }),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '점심',
                            style: TextStyle(
                                color: TelliotColors.gray3,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          Text(
                            '안먹어요',
                            style: TextStyle(
                                color: TelliotColors.gray3,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          Switch(
                              value: _isChecked2,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked2 = value;
                                });
                              }),
                        ],
                      )),
            SizedBox(
              height: 50,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: _isChecked3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '저녁',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          GestureDetector(
                              onTap: () {
                                Future<TimeOfDay> future = showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                future.then((timeOfDay) {
                                  setState(() {
                                    if (timeOfDay.hour >= 0 &&
                                        timeOfDay.hour <= 9) {
                                      _selectedTime3 =
                                          '0${timeOfDay.hour}:${timeOfDay.minute}';
                                    } else {
                                      _selectedTime3 =
                                          '${timeOfDay.hour}:${timeOfDay.minute}';
                                    }
                                  });
                                });
                              },
                              child: Text(
                                '$_selectedTime3',
                                style: TextStyle(
                                    fontSize: 50, letterSpacing: 1.04),
                              )),
                          Switch(
                              value: _isChecked3,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked3 = value;
                                });
                              }),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '저녁',
                            style: TextStyle(
                                color: TelliotColors.gray3,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          Text(
                            '안먹어요',
                            style: TextStyle(
                                color: TelliotColors.gray3,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          Switch(
                              value: _isChecked3,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked3 = value;
                                });
                              }),
                        ],
                      )),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(
                                  title: '약공급기로봇',
                                )),
                        (route) => false);
                  },
                  child: Text('완료')),
            )
          ]),
        ),
      ),
    );
  }
}
