import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_provider.dart';
import '../../widgets/carbon_credit_card.dart';
import '../../widgets/eco_action_card.dart';
import '../../widgets/stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const DashboardPage(),
    const Placeholder(key: ValueKey('marketplace')),
    const Placeholder(key: ValueKey('projects')),
    const Placeholder(key: ValueKey('profile')),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_outlined),
            activeIcon: Icon(Icons.eco),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            title: const Text('CarbonX'),
            actions: [
              // Theme toggle
              IconButton(
                icon: Icon(
                  ThemeProvider.of(context).isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
                onPressed: () {
                  ThemeProvider.of(context).toggleTheme();
                },
              ),
              
              // Notifications
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Show notifications
                },
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Text(
                    'Hello, Eco Warrior!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                    .animate()
                    .fadeIn(duration: AppTheme.defaultAnimationDuration)
                    .slideX(
                      begin: 0.1,
                      end: 0,
                      duration: AppTheme.defaultAnimationDuration,
                      curve: Curves.easeOutCubic,
                    ),
                    
                  const SizedBox(height: AppTheme.spacing2),
                  
                  Text(
                    'Track your carbon footprint and make a difference',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 0.5,
                      duration: AppTheme.defaultAnimationDuration,
                    ),
                ],
              ),
            ),
          ),
          
          // Green Tokens Balance
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing3),
              child: CarbonCreditCard(
                tokens: 128.5,
                footprint: 42.3,
                offsetPercentage: 75,
              ),
            ),
          )
            .animate()
            .fadeIn(
              delay: AppTheme.defaultAnimationDuration,
              duration: AppTheme.defaultAnimationDuration,
            )
            .slideY(
              begin: 0.2,
              end: 0,
              delay: AppTheme.defaultAnimationDuration,
              duration: AppTheme.defaultAnimationDuration,
              curve: Curves.easeOutCubic,
            ),
          
          // Statistics
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Impact',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 1.5,
                      duration: AppTheme.defaultAnimationDuration,
                    ),
                    
                  const SizedBox(height: AppTheme.spacing3),
                  
                  Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          icon: Icons.co2,
                          title: 'CO₂ Reduced',
                          value: '42.3',
                          unit: 'tons',
                          backgroundColor: AppTheme.accentTeal.withOpacity(0.2),
                          iconColor: AppTheme.accentTeal,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing3),
                      Expanded(
                        child: StatsCard(
                          icon: Icons.eco,
                          title: 'Trees Planted',
                          value: '17',
                          unit: 'trees',
                          backgroundColor: AppTheme.accentLime.withOpacity(0.2),
                          iconColor: AppTheme.accentLime,
                        ),
                      ),
                    ],
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 2,
                      duration: AppTheme.defaultAnimationDuration,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: AppTheme.defaultAnimationDuration * 2,
                      duration: AppTheme.defaultAnimationDuration,
                      curve: Curves.easeOutCubic,
                    ),
                ],
              ),
            ),
          ),
          
          // Recent Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Eco Actions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: View all actions
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 2.5,
                      duration: AppTheme.defaultAnimationDuration,
                    ),
                    
                  const SizedBox(height: AppTheme.spacing3),

                  Column(
                    children: [
                      const EcoActionCard(
                        title: 'Plant a Tree',
                        description: 'Contribute to reforestation efforts',
                        iconData: Icons.park_outlined,
                        reward: 10.0,
                        progress: 0.4,
                      ),
                      const SizedBox(height: AppTheme.spacing3),
                      const EcoActionCard(
                        title: 'Use Public Transport',
                        description: 'Reduce your carbon footprint by 5%',
                        iconData: Icons.directions_bus_outlined,
                        reward: 5.0,
                        progress: 0.7,
                      ),
                      const SizedBox(height: AppTheme.spacing3),
                      const EcoActionCard(
                        title: 'Reduce Energy Usage',
                        description: 'Monitor and reduce home energy consumption',
                        iconData: Icons.lightbulb_outline,
                        reward: 8.0,
                        progress: 0.2,
                      ),
                    ],
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 3,
                      duration: AppTheme.defaultAnimationDuration,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: AppTheme.defaultAnimationDuration * 3,
                      duration: AppTheme.defaultAnimationDuration,
                      curve: Curves.easeOutCubic,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 