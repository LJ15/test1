import 'package:flutter/material.dart';
import '../../component/common_app_bar.dart';
import '../../constant/telliot_colors.dart';
import '../home/homepage.dart';

class LifeReminderPage extends StatefulWidget {
  const LifeReminderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LifeReminderPageState createState() => _LifeReminderPageState();
}

class _LifeReminderPageState extends State<LifeReminderPage> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  String _selectedTime1 = '09:00';
  String _selectedTime2 = '09:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '생활 알림',
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
                            '아침인사',
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
                            '아침인사',
                            style: TextStyle(
                                color: TelliotColors.gray3,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          Text(
                            '안해요',
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
                            '체조하기',
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
                            '체조하기',
                            style: TextStyle(
                                color: TelliotColors.gray3,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.45),
                          ),
                          Text(
                            '안해요',
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
