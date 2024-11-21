import 'package:flutter/material.dart';
import 'package:foofi/buttons/speak_button.dart';
import 'package:foofi/color.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow_001,
      appBar: AppBar(
        backgroundColor: yellow_001,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.home_outlined,
              size: 30,
              color: brown_001,
            ),
          ),
        ),
        title: Text(
          '대화하기',
          style: TextStyle(
            color: brown_001,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 520,
          ),
          Text(
            '버튼을 눌러 말해보세요!',
            style: TextStyle(
              color: brown_001,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9.0),
            child: SpeakButton(
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ChattingScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
