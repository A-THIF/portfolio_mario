import 'package:flutter/material.dart';
import '../widgets/clouds_widget.dart';
import '../widgets/floor_widget.dart';
import '../widgets/car_widget.dart';
import '../widgets/controls_widget.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double worldX = 0; // world scroll offset
  double carX = 0.5; // 0.0 to 1.0 screen position

  bool movingLeft = false;
  bool movingRight = false;
  bool _isLoopRunning = false; // prevent multiple loops

  final double cloudParallax = 0.3;
  final double floorParallax = 1.0;
  final double objectParallax = 1.0;
  final double stepSize = 0.02;

  final double leftLimit = 0.25;
  final double rightLimit = 0.75;

  static const double floorHeight = 250;

  void startLeft() {
    if (!movingLeft) {
      movingLeft = true;
      movingRight = false; // cancel opposite direction
      _gameLoop();
    }
  }

  void startRight() {
    if (!movingRight) {
      movingRight = true;
      movingLeft = false; // cancel opposite direction
      _gameLoop();
    }
  }

  void stopLeft() => movingLeft = false;
  void stopRight() => movingRight = false;

  void stopAll() {
    movingLeft = false;
    movingRight = false;
  }

  void _gameLoop() async {
    if (_isLoopRunning) return;
    _isLoopRunning = true;

    while (movingLeft || movingRight) {
      setState(() {
        if (movingLeft) _moveLeft();
        if (movingRight) _moveRight();
      });
      await Future.delayed(const Duration(milliseconds: 16));
    }

    _isLoopRunning = false;
  }

  // Add this inside _HomeScreenState

  void _moveLeft() {
    final screenWidth = MediaQuery.of(context).size.width;
    final double carSpeed = screenWidth * 0.005;
    final double worldSpeed = screenWidth * 0.004;

    if (carX > leftLimit) {
      carX -= carSpeed / screenWidth;
    } else {
      worldX += worldSpeed;
    }
  }

  void _moveRight() {
    final screenWidth = MediaQuery.of(context).size.width;
    final double carSpeed = screenWidth * 0.005;
    final double worldSpeed = screenWidth * 0.004;

    if (carX < rightLimit) {
      carX += carSpeed / screenWidth;
    } else {
      worldX -= worldSpeed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SKY
        Positioned.fill(
          child: Image.asset('assets/sky.png', fit: BoxFit.cover),
        ),

        // CLOUDS
        Positioned.fill(child: CloudsWidget(position: worldX * cloudParallax)),

        // FLOOR
        Align(
          alignment: Alignment.bottomCenter,
          child: FloorWidget(position: worldX * floorParallax),
        ),

        // SIGNPOST
        Positioned(
          bottom: floorHeight * 0.28,
          left: worldX * objectParallax + 300,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
            child: Image.asset('assets/signpost-home.png', width: 140),
          ),
        ),

        // CAR
        CarWidget(screenX: carX),

        // CONTROLS
        ControlsWidget(
          onLeftStart: startLeft,
          onLeftEnd: stopLeft,
          onRightStart: startRight,
          onRightEnd: stopRight,
          onStopAll: stopAll, // <-- pass the new callback
        ),
      ],
    );
  }
}
