import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/events_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_provider.dart';
import '../../../services/auth_provider.dart';
import '../widgets/event_card.dart';
import 'dart:ui';
import 'dart:developer' as developer;
import '../screens/create_event_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selectedFilter = 'upcoming';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch events when screen initializes
    Future.microtask(() {
      context.read<EventsProvider>().fetchEvents();
      // Add debug log
      developer.log('EventsScreen initialized', name: 'EventsScreen');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final eventsProvider = Provider.of<EventsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUser?.id;

    // Debug log
    developer.log('Building EventsScreen with isDarkMode: $isDarkMode',
        name: 'EventsScreen');

    return Scaffold(
      // Add debug border to help visualize screen boundaries
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    AppTheme.primaryDark,
                    AppTheme.secondaryDark,
                  ]
                : [
                    AppTheme.lightBackground,
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                pinned: true,
                title: const Text('Cleanup Events'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                        ),
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                        },
                      );
                    },
                  ),
                ],
              ),

              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppTheme.textPrimary
                              : AppTheme.textPrimaryLight,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search events...',
                          hintStyle: TextStyle(
                            color: isDarkMode
                                ? AppTheme.textSecondary
                                : AppTheme.textSecondaryLight,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppTheme.accentTeal,
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? AppTheme.primaryDark.withOpacity(0.5)
                              : Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 16),

                      // Filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                              label: 'Upcoming',
                              value: 'upcoming',
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'In Progress',
                              value: 'ongoing',
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'Past',
                              value: 'past',
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              label: 'My Events',
                              value: 'my_events',
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Events List or Loading Indicator
              eventsProvider.isLoading
                  ? const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _buildEventsList(isDarkMode, eventsProvider, userId),

              // Replace FAB with a visible button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      20, 20, 20, 100), // Extra bottom padding
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [AppTheme.accentTeal, AppTheme.accentLime],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentTeal.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          developer.log('Host event button pressed',
                              name: 'EventsScreen');

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateEventScreen()),
                          );

                          if (result == true) {
                            // Refresh the events list when returning with a success result
                            Provider.of<EventsProvider>(context, listen: false)
                                .fetchEvents();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Cleanup event created successfully!'),
                                backgroundColor: AppTheme.accentTeal,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 28,
                                  color: isDarkMode
                                      ? AppTheme.primaryDark
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'HOST A CLEANUP EVENT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? AppTheme.primaryDark
                                      : Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    final isSelected = _selectedFilter == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentTeal
              : isDarkMode
                  ? AppTheme.primaryDark.withOpacity(0.5)
                  : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppTheme.accentTeal.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
          border: Border.all(
            color: isSelected
                ? AppTheme.accentTeal
                : isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? isDarkMode
                    ? AppTheme.primaryDark
                    : Colors.white
                : isDarkMode
                    ? AppTheme.textSecondary
                    : AppTheme.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList(
      bool isDarkMode, EventsProvider eventsProvider, String? userId) {
    // Filter events based on search and selected filter
    final filteredEvents = eventsProvider.events.where((event) {
      // Apply search filter
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        return event.title.toLowerCase().contains(searchTerm) ||
            event.description.toLowerCase().contains(searchTerm) ||
            event.location.toLowerCase().contains(searchTerm);
      }

      // Apply category filter
      switch (_selectedFilter) {
        case 'upcoming':
          return event.isUpcoming;
        case 'ongoing':
          return event.isOngoing;
        case 'past':
          return !event.isUpcoming && !event.isOngoing;
        case 'my_events':
          return userId != null &&
              (event.organizerId == userId ||
                  event.volunteerIds.contains(userId));
        default:
          return true;
      }
    }).toList();

    // If no events match the criteria
    if (filteredEvents.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy,
                size: 64,
                color: isDarkMode
                    ? AppTheme.textSecondary
                    : AppTheme.textSecondaryLight,
              ),
              const SizedBox(height: 16),
              Text(
                'No events found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppTheme.textPrimary
                      : AppTheme.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try changing your search or filter',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Display the list of events
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final event = filteredEvents[index];
            return EventCard(
              event: event,
              isDarkMode: isDarkMode,
              onTap: () {
                // Navigate to event details (to be implemented)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Event details coming soon: ${event.title}'),
                    backgroundColor: AppTheme.accentTeal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            );
          },
          childCount: filteredEvents.length,
        ),
      ),
    );
  }
}
