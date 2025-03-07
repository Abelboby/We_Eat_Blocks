import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CarbonCreditCard extends StatelessWidget {
  final double tokens;
  final double footprint;
  final int offsetPercentage;

  const CarbonCreditCard({
    super.key,
    required this.tokens,
    required this.footprint,
    required this.offsetPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius4),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius4),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.accentTeal.withOpacity(0.8),
              AppTheme.accentTeal,
            ],
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Green Tokens',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing1),
                    Text(
                      '$tokens GT',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.token,
                    color: AppTheme.primaryDark,
                    size: 30,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacing4),
            
            // Carbon Footprint
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carbon Footprint',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryDark.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing1),
                    Text(
                      '$footprint tons',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Offset',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryDark.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing1),
                    Text(
                      '$offsetPercentage%',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius2),
              child: LinearProgressIndicator(
                value: offsetPercentage / 100,
                backgroundColor: AppTheme.primaryDark.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.accentLime,
                ),
                minHeight: 8,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing3),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionButton(
                  icon: Icons.add,
                  label: 'Add',
                  onTap: () {
                    // TODO: Add tokens action
                  },
                ),
                _ActionButton(
                  icon: Icons.swap_horiz,
                  label: 'Trade',
                  onTap: () {
                    // TODO: Trade tokens action
                  },
                ),
                _ActionButton(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () {
                    // TODO: View history action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius3),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing3,
          vertical: AppTheme.spacing2,
        ),
        decoration: BoxDecoration(
          color: AppTheme.primaryDark.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius3),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryDark,
              size: 20,
            ),
            const SizedBox(height: AppTheme.spacing1),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 