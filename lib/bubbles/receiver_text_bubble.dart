import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'package:foofi/main.dart';
import 'package:foofi/screens/map_painter.dart';
import 'package:nice_ripple/nice_ripple.dart';
import 'package:http/http.dart' as http;

/// ai 텍스트 말풍선 class
class ReceiverTextBubble extends StatelessWidget {
  ReceiverTextBubble({
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
