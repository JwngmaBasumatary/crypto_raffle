import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        title: const Text(" Tickets"),
        automaticallyImplyLeading: false,
        elevation: 0.7,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.calendar, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.bell, size: 26),
            onPressed: () {},
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),*/
      body: const Center(
        child: Text(" This is the Page where all the tickets can be checked"),
      ),
    );
  }
}
