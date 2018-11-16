import 'package:flutter/material.dart';
import 'package:sakura_jisho/user_interface/dictionary_section/dictionary_screen.dart';
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/utils/routes.dart';
import 'package:sakura_jisho/utils/font_styles.dart';

class FilterSection extends StatefulWidget {
  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  final String title;

  _FilterSectionState({this.title});

  _navigateToDictionary(String filterBy) {
    Navigator.of(context).push(FadePageRoute(
        builder: (c) {
          return DictionaryPage(filterBy);
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
              action: ()=> _navigateToDictionary('Diccionario'),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'SUSTANTIVOS',
              image: 'images/japanese_crowded_town_img.jpg',
              isOdd: false,
              action: ()=> _navigateToDictionary('Sustantivo'),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'VERBOS',
              image: 'images/shrimp_img.jpg',
              isOdd: true,
              action: ()=> _navigateToDictionary('Verbo'),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'ADJETIVOS',
              image: 'images/japanese_town_img.jpg',
              isOdd: false,
              action: ()=> _navigateToDictionary('Adjetivo'),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'CONTADORES',
              image: 'images/japanese_lamps_img.jpg',
              isOdd: true,
              action: ()=> _navigateToDictionary('Contador'),
            ),
            FilterSectionCard(
              height: cardHeight,
              width: cardWidth,
              title: 'ADVERBIOS',
              image: 'images/fuji_img.jpg',
              isOdd: false,
              action: ()=> _navigateToDictionary('Adverbio'),
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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            //TODO:
          },
        )
      ],
    );
  }

  Widget _drawerBuilder() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerTile(
            leadingIcon: Icon(Icons.info),
            title: 'Acerca de',
          ),
          DrawerTile(
            leadingIcon: Icon(Icons.attach_money),
            title: 'Donaciones',
          ),
          DrawerTile(
            leadingIcon: Icon(Icons.favorite),
            title: 'Hola tester',
          ),
        ],
      ),
    );
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

  DrawerTile({this.leadingIcon, this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon,
      title: Text(title),
      onTap: () {},
    );
  }
}
