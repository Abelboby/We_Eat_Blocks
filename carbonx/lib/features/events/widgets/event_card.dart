import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../../../models/cleanup_event_model.dart';
import '../../../theme/app_theme.dart';

class EventCard extends StatelessWidget {
  final CleanUpEvent event;
  final VoidCallback onTap;
  final bool isDarkMode;

  const EventCard({
    Key? key,
    required this.event,
    required this.onTap,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPremiumCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge
              _buildStatusBadge(),

              const SizedBox(height: 12),

              // Title
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? AppTheme.textPrimary
                      : AppTheme.textPrimaryLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Date & Time
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.accentTeal,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM dd, yyyy').format(event.date),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.accentTeal,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.accentTeal,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppTheme.textSecondary
                            : AppTheme.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Volunteer progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Volunteers: ${event.volunteerIds.length}/${event.maxVolunteers}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: event.volunteerProgress,
                    backgroundColor: isDarkMode
                        ? AppTheme.primaryDark.withOpacity(0.3)
                        : AppTheme.accentTeal.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      event.volunteerProgress >= 1.0
                          ? Colors.green
                          : AppTheme.accentTeal,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String statusText;

    switch (event.status) {
      case 'upcoming':
        badgeColor = AppTheme.accentTeal;
        statusText = 'Upcoming';
        break;
      case 'ongoing':
        badgeColor = Colors.green;
        statusText = 'In Progress';
        break;
      case 'completed':
        badgeColor = Colors.blue;
        statusText = 'Completed';
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        statusText = 'Cancelled';
        break;
      default:
        badgeColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badgeColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildPremiumCard({
    required Widget child,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDarkMode
                  ? AppTheme.secondaryDark.withOpacity(0.7)
                  : Colors.white.withOpacity(0.8),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
