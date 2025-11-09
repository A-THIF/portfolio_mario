import 'package:flutter/material.dart';

class CarWidget extends StatefulWidget {
  const CarWidget({Key? key}) : super(key: key);

  @override
  State<CarWidget> createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget> {
  double position = 0.5; // 0.0 = left, 1.0 = right

  void moveLeft() {
    setState(() {
      position = (position - 0.05).clamp(0.0, 1.0);
    });
  }

  void moveRight() {
    setState(() {
      position = (position + 0.05).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double bottomOffset = screenHeight * 0.08; // keep spacing same

    // ✅ Responsive width with min/max limits
    final double carWidth = (screenWidth * 0.2).clamp(140.0, 180.0);

    return Align(
      alignment: Alignment(position * 2 - 1, 1),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomOffset),
        child: SizedBox(
          width: carWidth,
          child: Image.asset('assets/car_man1.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
