import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foofi/color.dart';
import 'package:foofi/main.dart';
import 'package:foofi/screens/arrive_info.dart';
import 'package:foofi/screens/arrive_infot_search.dart';
import 'package:foofi/screens/map_painter.dart';
import 'package:nice_ripple/nice_ripple.dart';

class MartMap extends StatelessWidget {
  const MartMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double pad = 20.w;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: 60.0.h, horizontal: 24.0.w),
      child: Container(
        decoration: BoxDecoration(
          color: yellow_002,
          borderRadius: BorderRadius.circular(20.0.r),
        ),
        child: AnimatedBuilder(
          animation: ModalRoute.of(context)!.animation!,
          builder: (context, child) {
            // 애니메이션에 따른 위치 이동 (아래에서 위로 올라옴)
            final animation = ModalRoute.of(context)!.animation!;
            final offset = Tween<Offset>(
              begin: const Offset(0.0, 1.0), // 아래에서 시작
              end: Offset.zero, // 위로 올라가면서 중앙에 위치
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ));

            return SlideTransition(
              position: offset,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Positioned(
                      right: 12.0.w,
                      top: 12.0.h,
                      child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 34.w,
                        ),
                        Text(
                          '매장 지도입니다.',
                          style: TextStyle(
                            color: brown_001,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.h,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                            child: GestureDetector(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 240.w,
                                          height: 440.h,
                                          alignment: const Alignment(0, 0),
                                          color: Colors.transparent,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            child: Container(
                                              color: yellow_001,
                                              child: CustomPaint(
                                                size: Size(
                                                    200.w, 400.h), // 캔버스 크기
                                                painter: MapPainter(
                                                  [
                                                    const Offset(0, 0) // 좌표 1,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 241.h + pad,
                                          left: 130.w + pad,
                                          child: Text(
                                            '계산대',
                                            style: TextStyle(
                                              color: brown_001,
                                              fontSize: 16.h,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 360.h + pad,
                                          left: 139.w + pad,
                                          child: Image.asset(
                                            'assets/images/fruit.png',
                                            width: 26.w,
                                          ),
                                        ),
                                        Positioned(
                                          top: 300.h + pad,
                                          left: 155.w + pad,
                                          child: Image.asset(
                                            'assets/images/seafood.png',
                                            width: 26.w,
                                          ),
                                        ),
                                        Positioned(
                                          top: 310.h + pad,
                                          left: 15.w + pad,
                                          child: Image.asset(
                                            'assets/images/vegetable.png',
                                            width: 38.w,
                                          ),
                                        ),
                                        Positioned(
                                          top: 149.h + pad,
                                          left: 134.w + pad,
                                          child: Image.asset(
                                            'assets/images/nut.png',
                                            width: 50.w,
                                          ),
                                        ),
                                        Positioned(
                                          top: 166.h + pad,
                                          left: 8.w + pad,
                                          child: Image.asset(
                                            'assets/images/meat.png',
                                            width: 34.w,
                                          ),
                                        ),
                                        Positioned(
                                          top: 26.h + pad,
                                          left: 93.w + pad,
                                          child: Image.asset(
                                            'assets/images/seasoning.png',
                                            width: 26.w,
                                          ),
                                        ),
                                        Positioned(
                                          top: 220.h + pad,
                                          left: 192.w + pad,
                                          child: const Icon(
                                            Icons.exit_to_app_outlined,
                                          ),
                                        ),
                                        Positioned(
                                          top: 270.h + pad,
                                          left: 192.w + pad,
                                          child: Transform(
                                            alignment:
                                                Alignment.center, // 반전 축의 기준점
                                            transform: Matrix4.identity()
                                              ..scale(-1.0, 1.0), // x축 반전
                                            child: const Icon(
                                              Icons.exit_to_app_outlined,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0.h, bottom: 10.0.h),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const ArriveInfo(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16.r), // 둥글게
                                ),
                              ),
                              elevation:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return 5.0; // 눌렀을 때 그림자 깊이
                                }
                                return 2.0; // 기본 그림자 깊이
                              }),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return green_003; // 눌렀을 때 색상
                                }
                                return green_001; // 기본 색상
                              }),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return green_001; // 눌렀을 때 색상
                                }
                                return Colors.black; // 기본 색상
                              }),
                            ),
                            child: Text(
                              '로봇과 함께 이동하기',
                              style: TextStyle(fontSize: 18.w),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
