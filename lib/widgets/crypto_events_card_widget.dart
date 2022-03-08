import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_raffle/dashboard_screens/events/event_details_page.dart';
import 'package:crypto_raffle/models/event_type.dart';
import 'package:crypto_raffle/models/live_event.dart';
import 'package:flutter/material.dart';

class CryptoEventsCardWidget extends StatefulWidget {
  const CryptoEventsCardWidget(
      {Key? key,
     required this.liveEvent,
     required this.color,
     required this.index,
     required this.docId,
     required this.eventType})
      : super(key: key);
  final LiveEvent liveEvent;
  final EventType eventType;
  final Color color;
  final int index;
  final String docId;

  @override
  State<CryptoEventsCardWidget> createState() => _CryptoEventsCardWidgetState();
}

class _CryptoEventsCardWidgetState extends State<CryptoEventsCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => EventDetailsPage(
                  liveEvent: widget.liveEvent,
                  eventType: widget.eventType,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.color,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.transparent,
                            border: Border.all(
                                color: Colors.transparent, width: 1)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.network(
                            widget.liveEvent.img!,
                            height: 20,
                            width: 20,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "3H:30m:30s",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        widget.liveEvent.title!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: RichText(
                          text: TextSpan(
                              text: "Entry Fee: ",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                                text: "${widget.liveEvent.entryFee} BCH ",
                                style: const TextStyle(color: Colors.white))
                          ])),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: RichText(
                          text: TextSpan(
                              text: "Winner Prize: ",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                                text:
                                    "${widget.liveEvent.winnerPrize}   ${widget.liveEvent.symbol}",
                                style: const TextStyle(color: Colors.white))
                          ])),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Slider(
                                activeColor: Colors.white,
                                inactiveColor: Colors.black,
                                divisions: widget.liveEvent.total,
                                label:
                                    "${widget.liveEvent.participated.toString()} Users Participated",
                                value: double.parse(
                                    widget.liveEvent.participated.toString()),
                                onChanged: (value) {},
                                max: widget.liveEvent.total.toDouble(),
                              ),
                              widget.liveEvent.status == "live"
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        widget.liveEvent.participated >=
                                                widget.liveEvent.total
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.green),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text("Match is Full",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              )
                                            : Text(
                                                "${widget.liveEvent.total - widget.liveEvent.participated} / ${widget.liveEvent.total}",
                                                style: const TextStyle(
                                                    color: Colors.black45),
                                              ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        widget.liveEvent.participated >=
                                                widget.liveEvent.total
                                            ? const Text("",
                                                style: TextStyle(
                                                    color: Colors.red))
                                            : const AutoSizeText(
                                                "spots left",
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 5),
                                              ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        /*    Expanded(
                              flex: 2,
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "${widget.liveEvent.participated}",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                    const Text(
                                      "/",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const Text(
                                      "100",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),*/
                      ],
                    ),
                    widget.liveEvent.participated < widget.liveEvent.total
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => EventDetailsPage(
                                        liveEvent: widget.liveEvent,
                                        eventType: widget.eventType,
                                      )));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blueGrey),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  widget.liveEvent.status == "live"
                                      ? "Join Now"
                                      : "show",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                )),
              ],
            )),
      ),
    );
  }
}
