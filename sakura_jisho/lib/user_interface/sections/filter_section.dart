import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/dictionary_screen.dart';
import 'package:sakura_jisho/utils/routes.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class FilterSection extends StatefulWidget {
  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  final String title;
  _FilterSectionState({
    this.title
  });


  _navigateToDictionary() {
    Navigator.of(context).push(
        FadePageRoute(
            builder: (c) {
              return DictionaryPage();
            },
            settings: RouteSettings()
        )
    );
  }

  Widget _sectionCardBuilder({String title}) {
    return GestureDetector(
      onTap: () => _navigateToDictionary(),
      child: Card(
        child: Container(
          width: double.infinity,
          height: 100.0,
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: null),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //TODO:
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _sectionCardBuilder(title: 'DICCIONARIO'),
          _sectionCardBuilder(title: 'SUSTANTIVOS'),
          _sectionCardBuilder(title: 'VERBOS'),
          _sectionCardBuilder(title: 'ADJETIVOS'),
          _sectionCardBuilder(title: 'CONTADORES'),
          _sectionCardBuilder(title: 'ADVERBIOS'),
        ],
      ),
    );
  }
}




