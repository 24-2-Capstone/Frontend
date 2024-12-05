import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'package:foofi/function/show_goods_location_dialog.dart';
import 'package:foofi/main.dart';
import 'package:foofi/screens/custom_loading_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// 이름으로 상품 검색
Future<Map<String, dynamic>> getRequestGoodsName(String name) async {
  final String baseUrl = "$back_url/goods/search/name";

  try {
    // 파라미터 name으로 추가
    final Uri uri =
        Uri.parse(baseUrl).replace(queryParameters: {'goods_name': name});
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

Future<dynamic> showGoodsDialog(BuildContext context, String name) {
  final NumberFormat currencyFormat = NumberFormat('#,###');

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<Map<String, dynamic>>(
        future: getRequestGoodsName(name), // 비동기 함수 호출
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Dialog(
              insetPadding:
                  EdgeInsets.symmetric(vertical: 80.0.h, horizontal: 24.0.w),
              child: Container(
                decoration: BoxDecoration(
                  color: yellow_002,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Center(
                  child: CustomLoadingIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Dialog(
              insetPadding:
                  EdgeInsets.symmetric(vertical: 80.0.h, horizontal: 24.0.w),
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
            print(response['sale_price']);

            double discountRate = response['sale_price'] == 0
                ? 0
                : (100 -
                        response['sale_price'].toDouble() /
                            response['goods_price'] *
                            100)
                    .toDouble();

            return Dialog(
              insetPadding:
                  EdgeInsets.symmetric(vertical: 80.0.h, horizontal: 24.0.w),
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
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Divider(
                            thickness: 2,
                            color: brown_001.withOpacity(0.7),
                            indent: 50.0,
                            endIndent: 50.0,
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
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(5.0.r),
                                      child: Image.network(
                                        response['imageURL'],
                                        height: 198.h,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 6.0),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: yellow_001,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text.rich(
                                        textAlign: TextAlign.center,
                                        TextSpan(
                                          text: '$name\n',
                                          style: TextStyle(
                                              color: brown_001,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                          children: <TextSpan>[
                                            if (discountRate != 0)
                                              TextSpan(
                                                text:
                                                    '${discountRate.toStringAsFixed(0)}% ',
                                                style: const TextStyle(
                                                    color: Color(0xFFDC0000),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            TextSpan(
                                              text: discountRate == 0
                                                  ? '${currencyFormat.format(response['goods_price'])}원 '
                                                  : '${currencyFormat.format(response['sale_price'])}원 ',
                                              style: TextStyle(
                                                  color: brown_001,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            if (discountRate != 0)
                                              TextSpan(
                                                text:
                                                    '${currencyFormat.format(response['goods_price'])}원 ',
                                                style: const TextStyle(
                                                    color: Color(0xFF707070),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        response['goods_description'],
                                        textAlign: TextAlign.left,
                                        softWrap: true, // 자동 줄바꿈을 허용
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
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
                              showGoodsLocationDialog(
                                context,
                                response['id'],
                                name,
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
                              '찾으러 가기',
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
          } else
            return Container();
        },
      );
    },
  );
}
