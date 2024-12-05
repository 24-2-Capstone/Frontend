import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/buttons/more_detail_button.dart';
import 'package:foofi/color.dart';
import 'package:intl/intl.dart';

/// ai 텍스트 말풍선 class
class ReceiverImageBubble extends StatelessWidget {
  ReceiverImageBubble({
    super.key,
    required this.text,
    required this.name,
    required this.imageUrl,
    required this.imageUrl1,
    required this.imageUrl2,
    required this.originalPrice,
    required this.discountPrice,
    required this.detailedList,
  });

  String text;
  String name;
  String imageUrl;
  String imageUrl1;
  String imageUrl2;
  int originalPrice;
  int discountPrice;
  List<dynamic> detailedList;

  @override
  Widget build(BuildContext context) {
    double discountRate = 100 - discountPrice / originalPrice * 100;
    NumberFormat currencyFormat = NumberFormat('#,###');

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65, // 최대 너비 설정
          ),
          decoration: BoxDecoration(
            color: yellow_002,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: yellow_003.withOpacity(0.3),
              width: 3.0,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0.r),
                  child: Image.network(
                    imageUrl,
                    height: 200.h,
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
                    borderRadius: BorderRadius.circular(10.0),
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
                        TextSpan(
                          text: '${discountRate.toStringAsFixed(0)}% ',
                          style: const TextStyle(
                              color: Color(0xFFDC0000),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: '${currencyFormat.format(discountPrice)}원 ',
                          style: TextStyle(
                              color: brown_001,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: '${currencyFormat.format(originalPrice)}원 ',
                          style: const TextStyle(
                              color: Color(0xFF707070),
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 220.w),
                        child: Text(
                          text,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: TextStyle(
                            color: brown_001,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0.r),
                      child: Image.network(
                        imageUrl1,
                        width: 60.w,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0.r),
                      child: Image.network(
                        imageUrl2,
                        width: 60.w,
                      ),
                    ),
                    MoreDetailButton(
                      onTap: () {},
                      detailedList: detailedList,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
