
import 'package:flutter/material.dart';
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'dart:math' as math;

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
              _optionIconBuilder(Icons.edit, - math.pi / 4),
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
