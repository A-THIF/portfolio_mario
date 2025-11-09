import 'package:flutter/material.dart';

class CloudsWidget extends StatelessWidget {
  final double position;
  const CloudsWidget({required this.position, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fixedCloudWidth = 1200.0; // Example width of your cloud image in px

    // How many tiles needed to cover screen fully + 1 for smooth transition
    final int tilesCount = (screenWidth / fixedCloudWidth).ceil() + 1;

    final effectiveX = position % fixedCloudWidth;

    return SizedBox(
      width: double.infinity,
      height: 200, // adjust as needed
      child: Stack(
        children: List.generate(tilesCount, (index) {
          return Positioned(
            left: fixedCloudWidth * index - effectiveX,
            top: 0,
            child: Image.asset(
              'assets/clouds.png',
              width: fixedCloudWidth,
              fit: BoxFit.cover,
            ),
          );
        }),
      ),
    );
  }
}
