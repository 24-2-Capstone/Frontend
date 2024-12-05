import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foofi/screens/ad_screen.dart';
import 'package:foofi/screens/chatting_screen.dart';
import 'package:foofi/color.dart';
import 'package:foofi/screens/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Swiper에 들어갈 위젯 리스트
    List<Widget> widgetList = [
      GestureDetector(
        onTap: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AdScreen(),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0.r),
          child: Image.asset('assets/images/sale.gif'),
        ),
      ),
      // ClipRRect(
      //   borderRadius: BorderRadius.circular(10.0.r),
      //   child: Image.asset(
      //     'assets/images/banner_2.png',
      //     height: 609.h,
      //   ),
      // ),
      ClipRRect(
        borderRadius: BorderRadius.circular(10.0.r),
        child: Image.asset('assets/images/banner_1.jpeg'),
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
            height: 503.h,
            width: 395.w,
            child: Swiper(
              viewportFraction: 1.0,
              scale: 1.0,
              autoplay: true,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 0.0), // 좌우 간격 추가
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
            padding: EdgeInsets.only(top: 24.0.h),
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
            padding: EdgeInsets.only(top: 28.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(100.r),
                      elevation: 4,
                      color: green_001,
                      child: InkWell(
                        splashColor: green_001.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100.r),
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
                      padding: EdgeInsets.only(top: 15.0.h),
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
                SizedBox(
                  width: 30.w,
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
                        borderRadius: BorderRadius.circular(100.r),
                        elevation: 4,
                        color: green_001,
                        child: InkWell(
                          splashColor: green_001.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100.r),
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
                            width: 105.w,
                            height: 105.h,
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
                      padding: EdgeInsets.only(top: 15.0.h),
                      child: Text(
                        '에이미와\n대화하기',
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
