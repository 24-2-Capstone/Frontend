import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'package:foofi/main.dart';
import 'package:foofi/screens/map_painter.dart';
import 'package:nice_ripple/nice_ripple.dart';
import 'package:http/http.dart' as http;

/// ai 텍스트 말풍선 class
class ReceiverTextBubble extends StatelessWidget {
  ReceiverTextBubble({
    super.key,
    required this.text,
  });

  String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8, // 최대 너비 설정
          ),
          decoration: BoxDecoration(
            color: yellow_002,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: yellow_003.withOpacity(0.3),
              width: 3.0,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              text,
              style: TextStyle(
                color: brown_001,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ai 텍스트 말풍선 class
class ReceiverMapBubble extends StatelessWidget {
  ReceiverMapBubble({
    super.key,
    required this.text,
  });

  String text;

  @override
  Widget build(BuildContext context) {
    double pad = 20.w;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8, // 최대 너비 설정
          ),
          decoration: BoxDecoration(
            color: yellow_002,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: yellow_003.withOpacity(0.3),
              width: 3.0,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: brown_001,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
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
                                child: Container(
                                  color: yellow_001,
                                  child: CustomPaint(
                                    size: Size(200.w, 400.h), // 캔버스 크기
                                    painter: MapPainter(
                                      [
                                        const Offset(0, 0), // 좌표 1
                                      ],
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
                                  '/Users/huyn/Project/foofi/assets/images/fruit.png',
                                  width: 26.w,
                                ),
                              ),
                              Positioned(
                                top: 300.h + pad,
                                left: 155.w + pad,
                                child: Image.asset(
                                  '/Users/huyn/Project/foofi/assets/images/seafood.png',
                                  width: 26.w,
                                ),
                              ),
                              Positioned(
                                top: 310.h + pad,
                                left: 15.w + pad,
                                child: Image.asset(
                                  '/Users/huyn/Project/foofi/assets/images/vegetable.png',
                                  width: 38.w,
                                ),
                              ),
                              Positioned(
                                top: 149.h + pad,
                                left: 134.w + pad,
                                child: Image.asset(
                                  '/Users/huyn/Project/foofi/assets/images/nut.png',
                                  width: 50.w,
                                ),
                              ),
                              Positioned(
                                top: 166.h + pad,
                                left: 8.w + pad,
                                child: Image.asset(
                                  '/Users/huyn/Project/foofi/assets/images/meat.png',
                                  width: 34.w,
                                ),
                              ),
                              Positioned(
                                top: 26.h + pad,
                                left: 93.w + pad,
                                child: Image.asset(
                                  '/Users/huyn/Project/foofi/assets/images/seasoning.png',
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
                                  alignment: Alignment.center, // 반전 축의 기준점
                                  transform: Matrix4.identity()
                                    ..scale(-1.0, 1.0), // x축 반전
                                  child: const Icon(
                                    Icons.exit_to_app_outlined,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 250.h,
                                left: 185.w,
                                child: SizedBox(
                                  height: 45.h,
                                  width: 45.w,
                                  child: NiceRipple(
                                    radius: 20.0.w,
                                    rippleShape: BoxShape.circle,
                                    curve: Curves.bounceIn,
                                    duration: const Duration(milliseconds: 850),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
