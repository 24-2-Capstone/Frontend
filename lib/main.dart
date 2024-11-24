import 'package:flutter/material.dart';
import 'package:foofi/color.dart';
import 'package:foofi/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

String ai_url = "https://youngchannel.co.kr:1004/";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FooFi',
      theme: ThemeData(
        fontFamily: 'IBM Plex Sans KR',
        scaffoldBackgroundColor: yellow_001,
      ),
      home: const HomeScreen(),
    );
  }
}
