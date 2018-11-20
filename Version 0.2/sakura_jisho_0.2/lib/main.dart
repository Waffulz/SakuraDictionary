
import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/dictionary_screen.dart';
import 'package:sakura_jisho/user_interface/logo/sakura_logo.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';
import 'package:sakura_jisho/user_interface/vocabulary/search_page.dart';


void main() async {
  runApp(SakuraApp());
}

class SakuraApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sakura',
      home: SearchPage(),
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

