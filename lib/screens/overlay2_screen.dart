import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/buttons/speak_button.dart';
import 'package:foofi/color.dart';

class OverlayScreen2 extends StatefulWidget {
  const OverlayScreen2({super.key});

  @override
  _OverlayScreen2State createState() => _OverlayScreen2State();
}

class _OverlayScreen2State extends State<OverlayScreen2> {
  bool _showOverlay = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Black Overlay (40% opacity)
        if (_showOverlay)
          GestureDetector(
            onTap: () {
              setState(() {
                _showOverlay = false; // Hide overlay when tapped
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
            ),
          ),

        // Centered Text Bubble
        if (_showOverlay)
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "“맛있는 사과를 추천해줘!”\n“간장 위치가 어디야?”\n“계산대는 어디 있어?”",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF532B18),
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Bottom Speech Bubble and Mic Button
        if (_showOverlay)
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Speech Bubble
                CustomPaint(
                  painter: SpeechBubblePainter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: const Text(
                      "버튼을 눌러 말해보세요!",
                      style: TextStyle(color: Color(0xFF532B18), fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),

                // Mic Button
                SpeakButton(onTap: null, isRecording: false),
                SizedBox(height: 44.h), // Add spacing for safe area
              ],
            ),
          ),

        // Bottom-Right Upload Icon
      ],
    );
  }
}

// Speech Bubble Painter
class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFFFFFBF0);

    // Bubble Body
    Path bubblePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(10),
      ));

    // Tail
    Path tailPath = Path()
      ..moveTo(size.width / 2 - 10, size.height)
      ..lineTo(size.width / 2, size.height + 10)
      ..lineTo(size.width / 2 + 10, size.height)
      ..close();

    canvas.drawPath(bubblePath, paint);
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
