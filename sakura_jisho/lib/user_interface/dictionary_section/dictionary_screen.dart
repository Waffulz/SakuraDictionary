import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/animated_fab.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:sakura_jisho/user_interface/vocabulary/edit_vocabulary.dart';

//Import of sakura classes
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/models/word_model.dart';
import 'package:sakura_jisho/utils/font_styles.dart';
import 'package:sakura_jisho/utils/open_animation.dart';

//Allow async programming
import 'dart:async';
import 'package:sakura_jisho/utils/routes.dart';

int wordId = 0;

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  _navigateToFilterSections() {
    Navigator.of(context).pop(FadePageRoute(
        builder: (c) {
          return FilterSection();
        },
        settings: RouteSettings()));
  }

  _navigateToEditVocabulary() {
    Navigator.of(context).push(FadePageRoute(
        builder: (d) {
          return EditVocabulary();
        },
        settings: RouteSettings()));
  }

  //double height = MediaQuery.of(context).size.height;
  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(Icons.search);
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
                      'images/sakura_temple_img.jpg',
                    ),
                    fit: BoxFit.cover)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorLeft,
                colorRight,
              ],
            ),
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
                  icon: icon,
                  color: Colors.white,
                  onPressed: () => _navigateToEditVocabulary(),
                )
              ],
            ),
            body: TopPanel(),
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.8,
            left: MediaQuery.of(context).size.width * 0.65,
            child: OptionsFab()),
      ],
    );
  }
}

class VocabularyList extends StatefulWidget {
  final Function onListTap;

  VocabularyList({
    this.onListTap,
  });

  @override
  _VocabularyListState createState() => _VocabularyListState();
}

class _VocabularyListState extends State<VocabularyList> {
  List<Word> _words = [];

  @override
  void initState() {
    super.initState();
    //_loadWords();
  }

//  _loadWords() async {
//    String fileData =
//        await DefaultAssetBundle.of(context).loadString('assets/database.json');
//    setState(() {
//      //_words = WordApi.allWordsFromJson(fileData);
//    });
//  }

  Widget _buildWordsItem(BuildContext context, int index) {
    //Word word = _words[index];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onListTap,
        child: ListTile(
          title: Text('' //word.meaning,
              //style: CustomTextStyle.h2Text(context),
              ),
          subtitle: Text('' //word.kanaWord,
              //style: CustomTextStyle.kanaText(context),
              ),
          trailing: Text('' //word.wordType,
              //style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
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
    //_loadWords();
    return Future<Null>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            darkColor,
            darkLightColor,
          ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
          child: _buildWordsList()),
    );
  }
}

class TopPanel extends StatefulWidget {
  @override
  _TopPanelState createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel>
    with SingleTickerProviderStateMixin {
  OpenableController openableController;

  @override
  void initState() {
    super.initState();
    openableController = new OpenableController(
        vsync: this, openDuration: const Duration(milliseconds: 250))
      ..addListener(() => setState(() {}));
    word = new Word();
    databaseReference = database.reference().child("vocabulary");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  Widget _staticText(String text) {
    return Text(
      text,
      style: CustomTextStyle.staticTopPanelText(context),
    );
  }

  Widget _dynamicText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
      child: Text(
        text,
        style: CustomTextStyle.dynamicTopPanelText(context),
      ),
    );
  }

  DatabaseReference databaseReference;
  List<Word> words = List();
  Word word;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  void _onEntryAdded(Event event) {
    setState(() {
      words.add(Word.fromSnapshot(event.snapshot));
    });
  }

  void _onEntryChanged(Event event) {
    var oldEntry = words.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      words[words.indexOf(oldEntry)] = Word.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height * 0.3;
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: deviceHeight * (openableController.percentOpen),
          color: Colors.transparent,
          child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(words[wordId].meaning,
                          style: CustomTextStyle.h2Text(context)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Table(
                          columnWidths: {0: IntrinsicColumnWidth()},
                          //defaultColumnWidth: IntrinsicColumnWidth(),
                          children: [
                            TableRow(children: [
                              _staticText('Traducción:'),
                              _dynamicText(words[wordId].kanaWord)
                            ]),
                            TableRow(children: [
                              _staticText('Tipo:'),
                              _dynamicText(words[wordId].wordType)
                            ]),
                            TableRow(children: [
                              _staticText('Descripción:'),
                              _dynamicText(words[wordId].description)
                            ]),
                            TableRow(children: [
                              InkWell(
                                onTap: openableController.isOpen()
                                    ? openableController.close
                                    : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.edit,
                                      size: 15.0,
                                      color: Colors.white70,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: _staticText('Ejemplo:'),
                                    )
                                  ],
                                ),
                              ),
                              _dynamicText('${words[wordId].kanjiExample}\n'
                                  '${words[wordId].spanishExample}')
                            ]),
                            TableRow(children: [
                              _staticText('Caracteristicas:'),
                              _dynamicText(words[wordId].attributes == null
                                  ? '...'
                                  : words[wordId].attributes)
                            ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [blueDark, blueLight],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)),
            child: FirebaseAnimatedList(
                query: databaseReference,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return ListTile(
                    onTap: () {
                      wordId = index;
                      setState(() {});
                      openableController.open();
                    },
                    title: Text(
                      words[index].meaning,
                      style: CustomTextStyle.titleListTile(context),
                    ),
                    subtitle: Text(
                      words[index].kanaWord,
                      style: CustomTextStyle.kanaText(context),
                    ),
                    trailing: Text(
                      words[index].wordType,
                      style: CustomTextStyle.traillingListTile(context),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
