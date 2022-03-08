import 'package:crypto_raffle/models/event_type.dart';
import 'package:crypto_raffle/models/live_event.dart';
import 'package:crypto_raffle/services/firebase_auth_services.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:crypto_raffle/widgets/ads_banner_widget.dart';
import 'package:crypto_raffle/widgets/crypto_events_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventsPage extends StatefulWidget {
  final EventType eventType;

  const EventsPage({Key? key, required this.eventType}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool showLoading = true;
  FirestoreServices fireStoreServices = FirestoreServices();
  FirebaseAuthServices authServices = FirebaseAuthServices();
  Stream? stream;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // checkIfTodaysLeftClick();
      // getTheLiveEvents();
    });
    super.initState();
  }

  getTheLiveEvents() {
    fireStoreServices
        .getLiveEvents(widget.eventType.eventCollectionName!)
        .then((val) {
      setState(() {
        stream = val;
        showLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getTheLiveEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.eventType.title!),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              const AdsBannerWidget(),
              SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                  "Join ${widget.eventType.title} ",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                )),
              ),
              StreamBuilder(
                  stream: stream,
                  builder: (context,AsyncSnapshot snapshots) {
                    if (snapshots.hasData) {
                      if (snapshots.data.docs.isEmpty) {
                        return const Center(
                            child: Text(
                          'No Live Events to Show',
                          style: TextStyle(color: Colors.red),
                        ));
                      } else {
                        return ListView.builder(
                            itemCount: snapshots.data.docs.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              LiveEvent liveEvent = LiveEvent(
                                title: snapshots.data.docs[index]["title"],
                                coin: snapshots.data.docs[index]["coin"],
                                entryClosed: snapshots.data.docs[index]
                                    ["entryClosed"],
                                entryFee: snapshots.data.docs[index]
                                    ["entryFee"],
                                winnerPrize: snapshots.data.docs[index]
                                    ["winnerPrize"],
                                img: snapshots.data.docs[index]["img"],
                                eventId: snapshots.data.docs[index]["eventId"],
                                participated: snapshots.data.docs[index]
                                    ["participated"],
                                total: snapshots.data.docs[index]["total"],
                                time: snapshots.data.docs[index]["time"],
                                status: snapshots.data.docs[index]["status"],
                                symbol: snapshots.data.docs[index]["symbol"],
                                instant: snapshots.data.docs[index]["instant"],
                                hash: snapshots.data.docs[index]["hash"]
                              );
                              return CryptoEventsCardWidget(
                                liveEvent: liveEvent,
                                index: index,
                                color: Tools.multiColors[index],
                                docId: snapshots.data.docs[index].id,
                                eventType: widget.eventType,
                              );
                            });
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    }
                  }),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Note- This is some suggesstion, which i am going to replace later on",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
