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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
  String _counterText = "0";
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

  Future<void> fetchAllGoods() async {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // 아래 콘텐츠
                Padding(
                  padding: const EdgeInsets.only(top: 56), // 기본 AppBar 높이 고려
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : selectedCategory == null
                          ? GridView.builder(
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
                                  price: item['goods_price'],
                                );
                              },
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 3 / 4,
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
                      title: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "전체",
                                style: TextStyle(
                                  color: brown_001,
                                  fontWeight: selectedCategory == "전체"
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == null)
                                Container(
                                  color: brown_001,
                                  height: 4.h,
                                  width: 30.w,
                                ),
                            ],
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            children: [
                              Text(
                                "채소",
                                style: TextStyle(
                                  color: brown_001,
                                  fontWeight: selectedCategory == "채소"
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              // if (selectedCategory == "채소")
                              //   Container(
                              //     color: brown_001,
                              //     height: 4.h,
                              //     width: 30.w,
                              //   ),
                            ],
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            children: [
                              Text(
                                "과일",
                                style: TextStyle(
                                  color: brown_001,
                                  fontWeight: selectedCategory == "과일"
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == "과일")
                                Container(
                                  color: brown_001,
                                  height: 4.h,
                                  width: 30.w,
                                ),
                            ],
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            children: [
                              Text(
                                "해산물",
                                style: TextStyle(
                                  color: brown_001,
                                  fontWeight: selectedCategory == "해산물"
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == "해산물")
                                Container(
                                  color: brown_001,
                                  height: 4.h,
                                  width: 40.w,
                                ),
                            ],
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            children: [
                              Text(
                                "정육",
                                style: TextStyle(
                                  color: brown_001,
                                  fontWeight: selectedCategory == "정육"
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == "정육")
                                Container(
                                  color: brown_001,
                                  height: 4.h,
                                  width: 30.w,
                                ),
                            ],
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            children: [
                              Text(
                                "잡곡",
                                style: TextStyle(
                                  color: brown_001,
                                  fontWeight: selectedCategory == "잡곡"
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == "잡곡")
                                Container(
                                  color: brown_001,
                                  height: 4.h,
                                  width: 30.w,
                                ),
                            ],
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            children: [
                              Text(
                                "양념",
                                style: TextStyle(
                                  color: brown_001,
                                  fontWeight: selectedCategory == "양념"
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              if (selectedCategory == "양념")
                                Container(
                                  color: brown_001,
                                  height: 4.h,
                                  width: 30.w,
                                ),
                            ],
                          ),
                        ],
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
                                    selectedCategory =
                                        isSelected ? category : null;
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
        onPressed: () {},
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
          size: 25.w,
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
        contentPadding: const EdgeInsets.all(20),
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
          _counterText = (value.length).toString();
          textContent = textController.text;
          //textProvider.saveName(value);
          if (value.isEmpty) {
            errorTextVal = 'min';
          } else {
            errorTextVal = '';
          }
        });
      },
      cursorErrorColor: Colors.red,
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
    final NumberFormat currencyFormat = NumberFormat('#,###');
    String formattedPrice = currencyFormat.format(price);

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
                color: Colors.brown,
                fontSize: 16.h,
                fontWeight: FontWeight.w500,
              ),
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
    );
  }
}
