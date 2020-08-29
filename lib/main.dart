import 'package:flutter/material.dart';
import 'package:practice_2/MainView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: MyMainView(),
    );
  }
}
