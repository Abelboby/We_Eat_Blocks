import 'package:flutter/material.dart';

class XLogo extends StatefulWidget {
  final double size;

  const XLogo({
    super.key,
    required this.size,
  });

  @override
  State<XLogo> createState() => _XLogoState();
}

class _XLogoState extends State<XLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Image.asset(
                'assets/logo/x-logo.png',
                width: widget.size,
                height: widget.size,
              ),
            ),
          );
        },
      ),
    );
  }
}
