import 'package:flutter/material.dart';
import 'package:med_dispenser/constant/telliot_colors.dart';

import '../component/common_app_bar.dart';

class PutMedicinePage extends StatefulWidget {
  const PutMedicinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PutMedicinePageState createState() => _PutMedicinePageState();
}

class _PutMedicinePageState extends State<PutMedicinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '약 넣는 방법',
        titleColor: TelliotColors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('약 넣는 방법'),
            ],
          ),
        ),
      ),
    );
  }
}
