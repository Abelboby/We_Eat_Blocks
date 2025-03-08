import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../providers/events_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_provider.dart';
import '../../../services/auth_provider.dart';
import '../../../widgets/animated_bar_indicator.dart';
import '../widgets/event_card.dart';
import 'dart:ui';
import 'dart:developer' as developer;
import '../screens/create_event_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'upcoming';
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  bool _isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

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
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final eventsProvider = Provider.of<EventsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUser?.id;
    final size = MediaQuery.of(context).size;

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
                    AppTheme.primaryDark.withOpacity(0.8),
                    AppTheme.secondaryDark,
                  ]
                : [
                    AppTheme.lightBackground.withOpacity(0.7),
                    Colors.white.withOpacity(0.9),
                    Colors.white,
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Background decoration elements
            Positioned(
              top: -50,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accentTeal.withOpacity(0.3),
                      AppTheme.accentTeal.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -80,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accentLime.withOpacity(0.2),
                      AppTheme.accentLime.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 120,
                    collapsedHeight: 60,
                    backgroundColor: isDarkMode
                        ? AppTheme.primaryDark.withOpacity(0.7)
                        : Colors.white.withOpacity(0.7),
                    flexibleSpace: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: FlexibleSpaceBar(
                          title: Text(
                            'Cleanup Events',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? AppTheme.textPrimary
                                  : AppTheme.textPrimaryLight,
                            ),
                          ),
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDarkMode
                                    ? [
                                        AppTheme.primaryDark.withOpacity(0.6),
                                        AppTheme.secondaryDark.withOpacity(0.6),
                                      ]
                                    : [
                                        Colors.white.withOpacity(0.6),
                                        AppTheme.lightBackground
                                            .withOpacity(0.6),
                                      ],
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 20.0, top: 20.0),
                                child: Icon(
                                  Icons.eco_rounded,
                                  size: 32,
                                  color: AppTheme.accentTeal.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          centerTitle: true,
                        ),
                      ),
                    ),
                    elevation: 0,
                    actions: [
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, _) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDarkMode
                                  ? AppTheme.secondaryDark.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.5),
                            ),
                            child: IconButton(
                              icon: Icon(
                                themeProvider.isDarkMode
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                                color: isDarkMode
                                    ? AppTheme.accentTeal
                                    : AppTheme.accentTeal,
                              ),
                              onPressed: () {
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .toggleTheme();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Search bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            if (_isSearchFocused)
                              BoxShadow(
                                color: AppTheme.accentTeal.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
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
                                prefixIcon: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.search,
                                    color: _isSearchFocused
                                        ? AppTheme.accentTeal
                                        : isDarkMode
                                            ? AppTheme.textSecondary
                                            : AppTheme.textSecondaryLight,
                                    size: 22,
                                  ),
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: isDarkMode
                                              ? AppTheme.textSecondary
                                              : AppTheme.textSecondaryLight,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: isDarkMode
                                    ? AppTheme.primaryDark.withOpacity(0.7)
                                    : Colors.white.withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: _isSearchFocused
                                        ? AppTheme.accentTeal
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: AppTheme.accentTeal,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            )
                                .animate()
                                .fade(
                                    duration: const Duration(milliseconds: 300))
                                .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    duration:
                                        const Duration(milliseconds: 300)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Filter chips
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildFilterChip(
                              label: 'Upcoming',
                              value: 'upcoming',
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 12),
                            _buildFilterChip(
                              label: 'In Progress',
                              value: 'ongoing',
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 12),
                            _buildFilterChip(
                              label: 'Past',
                              value: 'past',
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 12),
                            _buildFilterChip(
                              label: 'My Events',
                              value: 'my_events',
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 8),
                  ),

                  // Category indicator
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBarIndicator(
                            isActive: _selectedFilter == 'upcoming',
                            color: AppTheme.accentTeal,
                            width: 40,
                            height: 3,
                          ),
                          const SizedBox(width: 8),
                          AnimatedBarIndicator(
                            isActive: _selectedFilter == 'ongoing',
                            color: AppTheme.accentLime,
                            width: 40,
                            height: 3,
                          ),
                          const SizedBox(width: 8),
                          AnimatedBarIndicator(
                            isActive: _selectedFilter == 'past',
                            color: AppTheme.textSecondary,
                            width: 40,
                            height: 3,
                          ),
                          const SizedBox(width: 8),
                          AnimatedBarIndicator(
                            isActive: _selectedFilter == 'my_events',
                            color: AppTheme.accentAmber,
                            width: 40,
                            height: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Events List or Loading Indicator
                  eventsProvider.isLoading
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.accentTeal,
                                    ),
                                    strokeWidth: 3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading events...',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? AppTheme.textSecondary
                                        : AppTheme.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _buildEventsList(isDarkMode, eventsProvider, userId),

                  // Bottom padding to account for FAB
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 8),
        child: FloatingActionButton.extended(
          onPressed: () async {
            developer.log('Host event button pressed', name: 'EventsScreen');

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateEventScreen()),
            );

            if (result == true) {
              // Refresh the events list when returning with a success result
              Provider.of<EventsProvider>(context, listen: false).fetchEvents();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Cleanup event created successfully!'),
                    backgroundColor: AppTheme.accentTeal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            }
          },
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 24),
          ),
          label: const Text(
            'HOST EVENT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 14,
            ),
          ),
          backgroundColor: AppTheme.accentTeal,
          foregroundColor: isDarkMode ? AppTheme.primaryDark : Colors.white,
          elevation: 4,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ).animate().fade(duration: const Duration(milliseconds: 500)).scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            duration: const Duration(milliseconds: 500)),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentTeal
              : isDarkMode
                  ? AppTheme.secondaryDark.withOpacity(0.5)
                  : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
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
                    : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(right: 6),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.primaryDark : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
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
          ],
        ),
      ).animate(target: isSelected ? 1 : 0).scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1, 1),
            duration: const Duration(milliseconds: 200),
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.secondaryDark.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.event_busy,
                  size: 64,
                  color: isDarkMode
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryLight,
                ),
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 500))
                  .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: const Duration(milliseconds: 500)),
              const SizedBox(height: 24),
              Text(
                'No events found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppTheme.textPrimary
                      : AppTheme.textPrimaryLight,
                ),
              )
                  .animate()
                  .fade(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 500))
                  .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: const Duration(milliseconds: 500)),
              const SizedBox(height: 12),
              Text(
                'Try changing your search or filter',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryLight,
                ),
              )
                  .animate()
                  .fade(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 500))
                  .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: const Duration(milliseconds: 500)),
            ],
          ),
        ),
      );
    }

    // Display the list of events
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            )
                .animate()
                .fade(
                    delay: Duration(milliseconds: 100 * index),
                    duration: const Duration(milliseconds: 500))
                .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: const Duration(milliseconds: 500));
          },
          childCount: filteredEvents.length,
        ),
      ),
    );
  }
}
