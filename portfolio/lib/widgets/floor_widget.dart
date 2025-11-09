import 'package:flutter/material.dart';

class FloorWidget extends StatefulWidget {
  final double position;

  const FloorWidget({required this.position, Key? key}) : super(key: key);

  @override
  State<FloorWidget> createState() => _FloorWidgetState();
}

class _FloorWidgetState extends State<FloorWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final floorHeight = 250.0;

    // loop position — keeps floor moving forever
    final double effectiveX = widget.position % screenWidth;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          // First segment of floor
          Positioned(
            left: -effectiveX,
            bottom: 0,
            child: Image.asset(
              'assets/grass_floor.png',
              repeat: ImageRepeat.repeatX,
              height: floorHeight,
              width: screenWidth * 2,
            ),
          ),

          // Second segment — this makes the wrap seamless
          Positioned(
            left: screenWidth * 2 - effectiveX,
            bottom: 0,
            child: Image.asset(
              'assets/grass_floor.png',
              repeat: ImageRepeat.repeatX,
              height: floorHeight,
              width: screenWidth * 2,
            ),
          ),
        ],
      ),
    );
  }
}
