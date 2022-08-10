import 'package:flutter/material.dart';
import 'package:med_dispenser/constant/telliot_colors.dart';

import '../component/common_app_bar.dart';

class ManualOpenPage extends StatefulWidget {
  const ManualOpenPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ManualOpenPageState createState() => _ManualOpenPageState();
}

class _ManualOpenPageState extends State<ManualOpenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '약 꺼내는 방법',
        titleColor: TelliotColors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('약 꺼내는 방법'),
            ],
          ),
        ),
      ),
    );
  }
}
