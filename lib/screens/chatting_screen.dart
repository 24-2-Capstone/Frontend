import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foofi/bubbles/reciever_bubble.dart';
import 'package:foofi/bubbles/sender_bubble.dart';
import 'package:foofi/buttons/choice_button.dart';
import 'package:foofi/buttons/more_detail_button.dart';
import 'package:foofi/buttons/speak_button.dart';
import 'package:foofi/color.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  List<String> choices = [
    "사진을 업로드할게",
    "맛있는 사과를 추천해줘",
    "화장실이 어디야?",
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height / 852;
    final double width = MediaQuery.of(context).size.width / 393;

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 581,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 채팅 영역
                    Column(
                      children: [
                        SenderBubble(
                          text: "무엇을 도와드릴까요?",
                        ),
                        RecieverBubble(
                          text: '맛있는 사과를 추천해줘',
                        ),
                        MoreDetailButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final double height =
                                    MediaQuery.of(context).size.height / 852;
                                final double width =
                                    MediaQuery.of(context).size.width / 393;

                                return Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                      vertical: 130.0 * height,
                                      horizontal: 24.0 * width),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: yellow_002,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 12.0,
                                          top: 12.0,
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.cancel,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 34 * width,
                                            ),
                                            const Text(
                                              '상품명',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Divider(
                                              thickness: 2,
                                              color: brown_001.withOpacity(0.7),
                                              indent: 50.0,
                                              endIndent: 50.0,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 28.0),
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 15,
                                                    mainAxisSpacing: 15,
                                                    childAspectRatio: 1 / 1.3,
                                                  ),
                                                  itemCount: 3,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return GestureDetector(
                                                        child: Column(
                                                      children: [
                                                        Container(),
                                                        const Text('ooo 사과')
                                                      ],
                                                    ));
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    // 선택 버튼
                    Wrap(
                      spacing: 8.0 * width,
                      alignment: WrapAlignment.center,
                      children: List.generate(choices.length, (index) {
                        return ChoiceButton(
                          onTap: () {},
                          text: choices[index],
                        );
                      }),
                    ),

                    // 말하기 버튼 안내 문구
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: Text(
                        '버튼을 눌러 말해보세요!',
                        style: TextStyle(
                          color: brown_001,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 156,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 말하기 버튼
                  Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: SpeakButton(
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const ChattingScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
