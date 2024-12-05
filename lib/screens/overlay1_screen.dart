import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/color.dart';
import 'overlay2_screen.dart';

class OverlayScreen1 extends StatefulWidget {
  const OverlayScreen1({super.key});

  @override
  _OverlayScreen1State createState() => _OverlayScreen1State();
}

class _OverlayScreen1State extends State<OverlayScreen1> {
  bool _showGuide1 = true;
  bool _showGuide2 = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Black Overlay (40% opacity)
        if (_showGuide1)
          GestureDetector(
            onTap: () {
              setState(() {
                _showGuide1 = false; // Hide overlay when tapped
                _showGuide2 = true;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
            ),
          ),

        // Top-left icon and bubble
        if (_showGuide1) ...[
          // Icon
          Positioned(
            top: 60.h,
            left: 10.w,
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: const Color(0xFFFAF7E6),
              child: Icon(
                Icons.home_outlined,
                size: 30.w,
                color: brown_001,
              ),
            ),
          ),
          // Bubble
          Positioned(
            top: 120.h,
            left: 45.w,
            child: CustomPaint(
              painter: SpeechBubblePainter(
                color: const Color(0xFFFAF7E6),
                tailPosition: TailPosition.topLeft,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: const Text(
                  "메인 화면으로",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF532B18),
                  ),
                ),
              ),
            ),
          ),

          // Bottom-right icon and bubble
          Positioned(
            bottom: 63.h,
            right: 32.w,
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: yellow_001,
              child: Icon(Icons.upload, color: brown_001),
            ),
          ),
          Positioned(
            bottom: 120.h,
            right: 70.w,
            child: CustomPaint(
              painter: SpeechBubblePainter(
                color: const Color(0xFFFAF7E6),
                tailPosition: TailPosition.bottomRight,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: const Text(
                  "사진으로 상품을 찾아보세요!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF532B18),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (_showGuide1 == false && _showGuide2 == true)
          GestureDetector(
            onTap: () {
              setState(() {
                _showGuide2 = false;
              });
            },
            child: const OverlayScreen2(),
          ),
      ],
    );
  }
}

// Tail Position Enum
enum TailPosition { bottomLeft, bottomRight, topLeft, topRight }

// Speech Bubble Painter
class SpeechBubblePainter extends CustomPainter {
  final Color color;
  final TailPosition tailPosition;

  SpeechBubblePainter({required this.color, required this.tailPosition});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    // Main Speech Bubble Body
    Path bubblePath = Path();
    bubblePath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    ));

    // Tail
    Path tailPath = Path();
    switch (tailPosition) {
      case TailPosition.bottomLeft:
        tailPath.moveTo(20, size.height); // Adjusted to align with icon
        tailPath.lineTo(10, size.height + 10);
        tailPath.lineTo(30, size.height);
        tailPath.close();
        break;

      case TailPosition.bottomRight:
        tailPath.moveTo(size.width - 20, size.height);
        tailPath.lineTo(size.width - 10, size.height + 10);
        tailPath.lineTo(size.width - 30, size.height);
        tailPath.close();
        break;

      case TailPosition.topLeft:
        tailPath.moveTo(20, 0);
        tailPath.lineTo(10, -10);
        tailPath.lineTo(30, 0);
        tailPath.close();
        break;

      case TailPosition.topRight:
        tailPath.moveTo(size.width - 20, 0);
        tailPath.lineTo(size.width - 10, -10);
        tailPath.lineTo(size.width - 30, 0);
        tailPath.close();
        break;
    }

    // Draw Speech Bubble
    canvas.drawPath(bubblePath, paint);
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
