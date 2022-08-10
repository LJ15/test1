import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_dispenser/component/common_app_bar.dart';
import 'package:med_dispenser/constant/telliot_colors.dart';
import 'my_health_info_detail_page.dart';

class MyHealthInfoPage extends StatefulWidget {
  const MyHealthInfoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHealthInfoPageState createState() => _MyHealthInfoPageState();
}

class _MyHealthInfoPageState extends State<MyHealthInfoPage> {
  List<String> date = [];
  String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    date.add(toDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '나의 건강 정보',
        titleColor: TelliotColors.black,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: date.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: Key(date[index].toString()),
                  child: Card(
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MyHealthInfoDetailPage(
                                        title: '내 건강 정보',
                                        date: date[index].toString(),
                                      )));
                        },
                        title: Text(
                          date[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )),
                  ));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future<DateTime> selectedDate = showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2050),
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.dark(),
                  child: child,
                );
              });
          selectedDate.then((dateTime) {
            setState(() {
              String format = DateFormat('yyyy-MM-dd').format(dateTime);
              date.add(format);
            });
          });
        },
        child: Text(
          '추가',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
