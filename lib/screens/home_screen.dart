import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foofi/screens/chatting_screen.dart';
import 'package:foofi/color.dart';
import 'package:foofi/screens/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 852;
    double width = MediaQuery.of(context).size.width / 393;

    // Swiper에 들어갈 위젯 리스트
    List<Widget> widgetList = [
      Container(
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.cyan[50],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 227, 250, 224),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: yellow_001,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: yellow_001,
            height: 503,
            width: 393,
            child: Swiper(
              viewportFraction: 0.95,
              scale: 0.9,
              autoplay: true,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ), // 좌우 간격 추가
                    child: widgetList[index]);
              },
              itemCount: widgetList.length,
              pagination: SwiperPagination(
                alignment: const Alignment(0, 1.0),
                builder: DotSwiperPaginationBuilder(
                    activeColor: brown_001,
                    color: const Color.fromARGB(255, 235, 235, 235),
                    size: 9.0,
                    space: 4.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              '무엇을 도와드릴까요?',
              style: TextStyle(
                color: brown_001,
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      elevation: 4,
                      color: green_001,
                      child: InkWell(
                        splashColor: green_001.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const SearchScreen(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 105,
                          height: 105,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.search,
                              color: brown_001,
                              size: 38,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        '상품\n검색하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: brown_001,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const ChattingScreen(),
                          ),
                        );
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(100),
                        elevation: 4,
                        color: green_001,
                        child: InkWell(
                          splashColor: green_001.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const ChattingScreen(),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 105,
                            height: 105,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.volume_up_rounded,
                                color: brown_001,
                                size: 38,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        '푸피와\n대화하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: brown_001,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
