import 'package:flutter/material.dart';
import '../widgets/clouds_widget.dart';
import '../widgets/floor_widget.dart';
import '../widgets/car_widget.dart';
import '../widgets/controls_widget.dart';

// ✅ Define the StatefulWidget first
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ✅ Your existing state class
class _HomeScreenState extends State<HomeScreen> {
  double _position = 0;
  bool _movingLeft = false;
  bool _movingRight = false;

  void _startMoveLeft() {
    _movingLeft = true;
    _moveContinuously();
  }

  void _startMoveRight() {
    _movingRight = true;
    _moveContinuously();
  }

  void _stopMoveLeft() {
    _movingLeft = false;
  }

  void _stopMoveRight() {
    _movingRight = false;
  }

  void _moveContinuously() async {
    while (_movingLeft || _movingRight) {
      setState(() {
        if (_movingLeft) _position -= 5;
        if (_movingRight) _position += 5;
      });
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/sky.png', fit: BoxFit.cover),
        ),
        Positioned.fill(child: CloudsWidget(position: _position)),
        Align(
          alignment: Alignment.bottomCenter,
          child: FloorWidget(position: _position),
        ),
        Align(alignment: Alignment.bottomCenter, child: CarWidget()),
        ControlsWidget(
          onLeftStart: _startMoveLeft,
          onLeftEnd: _stopMoveLeft,
          onRightStart: _startMoveRight,
          onRightEnd: _stopMoveRight,
        ),
      ],
    );
  }
}
