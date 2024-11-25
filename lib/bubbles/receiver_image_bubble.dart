import 'package:flutter/material.dart';
import 'package:foofi/color.dart';

/// ai 텍스트 말풍선 class
class ReceiverImageBubble extends StatelessWidget {
  ReceiverImageBubble({
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
            child: Column(
              children: [
                Image.asset('assets/images/flower.jpg'),
                Container(
                  child: Text.rich(
                    TextSpan(
                      text: '이름이름이름',
                      style: TextStyle(
                          color: brown_001,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                          text: '가격가격가격',
                          style: TextStyle(
                              color: brown_001,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
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
