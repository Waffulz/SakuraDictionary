import 'package:flutter/material.dart';

class SakuraLogo extends StatelessWidget {
  Color color;
  double left;
  double top;
  double sakuraFontSize;
  double diccionarioFontSize;
  double letterSpacing;

  SakuraLogo({
    this.color,
    this.left,
    this.top,
    this.sakuraFontSize,
    this.diccionarioFontSize,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          'Sakura',
          style: TextStyle(
              color: color, fontSize: sakuraFontSize, fontFamily: 'Hayley'),
        ),
        Positioned(
          left: left, //113
          top: top,  //65
          child: Text(
            'Diccionario',
            style: TextStyle(
              color: color,
              fontFamily: 'Montserrat',
              fontSize: diccionarioFontSize,
              letterSpacing: letterSpacing,
            ),
          ),
        )
      ],
    );;
  }
}
