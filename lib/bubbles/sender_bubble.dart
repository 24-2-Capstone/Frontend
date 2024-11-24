import 'package:flutter/material.dart';
import 'package:foofi/color.dart';

/// 선택 버튼 class
class ReceiverBubble extends StatelessWidget {
  ReceiverBubble({
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
            child: Text(
              text,
              style: TextStyle(
                color: brown_001,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
