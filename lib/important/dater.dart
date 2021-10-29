import 'package:flutter/material.dart';

class LetsDate extends StatefulWidget {
  const LetsDate({Key? key}) : super(key: key);

  @override
  _LetsDateState createState() => _LetsDateState();
}

class _LetsDateState extends State<LetsDate> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lets Date"),
        ),
      ),
    );
  }
}
