import 'package:crypto_raffle/models/travel_model.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:flutter/material.dart';

class HomeCarouselWidget extends StatelessWidget {
  final _list = HomeCarouselModel.generateTravelBlogs();
  final _pageController = PageController(viewportFraction: 1);

  HomeCarouselWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        itemCount: _list.length,
        itemBuilder: (context, index) {
          var travel = _list[index];
          return GestureDetector(
            onTap: () {
              Tools.showToasts(
                  "$index has been Clicks, Action will be takken accordingly");
              /*           Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => TravelDetailPage(travelModel: travel,)));*/
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0.0, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      travel.url,
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 11,
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Colors.black38,
                          Colors.black12,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                      width: MediaQuery.of(context).size.width * 0.91,
                      height: 30,
                      alignment: Alignment.center,
                    )),
                Positioned(
                  bottom: 20,
                  child: Text(
                    "${travel.name} Try Now and Earn Big",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
