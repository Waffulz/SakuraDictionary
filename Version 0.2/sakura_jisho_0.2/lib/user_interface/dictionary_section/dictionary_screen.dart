import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/animated_fab.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/fab_with_actions.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/layout.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:sakura_jisho/user_interface/vocabulary/add_vocabulary.dart';
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
Word editWord;

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
          return EditWord(
            editingWord: editWord,
          );
        },
        settings: RouteSettings()));
  }

  _navigateToAddVocabulary() {
    Navigator.of(context).push(FadePageRoute(
        builder: (d) {
          return AddVocabulary();
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
            key: scaffoldKey,
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
                  onPressed: () {},
                )
              ],
            ),
            body: TopPanel(),
//            floatingActionButtonLocation:
//                FloatingActionButtonLocation.endDocked,
//            floatingActionButton: _buildFab(context),
            bottomNavigationBar: _bottomAppBarBuilder(),
          ),
        ),
//        Positioned(
//            top: MediaQuery.of(context).size.height * 0.8,
//            left: MediaQuery.of(context).size.width * 0.65,
//            child: OptionsFab()),
      ],
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  _showSnackBar() {
    final snackBar = SnackBar(
      content:
          Text('Debes de seleccionar un objeto para completar esta acción'),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0XFF27253D),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final FirebaseDatabase sakuraDatabase = FirebaseDatabase.instance;
  DatabaseReference sakuraDatabaseReference;
  _deleteWord(String key) {
    sakuraDatabaseReference = sakuraDatabase
        .reference()
        .child("vocabulary")
        .child(key);
    sakuraDatabaseReference.remove();
  }

  Widget _bottomAppBarBuilder() {
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 50.0,
        child: Row(
          children: <Widget>[
            Expanded(child: Text('Opciones aqui')),
            IconButton(
              onPressed: () {
                if (editWord != null) {
                  _deleteWord(editWord.key);
                } else {
                  _showSnackBar();
                }
              },
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                if (editWord != null) {
                  _navigateToEditVocabulary();
                } else {
                  _showSnackBar();
                }
              },
              icon: Icon(Icons.mode_edit),
            ),
            IconButton(
              onPressed: () => _navigateToAddVocabulary(),
              icon: Icon(Icons.playlist_add),
            )
          ],
        ),
      ),
    );
  }

  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.playlist_add, Icons.mode_edit, Icons.delete];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.settings),
        elevation: 2.0,
        backgroundColor: pink,
      ),
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
  Query query;

  _filterBy() {
    query = database
        .reference()
        .child('vocabulary')
        .orderByChild('wordType')
        .equalTo('Verbo');
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    openableController = new OpenableController(
        vsync: this, openDuration: const Duration(milliseconds: 250))
      ..addListener(() => setState(() {}));
    word = new Word();
    query = database.reference().child('vocabulary').orderByChild('meaning');
    query.onChildAdded.listen(_onEntryAdded);
    query.onChildChanged.listen(_onEntryChanged);
    query.onChildRemoved.listen(_onEntryRemoved);
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

  void _onEntryRemoved(Event event) {
    setState(() {
      words.remove(Word.fromSnapshot(event.snapshot));
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
                                onTap: () => _filterBy(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.translate,
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
                query: query,
                itemBuilder: (context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        onTap: () {
                          editWord = words[index];
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
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}