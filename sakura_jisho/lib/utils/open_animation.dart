import 'package:flutter/material.dart';

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

  bool isOpen() {
    return _state == OpenableState.open;
  }

  bool isOpening() {
    return _state == OpenableState.opening;
  }

  bool isClosed() {
    return _state == OpenableState.closed;
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
