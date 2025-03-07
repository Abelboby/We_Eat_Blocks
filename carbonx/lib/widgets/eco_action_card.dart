import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EcoActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData iconData;
  final double reward;
  final double progress;

  const EcoActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconData,
    required this.reward,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: progress >= 0.5
                    ? AppTheme.accentLime.withOpacity(0.2)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius2),
              ),
              child: Icon(
                iconData,
                color: progress >= 0.5
                    ? AppTheme.accentLime
                    : Theme.of(context).textTheme.bodyMedium?.color,
                size: 30,
              ),
            ),
            
            const SizedBox(width: AppTheme.spacing3),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  
                  const SizedBox(height: AppTheme.spacing1),
                  
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  
                  const SizedBox(height: AppTheme.spacing2),
                  
                  // Progress Bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius1),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 0.5 ? AppTheme.accentLime : AppTheme.accentTeal,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: AppTheme.spacing2),
                      
                      // Reward
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing2,
                          vertical: AppTheme.spacing1,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentTeal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius2),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.token,
                              size: 16,
                              color: AppTheme.accentTeal,
                            ),
                            const SizedBox(width: AppTheme.spacing1),
                            Text(
                              '+$reward',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 