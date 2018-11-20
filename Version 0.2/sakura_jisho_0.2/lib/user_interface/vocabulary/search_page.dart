import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/dictionary_screen.dart';
import 'package:sakura_jisho/user_interface/logo/sakura_logo.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/utils/font_styles.dart';
import 'package:sakura_jisho/utils/routes.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  _navigateToFilterSections() {
    Navigator.of(context).push(FadePageRoute(
        builder: (c) {
          return FilterSection();
        },
        settings: RouteSettings()));
  }

  _navigateToDictionary(String filterBy, String searchBy) {
    Navigator.of(context).push(FadePageRoute(
        builder: (c) {
          return DictionaryPage(filterBy, searchBy);
        },
        settings: RouteSettings()));
  }

  String searchingBy = "Español";
  String sendSearchBy = 'meaning';
  FocusNode myFocus;
  List<DropdownMenuItem<String>> searchByList = [];
  List<String> searchBy = ['Español', 'Romaji', 'かな', '漢字'];
  final searchController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    searchController.dispose();
    myFocus.dispose();
    super.dispose();
  }

  _loadSearchBy() {
    searchByList = [];
    searchByList = searchBy
        .map((val) => DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();
  }

  @override
  void initState() {
    myFocus = FocusNode();
    _loadSearchBy();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [darkColor, darkLightColor],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          backgroundColor: Colors.transparent,
          body: _bodyBuilder(),
        ),
      ),
    );
  }

  Widget _bodyBuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SakuraLogo(
          color: Colors.white,
          left: 105.0,
          top: 55.0,
          sakuraFontSize: 100.0,
          diccionarioFontSize: 10.0,
          letterSpacing: 1.5,
        ),
        Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Buscando por: ',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: Theme(
                      data: ThemeData(canvasColor: darkColor),
                      child: DropdownButton(
                          value: searchingBy,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          items: searchByList,
                          onChanged: (selectedValue) {
                            searchingBy = selectedValue;
                            setState(() {});
                          }),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white12,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          focusNode: myFocus,
                          controller: searchController,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Buscar...',
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white70,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        String wordSearch =
                            '${searchController.text[0].toUpperCase()}${searchController.text.substring(1)}';
                        _handleSearch(searchingBy, wordSearch);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  _navigateToFilterSections();
                },
                child: Container(
                  color: Colors.white10,
                  width: double.infinity,
                  height: 45.0,
                  child: Center(
                    child: Text(
                      'Buscar por secciones',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    'Filtra le vocabulario por las principales categorías que Sakura tiene para ofrecerte',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 9.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void _handleSearch(String searchingBy, searchWord) {
    switch (searchingBy) {
      case 'Español':
        sendSearchBy = 'meaning';
        break;
      case 'Romaji':
        sendSearchBy = 'romajiWord';
        break;
      case 'かな':
        sendSearchBy = 'kanaWord';
        break;
      case '漢字':
        sendSearchBy = 'kanjiWord';
        break;
    }
    _navigateToDictionary(sendSearchBy, searchWord);
    searchController.clear();
  }
}
