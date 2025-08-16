import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class CelebrationAnimation extends StatelessWidget {
  final ConfettiController controller;
  
  const CelebrationAnimation({
    super.key,
    required this.controller,
  });
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
          Colors.yellow,
        ],
        createParticlePath: _drawStar,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.1,
        maxBlastForce: 20,
        minBlastForce: 8,
      ),
    );
  }
  
  Path _drawStar(Size size) {
    // method to draw a star shape
    double degToRad(double deg) => deg * (pi / 180.0);
    
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    
    path.moveTo(size.width, halfWidth);
    
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    
    path.close();
    return path;
  }
}