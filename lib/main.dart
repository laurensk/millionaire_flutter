import 'package:flutter/material.dart';
import 'package:millionaire/menu.dart';

void main() => runApp(Millionaire());

class Millionaire extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Millionaire',
      theme: ThemeData(
      ),
      home: Menu(),
    );
  }
}