
import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';


void main() async {
  runApp(SakuraApp());
}

class SakuraApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sakura',
      home: FilterSection(),
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

