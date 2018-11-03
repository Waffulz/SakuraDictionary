import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/dictionary_screen.dart';
import 'package:sakura_jisho/user_interface/vocabulary/add_vocabulary.dart';
import 'package:sakura_jisho/utils/routes.dart';



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

  _navigateToAddVocabulary() {
    Navigator.of(context).push(FadePageRoute(
        builder: (d) {
          return AddVocabulary();
        },
        settings: RouteSettings()));
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //TODO:
            },
          )
        ],
      ),
      drawer: _drawerBuilder(),
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

  Widget _drawerBuilder() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Agregar Vocabulario'),
            onTap: () => _navigateToAddVocabulary(),
          )
        ],
      ),
    );
  }
}




