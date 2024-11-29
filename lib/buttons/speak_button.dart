import 'package:flutter/material.dart';
import 'package:foofi/color.dart';
import 'package:loading_indicator/loading_indicator.dart';

/// 말하기 버튼 class
class SpeakButton extends StatelessWidget {
  SpeakButton({
    super.key,
    required this.onTap,
    required this.isRecording,
  });

  VoidCallback onTap;
  bool isRecording;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: isRecording ? brown_001 : green_001,
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
              border: isRecording
                  ? Border.all(style: BorderStyle.none)
                  : Border.all(
                      color: green_003.withOpacity(0.3),
                      width: 3.0,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: isRecording
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineScalePulseOut,
                          colors: [yellow_001],
                          strokeWidth: 5.0,
                        ),
                      ),
                    )
                  : Icon(
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
