import 'package:flutter/material.dart';

class NoteIt extends StatefulWidget {
  const NoteIt({Key? key}) : super(key: key);

  @override
  _NoteItState createState() => _NoteItState();
}

class _NoteItState extends State<NoteIt> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
      ),
    );
  }
}
