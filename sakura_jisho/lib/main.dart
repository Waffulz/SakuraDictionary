import 'package:flutter/material.dart';

void main() => runApp(new SakuraApp());

class SakuraApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sakura',
      // Hide the debug red label on top right of the app
      debugShowCheckedModeBanner: false,
      // Fonts are included in the "fonts" folder and declared in "pubspec.yaml"
     // theme: new ThemeData(fontFamily: 'LATO'),
      home: new DictionaryPage(),
    );
  }
}

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
