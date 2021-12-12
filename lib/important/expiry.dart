import'package:flutter/material.dart';

class WarrantyChecker extends StatefulWidget {
  const WarrantyChecker({Key? key}) : super(key: key);

  @override
  _WarrantyCheckerState createState() => _WarrantyCheckerState();
}

class _WarrantyCheckerState extends State<WarrantyChecker> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Warranty Checker"),
        ),
      ),
    );
  }
}
