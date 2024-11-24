import 'package:flutter/material.dart';
import 'package:foofi/color.dart';

/// 더보기 버튼 class
class MoreDetailButton extends StatefulWidget {
  MoreDetailButton({
    super.key,
    required this.onTap,
  });

  VoidCallback onTap;

  @override
  State<MoreDetailButton> createState() => _MoreDetailButtonState();
}

class _MoreDetailButtonState extends State<MoreDetailButton> {
  Color buttonTextColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Material(
        color: green_001,
        borderRadius: BorderRadius.circular(20),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: InkWell(
          splashColor: green_002,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          //onTap: widget.onTap,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final double height = MediaQuery.of(context).size.height / 852;
                final double width = MediaQuery.of(context).size.width / 393;

                return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                      vertical: 130.0 * height, horizontal: 24.0 * width),
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
                                padding: const EdgeInsets.symmetric(
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
                                      (BuildContext context, int index) {
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
          onHighlightChanged: (isHightlighted) {
            setState(() {
              buttonTextColor = isHightlighted ? green_001 : Colors.black;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: green_002.withOpacity(0.3),
                width: 3.0,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "더 보기",
                style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
