import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar; // Allow appBar as a parameter
  final Widget body;

  const BaseScaffold({Key? key, this.appBar, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // Use the passed appBar
      body: body,
    );
  }
}
