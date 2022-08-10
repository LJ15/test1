import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../component/common_app_bar.dart';
import 'init_bluetooth_connect_page.dart';

class InitBluetoothPage extends StatefulWidget {
  InitBluetoothPage({Key key, this.title, this.flag}) : super(key: key);

  final String title;
  final bool flag;

  @override
  _InitBluetoothPageState createState() => _InitBluetoothPageState();
}

class _InitBluetoothPageState extends State<InitBluetoothPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(),
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  '처음오셨군요.\n블루투스연결을\n진행합니다.',
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('로봇',style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                  )
                ]
              ),
              SizedBox(height: 40,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('v-pin',style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey,
                    )
                  ]
              ),
              SizedBox(height: 40,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('e-pin',style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey,
                    )
                  ]
              ),
              SizedBox(height: 40,),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                InitBluetoothConnectPage(widget.flag)));
                  },
                  child: Text('전체연결'),
                ),
              )
            ],
          ),
        ));
  }
}
