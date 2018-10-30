import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/topPanel.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';
import 'dart:math' as math;

//Import of sakura classes
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/models/word_model.dart';
import 'package:sakura_jisho/services/api.dart';
import 'package:sakura_jisho/utils/font_styles.dart';
import 'package:sakura_jisho/utils/open_animation.dart';

//Allow async programming
import 'dart:async';
import 'package:sakura_jisho/utils/routes.dart';

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
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                )
              ],
            ),
            body: TopPanel(),
          ),
        ),
        Positioned(top: MediaQuery.of(context).size.height * 0.8,
            left: MediaQuery.of(context).size.width * 0.65,
            child: OptionsFab()),
      ],
    );
  }
}

class OptionsFab extends StatefulWidget {
  @override
  _OptionsFabState createState() => _OptionsFabState();
}

class _OptionsFabState extends State<OptionsFab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  double expandedSize = 180.0;
  double hiddenSize = 20.0;

  //Functions used in Fuctions
  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = new ColorTween(begin: pink, end: purple)
        .animate(_animationController)
          ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  open() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  //Functions used in widgets
  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expandedSize,
      height: expandedSize,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _expandedBackgroudBuilder(),
              _optionIconBuilder(Icons.filter_list, 0.0),
              _optionIconBuilder(Icons.translate, - math.pi / 2),
              _fabBuilder(),
            ],
          );
        },
      ),
    );
  }

  //Widget builders
  Widget _fabBuilder() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();
    return FloatingActionButton(
      onPressed: () => _onFabTap(),
      child: Transform(
        alignment: Alignment.center,
        transform: new Matrix4.identity()..scale(1.0, scaleFactor),
        child: Icon(
          _animationController.value > 0.5 ? Icons.close : Icons.filter_list,
          color: Colors.white,
          size: 26.0,
        ),
      ),
      backgroundColor: _colorAnimation.value,
    );
  }

  Widget _expandedBackgroudBuilder() {
    double size =
        hiddenSize + (expandedSize - hiddenSize) * _animationController.value;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            pink,
            purple
          ],
          begin:Alignment.topRight,
          end: Alignment.bottomLeft
        )
      ),
    );
  }

  Widget _optionIconBuilder(IconData icon, double angle) {

    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 20.0 * (_animationController.value - 0.8) * 5;
    }

    return Material(
      color: Colors.transparent,
      child: Transform.rotate(
        angle: angle,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: IconButton(
              onPressed: null,
              icon: Transform.rotate(
                angle: -angle,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              iconSize: iconSize,
              alignment: Alignment.center,
              padding: EdgeInsets.all(0.0),
            ),
          ),
        ),
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
        onTap: widget.onListTap,
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
                      Text('Casa', style: CustomTextStyle.h2Text(context)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Table(
                          columnWidths: {0: IntrinsicColumnWidth()},
                          //defaultColumnWidth: IntrinsicColumnWidth(),
                          children: [
                            TableRow(children: [
                              _staticText('Traducción:'),
                              _dynamicText('Simona la mona')
                            ]),
                            TableRow(children: [
                              _staticText('Tipo:'),
                              _dynamicText('Simona la mona')
                            ]),
                            TableRow(children: [
                              _staticText('Descripción:'),
                              _dynamicText('Simona la mona')
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
                              _dynamicText('Simona la mona')
                            ]),
                            TableRow(children: [
                              _staticText('Nota:'),
                              _dynamicText('Simona la mona')
                            ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        VocabularyList(
          onListTap: () {
            openableController.open();
          },
        ),
      ],
    );
  }
}
