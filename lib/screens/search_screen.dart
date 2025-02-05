import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'package:foofi/function/show_goods_dialog.dart';
import 'package:foofi/function/show_map_dialog.dart';
import 'package:foofi/main.dart';
import 'package:foofi/screens/custom_loading_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> categories = ['채소', '과일', '해산물', '정육', '잡곡', '양념'];
  List<String> expansionCategories = [
    "전체",
    "채소",
    "과일",
    "해산물",
    "정육",
    "잡곡",
    "양념"
  ];

  final NumberFormat currencyFormat = NumberFormat('#,###');
  List<Map<String, dynamic>> allResponse = []; // 전체 결과 저장
  List<Map<String, dynamic>> searchResponse = []; // 전체 결과 저장
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
    fetchAllGoods();
    fetchAllCategories();
  }

  Future<void> fetchAllCategories() async {
    try {
      Map<String, List<Map<String, dynamic>>> tempResponses = {};

      // 각 카테고리에 대해 비동기 요청을 병렬로 처리
      await Future.wait(
        categories.map(
          (category) async {
            final response = await fetchGoodsByCategory(category);
            if (response['isSuccess'] == true && response['result'] != null) {
              tempResponses[category] =
                  List<Map<String, dynamic>>.from(response['result']);
            } else {
              tempResponses[category] = []; // 실패 시 빈 리스트 저장
            }
          },
        ),
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

      print(uri);
      final http.Response response = await http.get(uri);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // 바이트 기반으로 UTF-8 디코딩 처리
        final String decodedBody = utf8.decode(response.bodyBytes);
        print("디코딩된 응답 본문: $decodedBody");
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

  // 검색어로 상품을 필터링하여 데이터 가져오기
  Future<void> fetchGoodsBySearch(String keyword) async {
    final String baseUrl = "$back_url/goods/search/keyword";
    setState(() {
      isLoading = true;
    });

    try {
      final Uri uri =
          Uri.parse(baseUrl).replace(queryParameters: {'keyword': keyword});
      final http.Response response = await http.get(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        setState(() {
          searchResponse = List<Map<String, dynamic>>.from(
              jsonDecode(decodedBody)['result']);
          print('update');
          isLoading = false; // 로딩 완료
        });
      } else {
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

  // 검색어에 맞춰 데이터를 필터링
  void _onSearchTextChanged(String keyword) {
    if (keyword.isNotEmpty) {
      // 필터링된 결과로 UI 업데이트
      fetchGoodsBySearch(keyword);
    } else {
      // 검색어가 비어 있으면 모든 데이터를 다시 로드
      fetchAllGoods();
    }
  }

  Future<void> fetchAllGoods() async {
    final String baseUrl = "$back_url/goods/search/all";

    setState(() {
      isLoading = true;
    });

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
          allResponse = List<Map<String, dynamic>>.from(
              jsonDecode(decodedBody)['result']);
          isLoading = false; // 로딩 완료
          print('완료');
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
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          SizedBox(
            width: 250.w,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0.h),
              child: searchField(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 아래 콘텐츠
          Padding(
            padding: const EdgeInsets.only(top: 56), // 기본 AppBar 높이 고려
            child: isLoading
                ? const Center(child: CustomLoadingIndicator())
                : textContent.isNotEmpty
                    ? GridView.builder(
                        // 검색한 상품들
                        padding: EdgeInsets.all(8.0.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0.w,
                          mainAxisSpacing: 8.0.h,
                          childAspectRatio: 3 / 4.0,
                        ),
                        itemCount: searchResponse.length,
                        itemBuilder: (context, index) {
                          final item = searchResponse[index];
                          return CategoryItem(
                            imagePath: item['imageURL'] ?? ' ',
                            name: item['goods_name'],
                            price: item['goods_price'],
                            sale_price: item['sale_price'],
                          );
                        },
                      )
                    : selectedCategory == null
                        ? GridView.builder(
                            // 전체 상품들
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0.w,
                              mainAxisSpacing: 8.0.h,
                              childAspectRatio: 3 / 4.2,
                            ),
                            itemCount: allResponse.length,
                            itemBuilder: (context, index) {
                              final item = allResponse[index];
                              return CategoryItem(
                                imagePath: item['imageURL'] ?? ' ',
                                name: item['goods_name'],
                                price: item['goods_price'],
                                sale_price: item['sale_price'],
                              );
                            },
                          )
                        : GridView.builder(
                            // 카테고리별 상품들
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0.w,
                              mainAxisSpacing: 8.0.h,
                              childAspectRatio: 3 / 4.2,
                            ),
                            itemCount:
                                categoryResponses[selectedCategory]?.length ??
                                    0,
                            itemBuilder: (context, index) {
                              final item =
                                  categoryResponses[selectedCategory]![index];
                              return CategoryItem(
                                imagePath: item['imageURL'],
                                name: item['goods_name'],
                                price: item['goods_price'],
                                sale_price: item['sale_price'],
                              );
                            },
                          ),
          ),

          // ExpansionTile
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              elevation: 4.0, // 그림자 효과 추가
              child: ExpansionTile(
                title: isExpanded
                    ? Text(
                        "전체",
                        style: TextStyle(
                          color: brown_001,
                          fontWeight: selectedCategory == "전체"
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 16,
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                        child: Wrap(
                          spacing: 29.w, // 각 Column 간 간격
                          children: [
                            for (var category in expansionCategories)
                              BuildCategory(
                                category: category,
                                selectedCategory: selectedCategory ?? "전체",
                              ),
                          ],
                        ),
                      ),
                shape: const Border.symmetric(
                    horizontal: BorderSide(
                  color: Color(0xFFBBA998),
                  width: 1,
                )),
                backgroundColor: yellow_001,
                iconColor: brown_001,
                collapsedBackgroundColor: yellow_001,
                collapsedIconColor: brown_001,
                textColor: brown_001,
                collapsedTextColor: brown_001,
                onExpansionChanged: (expanded) {
                  setState(() {
                    isExpanded = expanded;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: categories.map((category) {
                        return ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (isSelected) {
                            setState(() {
                              selectedCategory = isSelected ? category : null;
                              textContent = '';
                            });
                          },
                          showCheckmark: false,
                          selectedColor: brown_001,
                          backgroundColor: yellow_001,
                          surfaceTintColor: Colors.transparent,
                          labelStyle: TextStyle(
                            color: selectedCategory == category
                                ? yellow_001
                                : brown_001,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(
                              color: selectedCategory == category
                                  ? brown_001
                                  : const Color(0xFFCBBDAB),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'map',
        onPressed: () {
          _showCustomDialogWithAnimation(context);
        },
        backgroundColor: green_001,
        shape: CircleBorder(
          side: BorderSide(
            color: green_003.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.map_outlined,
          color: brown_001,
          size: 25.h,
        ),
      ),
    );
  }

  TextField searchField() {
    //final textProvider = Provider.of<InfoProvider>(context);

    return TextField(
      controller: textController,
      focusNode: _focusNode,
      keyboardType: TextInputType.text,
      style: TextStyle(
        color: brown_001,
        fontSize: 15.h,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            textController.clear();
            setState(() {
              textContent = '';
              FocusScope.of(context).requestFocus(_focusNode); // 키보드 내리기
            });
          },
          icon: Icon(
            Icons.cancel,
            color: gray_003,
          ),
        ),
        contentPadding: EdgeInsets.all(10.h),
        hintText: '검색어를 입력해주세요.',
        hintStyle: TextStyle(
          color: const Color(0xFFC3C2C2),
          fontSize: 15.w,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFFF3F1E4),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFF3F1E4),
            width: 0,
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        counterText: "",
      ),
      cursorColor: brown_001,
      cursorHeight: 15.h,
      cursorWidth: 1.5,
      autofocus: false,
      maxLines: 1, // 텍스트가 길어지면 자동으로 줄바꿈
      minLines: 1, // 최소 1줄
      scrollController: ScrollController(), // 스크롤을 가능하게 합니다
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: (value) {
        setState(() {
          textContent = textController.text;
          _onSearchTextChanged(textContent); // 값 변경 될 때마다 호출
        });
      },
    );
  }

  // 커스텀 애니메이션이 있는 Dialog Route 생성
  void _showCustomDialogWithAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // 배경을 눌러 다이얼로그 닫을 수 없도록 설정
      builder: (context) {
        return const MartMap(); // 애니메이션을 적용한 다이얼로그 위젯
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.sale_price,
  });

  String imagePath;
  String name;
  int price;
  int sale_price;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat('#,###');
    String formattedPrice = sale_price != 0
        ? currencyFormat.format(sale_price)
        : currencyFormat.format(price);

    double discountRate = sale_price == 0
        ? 0
        : (100 - sale_price.toDouble() / price * 100).toDouble();

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showGoodsDialog(context, name);
          },
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(top: 20.h, right: 20.w, left: 20.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0.r),
                      child: Image.network(
                        imagePath,
                        width: 151.w,
                      ),
                    ),
                  ),
                  if (discountRate >= 30)
                    Positioned(
                      right: -10.w,
                      top: -10.h,
                      child: Transform(
                        transform: Matrix4.rotationZ(0.4), // 회전 예시
                        child: Image.asset(
                          'assets/images/sale_bubble_1.png',
                          width: 80.w,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0.h),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "$formattedPrice 원",
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BuildCategory extends StatelessWidget {
  BuildCategory({
    super.key,
    required this.category,
    required this.selectedCategory,
  });

  String category;
  String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          category,
          style: TextStyle(
            color: brown_001,
            fontWeight: selectedCategory == category
                ? FontWeight.w600
                : FontWeight.w400,
            fontSize: 16,
          ),
        ),
        if (selectedCategory == category)
          Container(
            color: brown_001,
            height: 4.h,
            width: category == "해산물" ? 40.w : 30.w, // "해산물"의 너비를 다르게 설정
          ),
      ],
    );
  }
}
