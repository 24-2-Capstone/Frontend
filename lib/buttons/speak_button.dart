import 'package:flutter/material.dart';
import 'package:foofi/color.dart';

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
          onTap: () {},
          child: SizedBox(
            height: 90,
            width: 90,
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
