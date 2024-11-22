import 'package:flutter/material.dart';
import 'package:foofi/color.dart';

/// 말하기 버튼 class
class SpeakButton extends StatelessWidget {
  SpeakButton({
    super.key,
    required this.onTap,
  });

  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: green_001,
        borderRadius: BorderRadius.circular(100),
        elevation: 4,
        child: InkWell(
          splashColor: green_001.withOpacity(0.5),
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: green_002.withOpacity(0.3),
                width: 3.0,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.mic_none_sharp,
                color: brown_001,
                size: 38,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
