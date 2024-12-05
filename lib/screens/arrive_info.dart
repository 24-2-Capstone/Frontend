import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';

class ArriveInfo extends StatelessWidget {
  const ArriveInfo({super.key});

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
                        CircleAvatar(
                          backgroundColor: green_001,
                          radius: 50.w,
                          child: Icon(
                            Icons.history,
                            size: 40.h,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          '게속 대화하기',
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
                        CircleAvatar(
                          backgroundColor: green_001,
                          radius: 50.w,
                          child: Icon(
                            Icons.home_outlined,
                            size: 40.h,
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
