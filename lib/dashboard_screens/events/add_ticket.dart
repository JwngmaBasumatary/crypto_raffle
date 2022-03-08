import 'package:crypto_raffle/dashboard_screens/events/final_payment_page.dart';
import 'package:crypto_raffle/models/event_type.dart';
import 'package:crypto_raffle/models/live_event.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/constants.dart';
import 'package:crypto_raffle/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

//sdhgfhdsgfgsdhgf
class AddTicket extends StatefulWidget {
  const AddTicket({Key? key, required this.liveEvent, required this.eventType}) : super(key: key);
  final LiveEvent liveEvent;
  final EventType eventType;

  @override
  _AddTicketState createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  FirestoreServices firebaseServices = FirestoreServices();
  List<int> rowOne = [
    1,
    2,
    3,
  ];
  List<int> rowTwo = [
    4,
    5,
    6,
  ];
  List<int> rowThree = [
    7,
    8,
    9,
  ];
  List<int> selectedRandom = [];

  generateQuickPickNumber() {
    selectedRandom.clear();
    List<int> list = List<int>.generate(4, (int index) => 2 * index);
    Tools.showToasts(list.toList().toString());
    selectedRandom.addAll(list);
    setState(() {});
  }

  setSelectedNumber(int e) {
    if (selectedRandom.isEmpty) {
      selectedRandom.insert(0, e);
      setState(() {});
    } else if (selectedRandom.length == 1) {
      selectedRandom.insert(1, e);
      setState(() {});
    } else if (selectedRandom.length == 2) {
      selectedRandom.insert(2, e);
      setState(() {});
    } else if (selectedRandom.length == 3) {
      selectedRandom.insert(3, e);
      setState(() {});
    } else {
      selectedRandom.insert(4, e);
      selectedRandom.removeAt(0);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Ticket "),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                generateQuickPickNumber();
              },
              child: const Text(
                "Quick Pick",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowOne
                .map((e) => GestureDetector(
                      onTap: () {
                        setSelectedNumber(e);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 5.0, color: Colors.white),
                            image: const DecorationImage(
                                image: AssetImage(
                              Constants.pngegg,
                            ))),
                        child: Text(
                          "$e",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        height: 90,
                        width: 90,
                        alignment: Alignment.center,
                      ),
                    ))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowTwo
                .map((e) => GestureDetector(
                      onTap: () {
                        setSelectedNumber(e);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 5.0, color: Colors.white),
                            image: const DecorationImage(
                                image: AssetImage(
                              Constants.pngegg,
                            ))),
                        child: Text(
                          "$e",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        height: 90,
                        width: 90,
                        alignment: Alignment.center,
                      ),
                    ))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowThree
                .map((e) => GestureDetector(
                      onTap: () {
                        setSelectedNumber(e);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 5.0, color: Colors.white),
                            image: const DecorationImage(
                                image: AssetImage(
                              Constants.pngegg,
                            ))),
                        child: Text(
                          "$e",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        height: 90,
                        width: 90,
                        alignment: Alignment.center,
                      ),
                    ))
                .toList(),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: (){
                selectedRandom.removeRange(0, 4);
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 5.0, color: Colors.white),
                    image: const DecorationImage(
                        image: AssetImage(
                      Constants.pngegg,
                    ))),
                child: const Text(
                  "Clear",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                height: 90,
                width: 90,
                alignment: Alignment.center,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 5.0, color: Colors.white),
                  image: const DecorationImage(
                      image: AssetImage(
                    Constants.pngegg,
                  ))),
              child: const Text(
                "0",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              height: 90,
              width: 90,
              alignment: Alignment.center,
            ),
            GestureDetector(
              onTap: () {
                selectedRandom.removeLast();
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 5.0, color: Colors.white),
                    image: const DecorationImage(
                        image: AssetImage(
                      Constants.pngegg,
                    ))),
                child: Image.asset(
                  Constants.backSpaceIcon,
                  fit: BoxFit.contain,
                  height: 40,
                  width: 40,
                  color: Colors.white,
                ),
                height: 90,
                width: 90,
                alignment: Alignment.center,
              ),
            )
          ]),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: selectedRandom
                  .map((e) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 5.0, color: Colors.white),
                            image: const DecorationImage(
                                image: AssetImage(
                                  Constants.pngegg,
                                ))),
                        child: Text(
                          e.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                      ))
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: selectedRandom.isEmpty
                ? ["", "", "", ""]
                    .map((e) => const Text(
                          "_____",
                          style: TextStyle(
                              fontSize: 22,
                              letterSpacing: -3,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ))
                    .toList()
                : selectedRandom
                    .map((e) => const Text(
                          "_____",
                          style: TextStyle(
                              fontSize: 22,
                              letterSpacing: -3,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ))
                    .toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                ProgressDialog progressDialog =
                    ProgressDialog(context, isDismissible: false);
                if (selectedRandom.length < 3) {
                  Tools.showToasts("Please Select four digit Lucky Number");
                } else {
                  await progressDialog.show();
                  var selectedNumber = int.parse(
                      "${selectedRandom[0]}${selectedRandom[1]}${selectedRandom[2]}${selectedRandom[3]}");

                  await firebaseServices
                      .payWithCoinbase(
                          amount: widget.liveEvent.entryFee as int,
                          luckyNumber: selectedNumber,
                          eventId: widget.liveEvent.eventId!,
                          eventTitle: widget.liveEvent.title!)
                      .then((value) async {
                    await progressDialog.hide();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FinalPaymentPage(
                              coinbaseCommerce: value,
                            )));
                  });
                }
              },
              child: const Text("Pay")),
          ElevatedButton(
              onPressed: () {
                // Tools.showToasts(selectedRandom.toString());

                firebaseServices.generatePaymentLink(
                    10, 33, "", widget.liveEvent.eventId!);
              },
              child: const Text("Add Ticket"))
        ],
      ),
    );
  }
}
