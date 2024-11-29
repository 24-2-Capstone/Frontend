import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foofi/bubbles/receiver_image_bubble.dart';
import 'package:foofi/color.dart';
import 'package:foofi/gradient_loading_indicator.dart';
import 'package:foofi/main.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> categories = ['채소', '과일', '해산물', '정육', '잡곡', '양념'];

  final List<bool> _expandedStates = List.generate(6, (index) => false);
  Map<String, List<Map<String, dynamic>>> categoryResponses = {}; // 결과 저장
  bool isLoading = true; // 로딩 상태

  Future<void> fetchAllCategories() async {
    try {
      Map<String, List<Map<String, dynamic>>> tempResponses = {};

      // 각 카테고리에 대해 비동기 요청을 병렬로 처리
      await Future.wait(
        categories.map((category) async {
          final response = await fetchGoodsByCategory(category);
          if (response['isSuccess'] == true && response['result'] != null) {
            tempResponses[category] =
                List<Map<String, dynamic>>.from(response['result']);
          } else {
            tempResponses[category] = []; // 실패 시 빈 리스트 저장
          }
        }),
      );

      setState(() {
        categoryResponses = tempResponses; // 결과 저장
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      print("오류 발생: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> fetchGoodsByCategory(String category) async {
    final String baseUrl = "$back_url/goods/search/category";

    try {
      final Uri uri =
          Uri.parse(baseUrl).replace(queryParameters: {'category': category});
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        // 바이트 기반으로 UTF-8 디코딩 처리
        final String decodedBody = utf8.decode(response.bodyBytes);
        //print("디코딩된 응답 본문: $decodedBody");
        return jsonDecode(decodedBody);
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

  @override
  void initState() {
    // TODO: implement initState
    fetchAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow_001,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.black.withOpacity(0.15),
        shape:
            Border(bottom: BorderSide(color: Colors.black.withOpacity(0.15))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final items = categoryResponses[category] ?? [];

                      return Theme(
                        data: ThemeData(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                categories[index],
                                style: TextStyle(
                                    color: brown_001,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              AnimatedRotation(
                                turns: _expandedStates[index]
                                    ? 0.25
                                    : 0.0, // 아이콘 회전 상태
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.brown,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedStates[index] = expanded; // 펼쳐짐 상태 업데이트
                            });
                          },
                          trailing: const Icon(
                            Icons.do_disturb,
                            color: Colors.transparent,
                          ),
                          expandedAlignment: Alignment.center,
                          children: items.isEmpty
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text('No items available'),
                                  ),
                                ]
                              : items
                                  .map((item) => ListTile(
                                        title: Text(
                                            item['goods_name'] ?? 'Unknown'),
                                        subtitle: Text(
                                            '${item['goods_price'] ?? 0}원'),
                                        leading: Image.network(
                                          item['imageURL'] ?? '',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              const Icon(Icons.broken_image),
                                        ),
                                      ))
                                  .toList(),
                          // SingleChildScrollView(
                          // child: FutureBuilder<Map<String, dynamic>>(
                          //   future: fetchGoodsByCategory(categories[index]),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState ==
                          //         ConnectionState.waiting) {
                          //       return const Center(
                          //           child: CircularProgressIndicator());
                          //     } else if (snapshot.hasError) {
                          //       return Center(
                          //           child:
                          //               Text('Error: ${snapshot.error}'));
                          //     } else if (!snapshot.hasData ||
                          //         snapshot.data!['result'] == null ||
                          //         (snapshot.data!['result'] as List)
                          //             .isEmpty) {
                          //       return const Center(
                          //           child: Text('No data available'));
                          //     } else {
                          //       final items =
                          //           snapshot.data!['result'] as List;

                          //       return Wrap(
                          //         spacing: 35,
                          //         runSpacing: 23,
                          //         children: List.generate(
                          //           items.length,
                          //           (index) => CategoryItem(
                          //             imagePath: items[index]
                          //                 ['imageURL'], // API 필드 이름에 맞게 수정
                          //             name: items[index]['goods_name'],
                          //             price: items[index]['goods_price'],
                          //           ),
                          //         ),
                          //       );
                          //     }
                          //   },
                          // ),

                          // ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
  });

  String imagePath;
  String name;
  int price;

  @override
  Widget build(BuildContext context) {
    // NumberFormat 을 사용해 가격 표시
    final NumberFormat currencyFormat = NumberFormat('#,###');
    String formattedPrice = currencyFormat.format(price);

    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 151,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            name,
            style: TextStyle(
              color: brown_001,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          "$formattedPrice원",
          style: TextStyle(
            color: brown_001,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
