import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle kanaText(BuildContext context) {
  return Theme.of(context).textTheme.display4.copyWith(
      fontSize: 16.0,
      color: Colors.white70
    );
  }

  static TextStyle h2Text(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w600
    );
  }

  static TextStyle titleListTile(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle traillingListTile(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
        color: Colors.white70,
        fontSize: 14.0,
        fontWeight: FontWeight.w300
    );
  }


  static TextStyle h1Text(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold
    );
  }

  static TextStyle staticTopPanelText(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
        color: Colors.white70,
        fontSize: 12.0,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle dynamicTopPanelText(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle dynamicEditSinglelineText(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w500
    );
  }

  static TextStyle dynamicEditMultilineText(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.w500
    );
  }

}

