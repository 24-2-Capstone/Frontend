import 'package:flutter/material.dart';
import 'package:foofi/buttons/more_detail_button.dart';
import 'package:foofi/color.dart';

/// ai 텍스트 말풍선 class
class ReceiverImageBubble extends StatelessWidget {
  ReceiverImageBubble({
    super.key,
    required this.text,
    required this.name,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountPrice,
  });

  String text;
  String name;
  String imageUrl;
  int originalPrice;
  int discountPrice;

  @override
  Widget build(BuildContext context) {
    double discountRate = 100 - discountPrice / originalPrice * 100;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65, // 최대 너비 설정
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              children: [
                Image.network(imageUrl),
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
                          text: '$discountPrice원 ',
                          style: TextStyle(
                              color: brown_001,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: '$originalPrice원',
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
                      Text(
                        '멘트멘트멘트멘트',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: brown_001,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/flower.jpg',
                      width: 50,
                    ),
                    // const SizedBox(
                    //   width: 18.0,
                    // ),
                    Image.asset(
                      'assets/images/flower.jpg',
                      width: 50,
                    ),
                    // const SizedBox(
                    //   width: 25.0,
                    // ),
                    MoreDetailButton(
                      onTap: () {},
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
