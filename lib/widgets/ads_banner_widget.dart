import 'dart:async';

import 'package:crypto_raffle/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdsBannerWidget extends StatefulWidget {
  const AdsBannerWidget({Key? key}) : super(key: key);

  @override
  State<AdsBannerWidget> createState() => _AdsBannerWidgetState();
}

class _AdsBannerWidgetState extends State<AdsBannerWidget> {
  final comingBooks = [
    "https://images.unsplash.com/photo-1576485290814-1c72aa4bbb8e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fGJhbm5lcnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1607082352121-fa243f3dde32?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    "https://media.istockphoto.com/photos/happy-4th-of-july-independence-day-picture-id1314372443?s=612x612",
    "https://images.unsplash.com/photo-1594325624708-75a0a6cf806f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1606462531411-bd77abcb7c57?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80"
  ];

  final _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
   autoScroll();
  }

  autoScroll() {
    Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) {
        if (_currentPage < 4) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      height: 120,
      child: Stack(
        children: [
          PageView(
            allowImplicitScrolling: true,
            controller: _pageController,
            children: comingBooks
                .map((e) => Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              e,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.black,
                                      Colors.black45,
                                      Colors.black12,
                                      Colors.transparent
                                    ])),
                          ),
                          onTap: () {
                            Tools.showToasts("Clicked");
                            /*Get.defaultDialog(
                              title: "Upcoming Book Clicked",
                              content: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(e),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green),
                                    child: const Text(
                                      'Close ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                  )
                                ],
                              ),
                            );*/
                          },
                        ),
                        const Positioned(
                            left: 20,
                            top: 20,
                            child: Text(
                              "Upcomig Book Title",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            )),
                        const Positioned(
                            left: 20,
                            top: 50,
                            child: Text(
                              "30+ Books Coming with various new \nstories and drama stories",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )),
                      ],
                    ))
                .toList(),
          ),
          Positioned(
              left: 20,
              bottom: 10,
              child: SmoothPageIndicator(
                  controller: _pageController,
                  count: comingBooks.length,
                  effect: const ExpandingDotsEffect(
                      expansionFactor: 4,
                      spacing: 4,
                      dotWidth: 8,
                      dotHeight: 8,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.indigo), // your preferred effect
                  onDotClicked: (index) {
                    _pageController.animateToPage(index,
                        duration: const Duration(microseconds: 1),
                        curve: Curves.easeInCubic);
                  }))
        ],
      ),
    );
  }
}
