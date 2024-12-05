import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'package:foofi/screens/home_screen.dart';

class ArriveInfo extends StatelessWidget {
  const ArriveInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: yellow_001,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '도착했습니다.\n사용해 주셔서 감사합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: brown_001,
                  fontSize: 32.h,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 48.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Material(
                            elevation: 3,
                            shape: const CircleBorder(), // 원형으로 만들기
                            child: Container(
                              decoration: BoxDecoration(
                                color: green_001,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(35.h),
                              child: Icon(
                                Icons.history,
                                color: brown_001,
                                size: 40.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          '계속하기',
                          style: TextStyle(
                            color: brown_001,
                            fontSize: 20.h,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50.w,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeScreen()), // 이동할 화면
                              (Route<dynamic> route) => false, // 제거 조건
                            );
                          },
                          child: Material(
                            elevation: 3,

                            shape: const CircleBorder(), // 원형으로 만들기
                            child: Container(
                              decoration: BoxDecoration(
                                color: green_001,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(35.h),
                              child: Icon(
                                Icons.home_outlined,
                                color: brown_001,
                                size: 40.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          '홈으로 돌아가기',
                          style: TextStyle(
                            color: brown_001,
                            fontSize: 20.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
