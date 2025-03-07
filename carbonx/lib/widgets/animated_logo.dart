import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedLogo extends StatelessWidget {
  final double size;
  
  const AnimatedLogo({
    super.key, 
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(AppTheme.spacing3),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentTeal.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Outer Circle
            Center(
              child: Container(
                width: size * 0.8,
                height: size * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentTeal.withOpacity(0.7),
                    width: 2,
                  ),
                ),
              ),
            ),
            
            // Inner Circle
            Center(
              child: Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentTeal,
                ),
                child: Center(
                  child: Text(
                    'CX',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: size * 0.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            // Small Circle 1
            Positioned(
              top: size * 0.15,
              right: size * 0.15,
              child: Container(
                width: size * 0.15,
                height: size * 0.15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentLime,
                ),
              ),
            ),
            
            // Small Circle 2
            Positioned(
              bottom: size * 0.15,
              left: size * 0.15,
              child: Container(
                width: size * 0.15,
                height: size * 0.15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentLime,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 