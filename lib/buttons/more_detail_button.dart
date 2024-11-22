import 'package:flutter/material.dart';
import 'package:foofi/color.dart';

/// 더보기 버튼 class
class MoreDetailButton extends StatefulWidget {
  MoreDetailButton({
    super.key,
    required this.onTap,
  });

  VoidCallback onTap;

  @override
  State<MoreDetailButton> createState() => _MoreDetailButtonState();
}

class _MoreDetailButtonState extends State<MoreDetailButton> {
  Color buttonTextColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Material(
        color: green_001,
        borderRadius: BorderRadius.circular(20),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: InkWell(
          splashColor: green_002,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onTap,
          onHighlightChanged: (isHightlighted) {
            setState(() {
              buttonTextColor = isHightlighted ? green_001 : Colors.black;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: green_002.withOpacity(0.3),
                width: 3.0,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "더 보기",
                style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 10,
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
