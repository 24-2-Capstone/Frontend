import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key});

  @override
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 한 바퀴 도는 시간
    )..repeat(); // 애니메이션 반복
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 회전하는 외곽 원
          RotationTransition(
            turns: _controller,
            child: CustomPaint(
              size: Size(100.w, 100.h), // 원 크기
              painter: RingPainter(),
            ),
          ),
          // 가운데 고정된 'M' 텍스트
          Image.asset(
            'assets/images/foofi_logo.png',
            width: 45.w,
          ),
        ],
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 15.w // 원의 두께
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        colors: [green_002, green_003, green_003, orange_001, orange_001],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeCap = StrokeCap.round; // 선 끝을 둥글게 설정

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, 0, 3.14 * 1.7, false, paint); // 3/4 원호 그리기
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
