import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'package:loading_indicator/loading_indicator.dart';

/// ai 로딩중  말풍선 class
class ReceiverLoadingBubble extends StatelessWidget {
  const ReceiverLoadingBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8, // 최대 너비 설정
          ),
          width: 78.w,
          height: 48.h,
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [
                brown_001,
              ],
              strokeWidth: 2,
            ),
          ),
        ),
      ],
    );
  }
}
