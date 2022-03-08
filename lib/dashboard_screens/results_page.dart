import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text(" Results"),
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
        child: Text(" This is the Page where all the Results can be checked"),
      ),
    );
  }
}
