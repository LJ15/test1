import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../component/common_app_bar.dart';

class MyHealthInfoDetailPage extends StatefulWidget {
  const MyHealthInfoDetailPage({Key key, this.title, this.date})
      : super(key: key);

  final String title;
  final String date;

  @override
  _MyHealthInfoDetailPageState createState() => _MyHealthInfoDetailPageState();
}

class _MyHealthInfoDetailPageState extends State<MyHealthInfoDetailPage> {
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();
  TextEditingController value3 = TextEditingController();
  TextEditingController value4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '날짜',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: Text(
                    widget.date,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(children: [
                  Text(
                    '혈당',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: value1,
                      )),
                ]),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      '혈압',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '최고',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: value2,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              '최저',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: value3,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      '간수치',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: value4,
                        ))
                  ],
                ),
                SizedBox(height: 30,),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                              '완료',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
