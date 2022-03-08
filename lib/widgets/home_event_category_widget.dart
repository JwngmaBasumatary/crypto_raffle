import 'package:crypto_raffle/dashboard_screens/events/events_page.dart';
import 'package:crypto_raffle/models/event_type.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:flutter/material.dart';

class HomeEventCategoryWidget extends StatefulWidget {
  const HomeEventCategoryWidget({Key key}) : super(key: key);

  @override
  State<HomeEventCategoryWidget> createState() =>
      _HomeEventCategoryWidgetState();
}

class _HomeEventCategoryWidgetState extends State<HomeEventCategoryWidget> {
  List<EventType> events = EventType.eventTypes;

  sendToPage(EventType eventType) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => EventsPage(
              eventType: eventType,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 490,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (_, index) {
            var eventType = events[index];
            return GestureDetector(
              onTap: () {
                sendToPage(eventType);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Tools.multiColors[index],
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        eventType.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "I will change this ui in a descriptively way later",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            );
          }),
    );
  }
}
