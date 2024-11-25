import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foofi/color.dart';
import 'package:image_picker/image_picker.dart';

/// User 이미지 말풍선 class
class SenderImageBubble extends StatelessWidget {
  SenderImageBubble({
    super.key,
    required this.text,
    required this.image,
  });

  String text;
  XFile image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: gray_001,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: gray_003.withOpacity(0.3),
              width: 3.0,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 150, // 적절한 너비와 높이를 설정하세요.
                    height: 150,
                    decoration: BoxDecoration(
                      color: gray_001,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(
                          File(image.path),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: brown_001,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
