// screens/ripple_screen.dart
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../models/alarm.dart';

class RippleScreen extends StatelessWidget {
  final Alarm alarm;

  RippleScreen({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RippleAnimation(
          color: Colors.blue,
          delay: Duration(seconds: 1),
          repeat: true,
          minRadius: 50,
          ripplesCount: 6,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('Alarm!'),
            ),
          ),
        ),
      ),
    );
  }
}
