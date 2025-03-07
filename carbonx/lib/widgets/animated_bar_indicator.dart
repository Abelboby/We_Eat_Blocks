import 'package:flutter/material.dart';

class AnimatedBarIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;
  final double width;
  final double height;
  final Duration duration;
  
  const AnimatedBarIndicator({
    Key? key,
    required this.isActive,
    required this.color,
    this.width = 20.0,
    this.height = 4.0,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      width: isActive ? width : 0,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
} 