import 'package:flutter/material.dart';
import 'package:foofi/color.dart';

class MapPainter extends CustomPainter {
  final List<Offset> points; // 표시할 좌표 리스트

  MapPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDD1BD)
      ..style = PaintingStyle.fill;

    // 지도 배경 그리기
    final List<Rect> rects = [
      const Rect.fromLTWH(10, 0, 190, 90),
      const Rect.fromLTWH(20, 90, 180, 10),
      const Rect.fromLTWH(0, 120, 50, 100),
      const Rect.fromLTWH(0, 220, 60, 20),
      const Rect.fromLTWH(100, 120, 100, 50),
      const Rect.fromLTWH(110, 170, 90, 50),
      const Rect.fromLTWH(0, 250, 70, 150),
      const Rect.fromLTWH(130, 290, 70, 50),
      const Rect.fromLTWH(100, 350, 100, 50),
    ];

    for (var rect in rects) {
      canvas.drawRect(rect, paint);
    }

    // cashier 그리기
    final Paint newRectPaint = Paint()
      ..color = gray_003
      ..style = PaintingStyle.fill;

    const newRect = Rect.fromLTWH(180, 240, 20, 30); // 새로 추가할 직사각형
    canvas.drawRect(newRect, newRectPaint); // 새 직사각형 그리기
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
