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

import 'package:http/http.dart' as http;
import 'package:nice_ripple/nice_ripple.dart';

/// 상품 아이디로 위치 검색
Future<Map<String, dynamic>> getGoodsLocationById(int id) async {
  final String baseUrl = "$back_url/goods/location/$id";
  print(baseUrl);

  try {
    // 파라미터 name으로 추가
    final Uri uri = Uri.parse(baseUrl);
    final http.Response response = await http.get(uri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // 바이트 기반으로 UTF-8 디코딩 처리
      final String decodedBody = utf8.decode(response.bodyBytes);
      print("디코딩된 응답 본문: $decodedBody");
      return jsonDecode(decodedBody)['result'];
    } else {
      return {
        "isSuccess": false,
        "code": response.statusCode,
        "message": "요청 실패: ${response.reasonPhrase}"
      };
    }
  } catch (e) {
    return {"isSuccess": false, "code": 500, "message": "오류 발생: $e"};
  }
}

Future<dynamic> showGoodsLocationDialog(
    BuildContext context, int id, String name) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return FutureBuilder<Map<String, dynamic>>(
        future: getGoodsLocationById(id), // 비동기 함수 호출
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Dialog(
              insetPadding:
                  EdgeInsets.symmetric(vertical: 60.0.h, horizontal: 24.0.w),
              child: Container(
                decoration: BoxDecoration(
                  color: yellow_002,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Dialog(
              insetPadding:
                  EdgeInsets.symmetric(vertical: 60.0.h, horizontal: 24.0.w),
              child: Container(
                decoration: BoxDecoration(
                  color: yellow_002,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(child: Text('오류발생 : {${snapshot.error}}')),
              ),
            );
          } else if (snapshot.hasData) {
            final response = snapshot.data!;
            double xLocation = (20 - response['y']).toDouble() * 10;
            double yLocation = (40 - response['x']).toDouble() * 10;

            double pad = 20.w;

            print('xLocation : $xLocation, yLocatino: $yLocation');
            return Dialog(
              insetPadding:
                  EdgeInsets.symmetric(vertical: 60.0.h, horizontal: 24.0.w),
              child: Container(
                decoration: BoxDecoration(
                  color: yellow_002,
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 12.0,
                      top: 12.0,
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
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 230.0.w, // 최대 너비
                          ),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Divider(
                            thickness: 2,
                            color: brown_001.withOpacity(0.7),
                            indent: 50.0,
                            endIndent: 50.0,
                          ),
                        ),
                        Text(
                          '${response['name']} 코너에 있어요!',
                          style: TextStyle(
                            color: brown_001,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.h,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 28.0),
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
                                              size:
                                                  Size(200.w, 400.h), // 캔버스 크기
                                              painter: MapPainter(
                                                [
                                                  Offset(
                                                      response['x'].toDouble(),
                                                      response['y']
                                                          .toDouble()), // 좌표 1
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
                                        Positioned(
                                          top: yLocation.h,
                                          left: xLocation.w,
                                          child: SizedBox(
                                            height: 45.h,
                                            width: 45.w,
                                            child: NiceRipple(
                                              radius: 20.0.w,
                                              rippleShape: BoxShape.circle,
                                              curve: Curves.bounceIn,
                                              duration: const Duration(
                                                  milliseconds: 850),
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
                          padding: EdgeInsets.only(top: 0.0.h, bottom: 15.0.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: green_001,
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                            child: TextButton(
                              child: Text(
                                '로봇과 함께 이동하기',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.w),
                              ),
                              onPressed: () {
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const ArriveInfo(),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else
            return Container();
        },
      );
    },
  );
}
