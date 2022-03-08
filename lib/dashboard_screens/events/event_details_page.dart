import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_raffle/dashboard_screens/events/add_ticket.dart';
import 'package:crypto_raffle/models/event_type.dart';
import 'package:crypto_raffle/models/live_event.dart';
import 'package:crypto_raffle/screens/faq_page.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:flutter/material.dart';

class EventDetailsPage extends StatefulWidget {
  final LiveEvent liveEvent;
  final EventType eventType;

  const EventDetailsPage({Key key, this.liveEvent, this.eventType})
      : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool showLoading = false;

  bool userParticipated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.liveEvent.symbol} Lucky Draw"),
        elevation: 1,
        actions: <Widget>[
          const SizedBox(
            width: 2,
          ),
          IconButton(
            icon: const Icon(
              Icons.share,
            ),
            onPressed: () async {
              /*      createSharableLink(
                widget.eventModel.title,
                widget.eventModel.gameId,
                widget.eventModel.prize,
                widget.eventModel.entryFee,
              );*/
            },
          ),
          IconButton(
              icon: const Icon(Icons.live_help),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FaqPage();
                }));
              }),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      floatingActionButton: showLoading
          ? const CircularProgressIndicator(
              backgroundColor: Colors.red,
            )
          : FloatingActionButton.extended(
              backgroundColor: userParticipated ? Colors.black : Colors.red,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => AddTicket(
                          liveEvent: widget.liveEvent,
                          eventType: widget.eventType,
                        )));
              },
              isExtended: true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              icon: const Icon(
                Icons.videogame_asset,
                color: Colors.white,
              ),
              label: Text(
                userParticipated ? "Joined" : "Join Now",
                style: const TextStyle(color: Colors.white),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          widget.liveEvent.img,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: Text(
                                " Match  #${widget.liveEvent.eventId}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            )),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: Text(
                                widget.liveEvent.status,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.white])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(children: <Widget>[
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.liveEvent.title,
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  child: Column(
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Entry Fee",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "${widget.liveEvent.entryFee} BCH",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  child: Column(
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: AutoSizeText(
                                          "Ref Reward ",
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          " 1000 ${widget.liveEvent.symbol}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  child: Column(
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Prize",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "${widget.liveEvent.winnerPrize} ${widget.liveEvent.symbol}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Slider(
                                          activeColor: Colors.red,
                                          inactiveColor: Colors.black,
                                          divisions: widget.liveEvent.total,
                                          label:
                                              "${widget.liveEvent.participated.toString()} Users Participated",
                                          value: widget.liveEvent.participated
                                              .toDouble(),
                                          onChanged: (value) {},
                                          max:
                                              widget.liveEvent.total.toDouble(),
                                        ),
                                        widget.liveEvent.status == "live"
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  widget.liveEvent
                                                              .participated >=
                                                          widget.liveEvent.total
                                                      ? Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  Colors.red),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                                "Match is Full",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        )
                                                      : Text(
                                                          "${widget.liveEvent.total - widget.liveEvent.participated}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  widget.liveEvent
                                                              .participated >=
                                                          widget.liveEvent.total
                                                      ? const Text("",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))
                                                      : const AutoSizeText(
                                                          "spots left",
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
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
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "${widget.liveEvent.participated}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        "/",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${widget.liveEvent.total} Spots",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Guess The Lucky Number ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ["", "", "", ""]
                        .map((e) => Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 5.0, color: Colors.white),
                                  image:  const DecorationImage(
                                      image: NetworkImage(
                                          Constants.roundBackGroupIcon))),
                              child: const Text(
                                "?",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              height: 60,
                              width: 60,
                              alignment: Alignment.center,
                            ))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Hash:- ",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                              text: widget.liveEvent.hash,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ])),
                      RichText(
                          text: const TextSpan(
                              text: "Key:- ",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                              text: "*********",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "( will be disclosed after the event )",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ])),
                    ],
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black45,
                          shape: const StadiumBorder()),
                      onPressed: () {},
                      child: const Text("Fair Draw")),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "We have already generated a random number for this event, "
                      "When we declare the result for this event, you can verify the authenticity of the result using the hash and the key provided",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Learn How To Play here',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _launchURL(
                                    "https://www.youtube.com/watch?v=hvjTjVBRy9o");
                              },
                              child: const Text('Learn here'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),*/
                  const SizedBox(
                    height: 100,
                  ),
                  /*    Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RaisedButton(
                                color: toVisible == "rules"
                                    ? Colors.indigo
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    toVisible = "rules";
                                  });
                                },
                                child: Text("RULES"))),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RaisedButton(
                                color: toVisible == "participants"
                                    ? Colors.indigo
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    toVisible = "participants";
                                  });
                                },
                                child: Text("PARTICIPANTS"))),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RaisedButton(
                                color: toVisible == "referrer"
                                    ? Colors.indigo
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    toVisible = "referrer";
                                  });
                                },
                                child: Text("REFERRER"))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: _buildWidgets(toVisible),
                  ),
                  SizedBox(
                    height: 100,
                  ),*/

                  /*      SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: _buildWidgets(),
                  ),
                  SizedBox(
                    height: 30,
                  )*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
