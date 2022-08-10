import 'dart:io';

import 'package:flutter/material.dart';
import 'package:med_dispenser/page/auth/init_bluetooth_page.dart';
import 'package:med_dispenser/page/home/homepage.dart';

//import 'package:telliot/state/chatbot_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '/constant/telliot_colors.dart';
import '/intro_page.dart';
import '/state/auth_state.dart';
import '/state/bluetooth_device_state.dart';
import 'package:catcher/catcher.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..maxConnectionsPerHost = 5; // Http 통신을 하기 위해 클라이언트 구현
    // 최대 연결 가능한 라이브 수 5개
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 파이어 베이스 쓰기 전에 꼭 쓰자!!
  HttpOverrides.global = MyHttpOverrides();

  final debugOption = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(['kooyh108@naver.com'])
  ]);

  final releaseOption = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(['kooyh108@naver.com']),
  ]);

  Catcher(
      rootWidget: MyApp(),
      debugConfig: debugOption, // debug 모드로 사용시,
      releaseConfig: releaseOption); // release 모드로 사용시,
  // runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    bool flag = true;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        //ChangeNotifierProvider(create: (_) => ChatbotState()),
        ChangeNotifierProvider(create: (_) => BlueState()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          // 앱 별 Localization delegate를 여기에 정의
          GlobalMaterialLocalizations.delegate,
          // Material Components 라이브러리를 위한 지역화된 문자열 제공
          GlobalWidgetsLocalizations.delegate,
          // 위젯 라이브러리가 텍스트를 나열하는 방향에 대한 기본 값 정의
          GlobalCupertinoLocalizations.delegate,
          //
        ],
        supportedLocales: [
          // 앱이 지원하는 Locale 정보
          Locale('ko', ''),
          Locale('en', ''),
        ],
        title: '약공급기',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
        ),
        home: IntroPage(
          flag: flag,
        ),
      ),
    );
  }
}
