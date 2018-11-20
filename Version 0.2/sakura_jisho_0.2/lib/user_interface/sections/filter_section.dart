import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sakura_jisho/services/autentication.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/dictionary_screen.dart';
import 'package:sakura_jisho/user_interface/logo/sakura_logo.dart';
import 'package:sakura_jisho/user_interface/vocabulary/search_page.dart';
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/utils/routes.dart';
import 'package:sakura_jisho/utils/font_styles.dart';

class FilterSection extends StatefulWidget {
  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  final String title;
  UserAuth _authApi;
  NetworkImage _profileImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController passwordController = TextEditingController();


  _FilterSectionState({this.title});

  _signWithGoogle() async {
    final authApi = await UserAuth.signInWithGoogle();
    setState(() {
      _authApi = authApi;
      _profileImage = NetworkImage(authApi.firebaseUser.photoUrl);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    passwordController.dispose();
    super.dispose();
  }

  _navigateToDictionary(String filterBy, String searchBy) {
    Navigator.of(context).push(FadePageRoute(
        builder: (c) {
          return DictionaryPage(filterBy, searchBy);
        },
        settings: RouteSettings()));
  }

  _navigateToSearchPage() {
    Navigator.of(context).pop(FadePageRoute(
        builder: (c) {
          return SearchPage();
        },
        settings: RouteSettings()));
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.172;
    double cardWidth = MediaQuery.of(context).size.width * 0.85;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [darkColor, darkLightColor],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: _appBarBuilder(),
        drawer: _drawerBuilder(),
        body: ListView(
          children: <Widget>[
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'DICCIONARIO',
              image: 'images/sakura_temple_img.jpg',
              isOdd: true,
              action: () => _navigateToDictionary('Diccionario', ''),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'SUSTANTIVOS',
              image: 'images/japanese_crowded_town_img.jpg',
              isOdd: false,
              action: () => _navigateToDictionary('Sustantivo', ''),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'VERBOS',
              image: 'images/shrimp_img.jpg',
              isOdd: true,
              action: () => _navigateToDictionary('Verbo', ''),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'ADJETIVOS',
              image: 'images/japanese_town_img.jpg',
              isOdd: false,
              action: () => _navigateToDictionary('Adjetivo', ''),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'CONTADORES',
              image: 'images/japanese_lamps_img.jpg',
              isOdd: true,
              action: () => _navigateToDictionary('Contador', ''),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'ADVERBIOS',
              image: 'images/fuji_img.jpg',
              isOdd: false,
              action: () => _navigateToDictionary('Adverbio', ''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarBuilder() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading:  IconButton(
          icon: Icon(Icons.sort),
          onPressed: () => _scaffoldKey.currentState.openDrawer()),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _navigateToSearchPage();
          },
        )
      ],
    );
  }


  Widget _drawerBuilder() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          darkColor.withAlpha(200),
          darkLightColor.withAlpha(200)
        ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: _authApi != null ?
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: _profileImage,
                        radius: MediaQuery.of(context).size.width * 0.15
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Color(0xFFB05FF7)
                          ),
                        ),
                      ),
                      Text(
                        _authApi.firebaseUser.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white54,
                          fontSize: 20.0
                        ),
                      ),
                    ],
                  ) :
              SakuraLogo(
                color: Colors.white,
                sakuraFontSize: 100.0,
                diccionarioFontSize: 16.0,
                letterSpacing: 1.0,
                top: 50.0,
                left: 77.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: Colors.white70,
                      size: 19.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Acerca de',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  print(_authApi.firebaseUser.uid.toString());
                },
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                    size: 19.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Iniciar sesión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              onTap: () {
                if (_authApi != null) {
                  _showTextDialog('Ya se cuenta con una sesión activa');
                } else {
                  _dialog();
                }

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _showTextDialog (String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(content)
          );
        }
    );
  }

  Widget _dialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Se requiere contraseña'),
          content: Theme(
            data: ThemeData(
              primarySwatch: Colors.pink
            ),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: pink,
              child: Text('Iniciar sesión'),
              onPressed: () {
                _handleSignIn(passwordController.text);
              }
            ),
            FlatButton(
              color: pink,
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                passwordController.clear();
              },
              textColor: Colors.white,
            ),
          ],
        );
      }
    );
  }

  void _handleSignIn(String password) {
      if (password == 'SuperPassword') {
        passwordController.clear();
        _signWithGoogle();
        Navigator.of(context).pop();
      }
  }
}

class FilterSectionCard extends StatefulWidget {
  final double height;
  final double width;
  final String title;
  final String image;
  final bool isOdd;
  final Function action;

  FilterSectionCard(
      {this.height,
      this.width,
      this.title,
      this.image,
      this.isOdd,
      this.action});

  @override
  _FilterSectionCardState createState() => _FilterSectionCardState();
}

class _FilterSectionCardState extends State<FilterSectionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        children: <Widget>[
          Align(
            alignment:
                widget.isOdd ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.image),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        darkColor.withAlpha(120), BlendMode.darken)),
              ),
            ),
          ),
          Padding(
            padding: widget.isOdd
                ? const EdgeInsets.only(left: 18.0)
                : const EdgeInsets.only(right: 18.0),
            child: Align(
                alignment:
                    widget.isOdd ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  widget.title,
                  style: CustomTextStyle.filterTitle(context),
                )),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.action,
              child: Container(
                height: widget.height,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final Icon leadingIcon;
  final String title;
  final Function function;

  DrawerTile({this.leadingIcon, this.title, this.function});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon,
      title: Text(title),
      onTap: () => function(),
    );
  }
}
