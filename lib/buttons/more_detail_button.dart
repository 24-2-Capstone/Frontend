import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'package:foofi/function/show_goods_dialog.dart';
import 'package:intl/intl.dart';

/// 더보기 버튼 class
class MoreDetailButton extends StatefulWidget {
  MoreDetailButton({
    super.key,
    required this.onTap,
    required this.detailedList,
  });

  VoidCallback onTap;
  List<dynamic> detailedList;

  @override
  State<MoreDetailButton> createState() => _MoreDetailButtonState();
}

class _MoreDetailButtonState extends State<MoreDetailButton> {
  Color buttonTextColor = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 데이터 초기화 (null 값이면 0원 처리)
    for (var item in widget.detailedList) {
      item['discount_price'] ??= 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat = NumberFormat('#,###');

    return GestureDetector(
      onTap: widget.onTap,
      child: Material(
        color: green_001,
        borderRadius: BorderRadius.circular(20),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: InkWell(
          splashColor: green_003,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          //onTap: widget.onTap,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                      vertical: 100.0.h, horizontal: 24.0.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: yellow_002,
                      borderRadius: BorderRadius.circular(20.0.r),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 12.0.w,
                          top: 12.0.h,
                          child: IconButton(
                            padding: EdgeInsets.all(0.0.w),
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
                              '상품',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.0.h),
                              child: Divider(
                                thickness: 2.h,
                                color: brown_001.withOpacity(0.7),
                                indent: 50.0.w,
                                endIndent: 50.0.w,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 28.0.w),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15.w,
                                    mainAxisSpacing: 15.h,
                                    childAspectRatio: 1 / 1.6,
                                  ),
                                  itemCount: widget.detailedList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (widget.detailedList[index]
                                            ['discount_price'] ==
                                        null) {
                                      setState(() {
                                        widget.detailedList[index]
                                            ['discount_price'] = 0;
                                      });
                                    }
                                    double discountRate = (100 -
                                            widget.detailedList[index]
                                                        ['discount_price']
                                                    .toDouble() /
                                                widget.detailedList[index]
                                                    ['original_price'] *
                                                100)
                                        .toDouble();

                                    return GestureDetector(
                                      onTap: () {
                                        showGoodsDialog(
                                            context,
                                            widget.detailedList[index]
                                                ['product_name']);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.0.r),
                                            child: Image.network(
                                              widget.detailedList[index]
                                                  ['image_url'],
                                              height: 128.h,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              widget.detailedList[index]
                                                  ['product_name'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.h,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              overflow: TextOverflow
                                                  .ellipsis, // 텍스트가 길면 말줄임표 처리
                                              maxLines: 2, // 최대 2줄까지 표시
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (discountRate != 0 ||
                                                      discountRate != 100)
                                                    Text(
                                                      '${discountRate.toStringAsFixed(0)}% ',
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xFFDC0000),
                                                        fontSize: 15.w,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  Text(
                                                    '${currencyFormat.format(widget.detailedList[index]['discount_price'])}원 ',
                                                    style: TextStyle(
                                                        color: brown_001,
                                                        fontSize: 15.w,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${currencyFormat.format(widget.detailedList[index]['original_price'])}원 ',
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFF707070),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 13.w,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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
            );
          },
          onHighlightChanged: (isHightlighted) {
            setState(() {
              buttonTextColor = isHightlighted ? green_001 : Colors.black;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: green_003.withOpacity(0.3),
                width: 3.0.w,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Text(
                "더 보기",
                style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 10.h,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
