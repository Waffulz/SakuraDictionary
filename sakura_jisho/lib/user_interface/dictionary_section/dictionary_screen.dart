import 'package:flutter/material.dart';

//Import of sakura classes
import 'package:sakura_jisho/color_pallete.dart';
import 'package:sakura_jisho/models/word_model.dart';
import 'package:sakura_jisho/services/api.dart';

//Allow async programming
import 'dart:async';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  List<Word> _words = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  _loadWords() async {
    String fileData =
        await DefaultAssetBundle.of(context).loadString('assets/database.json');
    setState(() {
      _words = WordApi.allWordsFromJson(fileData);
    });
  }

  Widget _buildWordsItem(BuildContext context, int index) {
    Word word = _words[index];
    return ListTile(
      title: Text(
        word.meaning
      ),
      subtitle: Text(
        word.kanaWord
      ),
      trailing: Text(
        word.wordType
      ),
    );
  }

  Widget _buildWordsList() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _words.length,
        itemBuilder: _buildWordsItem,
      ),
    );
  }

  Future<Null> refresh () {
    _loadWords();
    return Future<Null>.value();
  }

  //double height = MediaQuery.of(context).size.height;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          colorAccent,
          color,
        ]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                //TODO:
              }),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            'DICCIONARIO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                //TODO:
              },
            )
          ],
        ),
        body: _buildWordsList(),
      ),
    );
  }
}
