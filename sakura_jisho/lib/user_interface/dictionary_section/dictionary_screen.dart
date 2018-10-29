import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/topPanel.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';

//Import of sakura classes
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/models/word_model.dart';
import 'package:sakura_jisho/services/api.dart';
import 'package:sakura_jisho/utils/font_styles.dart';

//Allow async programming
import 'dart:async';

import 'package:sakura_jisho/utils/routes.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  OpenableController openableController;
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          //TODO:
        },
        child: ListTile(
          title: Text(
            word.meaning,
            style: CustomTextStyle.h2Text(context),
          ),
          subtitle: Text(
            word.kanaWord,
            style: CustomTextStyle.kanaText(context),
          ),
          trailing: Text(
            word.wordType,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
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

  Future<Null> refresh() {
    _loadWords();
    return Future<Null>.value();
  }

  _navigateToFilterSections() {
    Navigator.of(context).pop(FadePageRoute(
        builder: (c) {
          return FilterSection();
        },
        settings: RouteSettings()));
  }

  //double height = MediaQuery.of(context).size.height;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.41,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/sakura_temple_img.jpeg',
                ),
                fit: BoxFit.cover
              )
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              colorLeft,
              colorRight,
            ],),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => _navigateToFilterSections(),
              ),
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
                    openableController.close();
                  },
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                TopPanel(),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        darkColor,
                        darkLightColor,
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                      child: _buildWordsList()),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  //TODO:
                },
                backgroundColor: colorRight,
                child: Icon(Icons.send)),
          ),
        ),
      ],
    );
  }
}
