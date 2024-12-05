import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'package:foofi/function/show_goods_dialog.dart';
import 'package:foofi/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdScreen extends StatefulWidget {
  const AdScreen({super.key});

  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  List<String> categories = ['채소', '과일', '해산물', '정육', '잡곡', '양념'];

  final NumberFormat currencyFormat = NumberFormat('#,###');
  List<Map<String, dynamic>> allResponse = []; // 전체 결과 저장
  Map<String, List<Map<String, dynamic>>> categoryResponses = {}; // 카테고리별 결과 저장
  String? selectedCategory; // 선택된 카테고리
  bool isLoading = true; // 로딩 상태
  bool isExpanded = false;

  // textfield
  final FocusNode _focusNode = FocusNode();
  final bool _isFocused = false;
  final String _counterText = "0";
  TextEditingController textController = TextEditingController();
  String textContent = "";
  String errorTextVal = "";

  @override
  void initState() {
    super.initState();
    fetchSaleGoods();
  }

  Future<void> fetchSaleGoods() async {
    final String baseUrl = "$back_url/goods/search/all";

    try {
      final Uri uri = Uri.parse(baseUrl);
      final http.Response response = await http.get(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // 바이트 기반으로 UTF-8 디코딩 처리
        final String decodedBody = utf8.decode(response.bodyBytes);
        print("디코딩된 응답 본문: $decodedBody");

        // 데이터가 성공적으로 응답되면 상태를 업데이트
        setState(() {
          final List<Map<String, dynamic>> allResults =
              List<Map<String, dynamic>>.from(
                  jsonDecode(decodedBody)['result']);

          // 조건에 맞는 데이터만 필터링
          allResponse = allResults
              .where((item) {
                final double goodsPrice =
                    item['goods_price']?.toDouble() ?? 0.0;
                final double salePrice = item['sale_price']?.toDouble() ?? 0.0;

                // 50% 이상 할인이 적용된 경우
                return (goodsPrice > 0 && salePrice > 0) &&
                    ((goodsPrice - salePrice) / goodsPrice) >= 0.3;
              })
              .toList()
              .reversed
              .toList();

          isLoading = false; // 로딩 완료
          print('필터링 완료');
          print('필터링된 데이터: $allResponse');
        });
      } else {
        print("요청 실패: ${response.reasonPhrase}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("오류 발생: $e");
      setState(() {
        isLoading = false;
      });
    }
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
        title: Text(
          '🎄특가 세일!🎄',
          style: TextStyle(
            color: brown_001,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/long_banner.jpeg",
                        fit: BoxFit.fitWidth),
                  ],
                ),
                // 아래 콘텐츠
                Padding(
                  padding: const EdgeInsets.only(top: 156), // 기본 AppBar 높이 고려
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: allResponse.length,
                          itemBuilder: (context, index) {
                            final item = allResponse[index];
                            return CategoryItem(
                              imagePath: item['imageURL'] ?? ' ',
                              name: item['goods_name'],
                              original_price: item['goods_price'],
                              sale_price: item['sale_price'],
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
    required this.original_price,
    required this.sale_price,
  });

  String imagePath;
  String name;
  int original_price;
  int sale_price;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat('#,###');
    String formattedPrice = currencyFormat.format(sale_price);
    double discountRate =
        (100 - sale_price.toDouble() / original_price * 100).toDouble();

    return GestureDetector(
      onTap: () {
        showGoodsDialog(context, name);
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0.r),
            child: Stack(
              children: [
                Image.network(
                  imagePath,
                  width: 151.w,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0.h),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.h,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis, // 텍스트가 길면 말줄임표 처리
              maxLines: 2, // 최대 2줄까지 표시
            ),
          ),
          if (discountRate != 0)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${discountRate.toStringAsFixed(0)}% ',
                      style: TextStyle(
                        color: const Color(0xFFDC0000),
                        fontSize: 15.w,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formattedPrice,
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$original_price원 ',
                  style: TextStyle(
                      color: const Color(0xFF707070),
                      decoration: TextDecoration.lineThrough,
                      fontSize: 13.w,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
