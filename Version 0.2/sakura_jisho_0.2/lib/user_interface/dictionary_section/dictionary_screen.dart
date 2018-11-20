import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sakura_jisho/services/autentication.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/animated_fab.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/fab_with_actions.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/layout.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:sakura_jisho/user_interface/vocabulary/add_vocabulary.dart';
import 'package:sakura_jisho/user_interface/vocabulary/edit_vocabulary.dart';
import 'package:sakura_jisho/user_interface/vocabulary/search_page.dart';

//Import of sakura classes
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/models/word_model.dart';
import 'package:sakura_jisho/utils/font_styles.dart';
import 'package:sakura_jisho/utils/open_animation.dart';

//Allow async programming
import 'package:async/async.dart';
import 'dart:async';
import 'package:sakura_jisho/utils/routes.dart';

int sampleValue = 0;
bool _showKanji = false;
bool _showRomaji = false;
int wordId = 0;
Word editWord;
FirebaseDatabase database = FirebaseDatabase.instance;
Query query = database.reference().child('vocabulary').orderByChild('meaning');

class DictionaryPage extends StatefulWidget {
  final String filterBy;
  final String searchBy;

  DictionaryPage(this.filterBy, this.searchBy);

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

  _navigateToSearchPage() {
    Navigator.of(context).push(FadePageRoute(
        builder: (c) {
          return SearchPage();
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
                  onPressed: () => _navigateToSearchPage(),
                )
              ],
            ),
            body: TopPanel(widget.filterBy, widget.searchBy),
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

  _showSnackBar(String message) {
    final snackBar = SnackBar(
      content:
          Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0XFF27253D),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final FirebaseDatabase sakuraDatabase = FirebaseDatabase.instance;
  DatabaseReference sakuraDatabaseReference;

  _deleteWord(String key) {
    sakuraDatabaseReference =
        sakuraDatabase.reference().child("vocabulary").child(key);
    sakuraDatabaseReference.remove();
  }

  bool isPressed = true;

  Widget _bottomAppBarBuilder() {
    return BottomAppBar(
      color: Colors.black38,
      elevation: 0.0,
      child: Container(
        height: 50.0,
        child: Row(
          children: <Widget>[
            Expanded(
                child: isPressed
                    ? _changeLectureMethodButton()
                    : _lectureMethodRowBuilder()),
          ],
        ),
      ),
    );
  }

  void _iconToggle() {
    setState(() {
      if (!isPressed) {
        isPressed = true;
      } else {
        isPressed = false;
      }
    });
  }

  UserAuth _authApi;
  Widget _changeLectureMethodButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _editRow(),
        IconButton(
          tooltip: 'Cambia el método de escritura',
          icon: Icon(Icons.translate, color: Colors.white),
          onPressed: () {
            _iconToggle();
          },
        ),
      ],
    );
  }
  OpenableController openableController;
  Widget _dialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Se requiere confirmar la acción'),
            content: Text('¿Esta seguro que deasea eliminar ${editWord.meaning}?'),
            actions: <Widget>[
              FlatButton(
                  textColor: pink,
                  child: Text('Eliminar'),
                  onPressed: () {
                    _deleteWord(editWord.key);
                    Navigator.of(context).pop();
                    _showSnackBar('Se ha eliminado la palabra exitosamente');
                  }
              ),
              FlatButton(
                color: pink,
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
              ),
            ],
          );
        }
    );
  }

  Widget _editRow() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              if (editWord != null) {
                _dialog();
              } else {
                _showSnackBar('Debes de seleccionar un objeto para completar esta acción');
              }
            },
            tooltip: 'Elimina la palabra seleccionada',
            icon: Icon(Icons.delete, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              if (editWord != null) {
                _navigateToEditVocabulary();
              } else {
                _showSnackBar('Debes de seleccionar un objeto para completar esta acción');
              }
            },
            tooltip: 'Edita la palabra seleccionada',
            icon: Icon(
              Icons.mode_edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            tooltip: 'Añade una nueva palabra',
            onPressed: () => _navigateToAddVocabulary(),
            icon: Icon(Icons.playlist_add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  bool showKanji = false;
  bool showRomaji = false;

  Widget _lectureMethodRowBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          child: Container(
            height: double.infinity,
            child: Center(
              child: Text('Romaji',
                  style: showRomaji
                      ? CustomTextStyle.show(context)
                      : CustomTextStyle.hide(context)),
            ),
          ),
          onPressed: () {
            setState(() {
              if (!showRomaji) {
                showRomaji = true;
                _showRomaji = true;
              } else {
                showRomaji = false;
                _showRomaji = false;
              }
            });
          },
        ),
        FlatButton(
          child: Container(
            height: double.infinity,
            child: Center(
              child: Text('漢字',
                  style: showKanji
                      ? CustomTextStyle.show(context)
                      : CustomTextStyle.hide(context)),
            ),
          ),
          onPressed: () {
            setState(() {
              if (!showKanji) {
                showKanji = true;
                _showKanji = true;
              } else {
                showKanji = false;
                _showKanji = false;
              }
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            setState(() {});
            _iconToggle();
          },
        ),
      ],
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
  final String filterBy;
  final String searchBy;

  TopPanel(this.filterBy, this.searchBy);

  @override
  _TopPanelState createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel>
    with SingleTickerProviderStateMixin {
  OpenableController openableController;

  reOrderList() {
    query = database.reference().child('vocabulary').orderByChild('kanaWord');
    DrawList();
    setState(() {});
  }

  FilterList(String filterBy, String search) {
    if (search == "") {
      if (filterBy != 'Diccionario') {
        query = database
            .reference()
            .child('vocabulary')
            .orderByChild('wordType')
            .equalTo(filterBy);
      } else {
        query = database
            .reference()
            .child('vocabulary')
            .orderByChild('meaning');
      }
    } else {
      query = database
          .reference()
          .child('vocabulary')
          .orderByChild(filterBy)
          .startAt(search)
          .endAt('$search\uf8ff');
    }

    //DrawList();
    setState(() {});
  }

//      .startAt('cho')
//      .endAt("cho\uf8ff")
  @override
  void initState() {
    wordId = 0;
    openableController = new OpenableController(
        vsync: this, openDuration: const Duration(milliseconds: 250))
      ..addListener(() => setState(() {}));
    word = new Word();
    FilterList(widget.filterBy, widget.searchBy);
    DrawList();
    super.initState();
  }

  DrawList() {
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
    try {
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
                                _dynamicText(
                                  '${_showRomaji ? words[wordId].romajiWord + "      " : ""}${words[wordId].kanaWord + "      "}${_showKanji ? words[wordId].kanjiWord : ""}',
                                )
                              ]),
                              TableRow(children: [
                                _staticText('Tipo:'),
                                _dynamicText(words[wordId].wordType)
                              ]),
                              TableRow(children: [
                                _staticText('Caracteristicas:'),
                                _dynamicText(words[wordId].attributes == null
                                    ? '...'
                                    : words[wordId].attributes)
                              ]),
                              TableRow(children: [
                                _staticText('Descripción:'),
                                _dynamicText(words[wordId].description)
                              ]),
                              TableRow(children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (sampleValue < 2) {
                                        sampleValue = sampleValue + 1;
                                      } else {
                                        sampleValue = 0;
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.compare_arrows,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: _staticText('Ejemplo:'),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _dynamicText(
                                        '${sampleValue == 0 ? words[wordId].kanjiExample : sampleValue == 1 ? words[wordId].kanaExample : words[wordId].romajiExample}'),
                                    _dynamicText(
                                        '${words[wordId].spanishExample}')
                                  ],
                                )
                              ]),
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
                            '${_showRomaji
                                ? words[index].romajiWord + "      "
                                : ""}${words[index].kanaWord +
                                "      "}${_showKanji
                                ? words[index].kanjiWord
                                : ""}',
                            style: CustomTextStyle.kanaText(context),
                          ),
                          trailing: Text(
                            '${index + 1}',
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
    } catch (e) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              darkColor,
              darkLightColor
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
          )
        ),
        child: Center(
          child: widget.searchBy == '' ?
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(purple),
          ) :
              Text('No hay resultados', style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w300
              ),),
        ),
      );
    }
  }
}
