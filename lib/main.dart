import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foofi/color.dart';
import 'package:foofi/screens/arrive_info.dart';
import 'package:foofi/screens/trash_screen.dart';
import 'package:foofi/screens/home_screen.dart';
import 'package:foofi/screens/overlay1_screen.dart';
import 'package:foofi/screens/search_screen.dart';
import 'package:foofi/screens/test_another.dart';
import 'package:foofi/screens/chatting_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

String ai_url = "https://youngchannel.co.kr:1004";
String back_url = "http://52.79.100.176";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FooFi',
        theme: ThemeData(
          fontFamily: 'IBM Plex Sans KR',
          scaffoldBackgroundColor: yellow_001,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
