import 'package:flutter/material.dart';
import 'package:sakura_jisho/utils/font_styles.dart';

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
    openableController = OpenableController(
        vsync: this, openDuration: const Duration(milliseconds: 250))
      ..addListener(() => setState(() {}))
      ..open();
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
      child: Text(text, style: CustomTextStyle.dynamicTopPanelText(context),),
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height * 0.3;
    return Container(
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
                            onTap: () {
                              //TODO:
                            },
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
                  )
                ],
              ),
            ],
          )),
    );
  }
}

class OpenableController extends ChangeNotifier {
  OpenableState _state = OpenableState.closed;
  AnimationController _opening;

  OpenableController({
    @required TickerProvider vsync,
    @required Duration openDuration,
  }) : _opening =
            new AnimationController(vsync: vsync, duration: openDuration) {
    _opening
      ..addListener(notifyListeners)
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = OpenableState.opening;
            break;

          case AnimationStatus.completed:
            _state = OpenableState.open;
            break;

          case AnimationStatus.reverse:
            _state = OpenableState.closing;
            break;

          case AnimationStatus.dismissed:
            _state = OpenableState.closed;
            break;
        }
        notifyListeners();
      });
  }

  get state => _state;

  get percentOpen => _opening.value;

  bool isClosed() {
    return _state == OpenableState.closed;
  }

  bool isOpening() {
    return _state == OpenableState.opening;
  }

  bool isOpen() {
    return _state == OpenableState.open;
  }

  bool isClosing() {
    return _state == OpenableState.closing;
  }

  void open() {
    _opening.forward();
  }

  void close() {
    _opening.reverse();
  }

  void toggle() {
    if (isClosed()) {
      open();
    } else if (isOpen()) {
      close();
    }
  }
}

enum OpenableState {
  closed,
  opening,
  open,
  closing,
}
