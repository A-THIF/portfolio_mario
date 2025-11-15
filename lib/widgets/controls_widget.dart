import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class ControlsWidget extends StatefulWidget {
  final VoidCallback onLeftStart;
  final VoidCallback onRightStart;
  final VoidCallback onLeftEnd;
  final VoidCallback onRightEnd;
  final VoidCallback onStopAll; // for stopping the car

  const ControlsWidget({
    required this.onLeftStart,
    required this.onRightStart,
    required this.onLeftEnd,
    required this.onRightEnd,
    required this.onStopAll,
    super.key,
  });

  @override
  State<ControlsWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  final FocusNode _focusNode = FocusNode();

  bool _isMovingLeft = false;
  bool _isMovingRight = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _focusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        widget.onStopAll();
        widget.onLeftStart();
        _isMovingLeft = true;
        _isMovingRight = false;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        widget.onStopAll();
        widget.onRightStart();
        _isMovingRight = true;
        _isMovingLeft = false;
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        widget.onLeftEnd();
        _isMovingLeft = false;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        widget.onRightEnd();
        _isMovingRight = false;
      }
    }
    return false;
  }

  void _handlePointerScroll(PointerScrollEvent event) {
    widget.onStopAll(); // stop any current movement
    if (event.scrollDelta.dy < 0) {
      widget.onRightStart();
      _isMovingRight = true;
      _isMovingLeft = false;
    } else if (event.scrollDelta.dy > 0) {
      widget.onLeftStart();
      _isMovingLeft = true;
      _isMovingRight = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) _handlePointerScroll(event);
      },
      behavior: HitTestBehavior.translucent,
      child: GestureDetector(
        onTap: () {
          widget.onStopAll();
          _isMovingLeft = false;
          _isMovingRight = false;
        },
        onHorizontalDragUpdate: (details) {
          widget.onStopAll();
          if (details.delta.dx > 0) {
            widget.onRightStart();
            _isMovingRight = true;
            _isMovingLeft = false;
          } else if (details.delta.dx < 0) {
            widget.onLeftStart();
            _isMovingLeft = true;
            _isMovingRight = false;
          }
        },
        onHorizontalDragEnd: (_) {
          widget.onStopAll();
          _isMovingLeft = false;
          _isMovingRight = false;
        },
        behavior: HitTestBehavior.opaque,
        child: const SizedBox.expand(),
      ),
    );
  }
}
