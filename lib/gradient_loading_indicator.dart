import 'package:flutter/material.dart';

class GradientLoadingIndicator extends StatefulWidget {
  final List<Color> colors; // 사용자 정의 색상 리스트

  const GradientLoadingIndicator({super.key, required this.colors});

  @override
  _GradientLoadingIndicatorState createState() =>
      _GradientLoadingIndicatorState();
}

class _GradientLoadingIndicatorState extends State<GradientLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // 애니메이션 반복
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _GradientArcPainter(
              rotation: _controller.value * 360,
              colors: widget.colors,
            ),
          );
        },
      ),
    );
  }
}

class _GradientArcPainter extends CustomPainter {
  final double rotation;
  final List<Color> colors; // 그라디언트 색상 리스트

  _GradientArcPainter({required this.rotation, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        stops: const [0, 0.5, 1],
        startAngle: 0.0,
        endAngle: 2 * 3.1415927,
      ).createShader(Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: size.width / 2,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // 회전 값 적용
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 3.1415927 / 180);
    canvas.translate(-center.dx, -center.dy);

    // 원호 그리기
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1415927 / 4, // 시작 각도
      3.1415927 / 2, // Sweep Angle
      false,
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 매 프레임 다시 그리기
  }
}
