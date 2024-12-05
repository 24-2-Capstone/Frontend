import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';

/// 선택 버튼 class
class ChoiceButton extends StatefulWidget {
  ChoiceButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  VoidCallback onTap;
  String text;

  @override
  State<ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  Color buttonTextColor = brown_001;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Material(
        color: gray_001,
        borderRadius: BorderRadius.circular(20),
        elevation: 4,
        child: InkWell(
          splashColor: gray_002.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onTap,
          onHighlightChanged: (isHightlighted) {
            setState(() {
              buttonTextColor = isHightlighted ? Colors.white : brown_001;
            });
          },
          child: Container(
            width: 150.w,
            height: 116.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: gray_003.withOpacity(0.3),
                width: 3.0,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 16.w,
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
