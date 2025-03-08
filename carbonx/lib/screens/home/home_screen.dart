import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_provider.dart';
import '../../services/auth_provider.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/events/screens/events_screen.dart';
import '../../features/events/screens/create_event_screen.dart';
import '../../features/market/screens/marketplace_page.dart';
import '../profile/profile_edit_screen.dart';
import '../authentication/login_screen.dart';
import '../../widgets/animated_bar_indicator.dart';
import 'dart:ui';
import '../../features/market/providers/market_provider.dart';
import '../../features/wallet/providers/wallet_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  final List<Widget> _pages = [
    const DashboardPage(),
    const MarketplacePage(),
    const EventsScreen(),
    const WalletScreen(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add pulse animation when selecting a tab
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: _pages[_selectedIndex],
      extendBody: true, // Important for the floating effect
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            // Lift navbar higher by increasing the bottom padding
            bottom: bottomPadding > 0 ? 6.0 : 14.0,
            left: 16.0,
            right: 16.0),
        child: PremiumNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          animationController: _animationController,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}

class PremiumNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final AnimationController animationController;
  final bool isDarkMode;

  const PremiumNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.animationController,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Reduce height to address overflow
    final navHeight = bottomPadding > 0 ? 68.0 : 76.0;

    // Create a glass effect container
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: navHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      AppTheme.primaryDark.withOpacity(0.7),
                      AppTheme.secondaryDark.withOpacity(0.85),
                    ]
                  : [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.85),
                    ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: isDarkMode
                  ? AppTheme.textPrimary.withOpacity(0.12)
                  : Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            minimum: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  index: 0,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.store_outlined,
                  activeIcon: Icons.store_rounded,
                  label: 'Market',
                  index: 1,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.eco_outlined,
                  activeIcon: Icons.eco_rounded,
                  label: 'Events',
                  index: 2,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.account_balance_wallet_outlined,
                  activeIcon: Icons.account_balance_wallet_rounded,
                  label: 'Wallet',
                  index: 3,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    final theme = Theme.of(context);
    final primaryColor = AppTheme.accentTeal;
    final secondaryColor = AppTheme.accentLime;
    final size = MediaQuery.of(context).size;

    // Further reduce icon size for smaller devices
    final iconSize = size.width < 360 ? 21.0 : 24.0;
    final containerSize = size.width < 360 ? 44.0 : 48.0;

    // Create gradient color for selected items
    final selectedGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor,
        secondaryColor,
      ],
    );

    // Create a pulsing glow animation controller
    final glowAnimation = Tween<double>(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Animation for the selected item
    Widget iconWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: containerSize,
      width: containerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected ? selectedGradient : null,
        color: isSelected
            ? null
            : isDarkMode
                ? AppTheme.secondaryDark.withOpacity(0.7)
                : Colors.white,
        boxShadow: isSelected
            ? [
                // Enhanced shadow for glow effect
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(
        isSelected ? activeIcon : icon,
        color: isSelected
            ? isDarkMode
                ? AppTheme.primaryDark
                : Colors.white
            : isDarkMode
                ? AppTheme.textPrimary.withOpacity(0.7)
                : AppTheme.textPrimaryLight.withOpacity(0.7),
        size: iconSize,
      ),
    );

    if (isSelected) {
      // Scale animation for selection feedback
      final scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.2),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.2, end: 1.0),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      );

      // Apply scale animation to icon
      iconWidget = ScaleTransition(
        scale: scaleAnimation,
        child: iconWidget,
      );

      // Add additional glowing container when selected
      iconWidget = Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow layer that pulses with the animation
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Container(
                width: containerSize + 16,
                height: containerSize + 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(glowAnimation.value),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color:
                          secondaryColor.withOpacity(glowAnimation.value * 0.5),
                      blurRadius: 25,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            },
          ),
          // The actual icon widget
          iconWidget,
        ],
      );
    }

    // Use smaller font on smaller screens
    final fontSize = size.width < 360 ? 9.0 : 10.0;

    return InkWell(
      onTap: () => onItemTapped(index),
      customBorder: const CircleBorder(),
      splashColor: primaryColor.withOpacity(0.1),
      highlightColor: primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            if (!isSelected) // Only show label if not selected for cleaner UI
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize,
                    height: 1.0, // Reduce line height as much as possible
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final walletProvider = Provider.of<WalletProvider>(context);
    final marketProvider = Provider.of<MarketProvider>(context);

    // Calculate total tokens
    final hasWallet = walletProvider.hasWallet;
    final tokenBalance = marketProvider.tokenBalance;
    final citizenTokenBalance = marketProvider.citizenTokenBalance;
    final totalTokens = tokenBalance + citizenTokenBalance;

    return Scaffold(
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
              SliverAppBar(
                pinned: true,
                title: const Text('Dashboard'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  // Use Consumer to properly listen to ThemeProvider changes
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                        ),
                        onPressed: () {
                          // Use Provider.of with listen: false for method calls
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                        },
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        icon: Icons.dashboard,
                        title: 'Dashboard Overview',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildPremiumCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.accentTeal.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.bar_chart_rounded,
                                      size: 28,
                                      color: AppTheme.accentTeal,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CarbonX Dashboard',
                                          style: theme.textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Track your impact and manage your carbon assets',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: isDarkMode
                                                ? AppTheme.textSecondary
                                                : AppTheme.textSecondaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.black12
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDarkMode
                                        ? Colors.white10
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildDashboardStat(
                                      label: 'Activities',
                                      value: '0',
                                      icon: Icons.checklist_rounded,
                                      isDarkMode: isDarkMode,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: isDarkMode
                                          ? Colors.white10
                                          : Colors.grey.shade200,
                                    ),
                                    _buildDashboardStat(
                                      label: 'Reports',
                                      value: '0',
                                      icon: Icons.description_outlined,
                                      isDarkMode: isDarkMode,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: isDarkMode
                                          ? Colors.white10
                                          : Colors.grey.shade200,
                                    ),
                                    _buildDashboardStat(
                                      label: 'Rewards',
                                      value: '0',
                                      icon: Icons.workspace_premium_outlined,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.insights,
                        title: 'Your Carbon Stats',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),

                      // Token Balance Card - Display prominently at the top of stats
                      if (hasWallet)
                        _buildPremiumCard(
                          child: _buildTokenBalanceCard(
                            regularTokens: tokenBalance,
                            citizenTokens: citizenTokenBalance,
                            isDarkMode: isDarkMode,
                          ),
                          isDarkMode: isDarkMode,
                          gradientColors: isDarkMode
                              ? [
                                  AppTheme.accentTeal.withOpacity(0.3),
                                  AppTheme.accentLime.withOpacity(0.1),
                                ]
                              : [
                                  AppTheme.accentTeal.withOpacity(0.1),
                                  AppTheme.accentLime.withOpacity(0.05),
                                ],
                        ),

                      if (hasWallet) const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildPremiumCard(
                              child: _buildStatCard(
                                icon: Icons.eco,
                                title: 'Carbon Savings',
                                value: '0.0 Tonnes',
                                isDarkMode: isDarkMode,
                                iconColor: AppTheme.accentLime,
                              ),
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPremiumCard(
                              child: _buildStatCard(
                                icon: Icons.account_balance,
                                title: 'Credits Owned',
                                value: '0',
                                isDarkMode: isDarkMode,
                                iconColor: AppTheme.accentTeal,
                              ),
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildPremiumCard(
                        child: _buildStatCard(
                          icon: Icons.timeline,
                          title: 'Carbon Footprint Reduction',
                          value: '0%',
                          subtitle: 'Start tracking to see your progress',
                          isDarkMode: isDarkMode,
                          iconColor: Colors.orange,
                          isWide: true,
                        ),
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.access_time,
                        title: 'Recent Activity',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildPremiumCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 40,
                                color: isDarkMode
                                    ? AppTheme.textSecondary
                                    : AppTheme.textSecondaryLight,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Recent Activity',
                                style: theme.textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Your recent actions will appear here',
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 24),
                      _buildPremiumActionButton(
                        icon: Icons.play_arrow_rounded,
                        label: 'Start Tracking Carbon Footprint',
                        color: AppTheme.accentTeal,
                        isDarkMode: isDarkMode,
                        isFilled: true,
                        isWide: true,
                        onPressed: () {
                          // Coming soon functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Coming soon!'),
                              backgroundColor: AppTheme.accentTeal,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenBalanceCard({
    required BigInt regularTokens,
    required BigInt citizenTokens,
    required bool isDarkMode,
  }) {
    final totalTokens = regularTokens + citizenTokens;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentTeal.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 24,
                  color: AppTheme.accentTeal,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Tokens',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white
                            : AppTheme.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Your total balance across all accounts',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? AppTheme.textSecondary
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                totalTokens.toString(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentTeal,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Tokens',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Builder(
            builder: (context) {
              return OutlinedButton.icon(
                onPressed: () {
                  // Navigate to market tab (index 1)
                  final homeState =
                      context.findAncestorStateOfType<_HomeScreenState>();
                  if (homeState != null) {
                    homeState._onItemTapped(1);
                  }
                },
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('Trade Tokens'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentTeal,
                  minimumSize: const Size(double.infinity, 44),
                  side: const BorderSide(color: AppTheme.accentTeal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTokenTypeCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.white70,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
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
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppTheme.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    required bool isDarkMode,
    required Color iconColor,
    bool isWide = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isWide ? 24 : 20,
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppTheme.textSecondary
                    : AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDashboardStat({
    required String label,
    required String value,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.accentTeal,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : AppTheme.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode
                ? AppTheme.textSecondary
                : AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
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
              SliverAppBar(
                pinned: true,
                title: const Text('Events'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  // Use Consumer to properly listen to ThemeProvider changes
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                        ),
                        onPressed: () {
                          // Use Provider.of with listen: false for method calls
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                        },
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        icon: Icons.eco,
                        title: 'Environmental Projects',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildPremiumCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentLime.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.eco_outlined,
                                  size: 64,
                                  color: AppTheme.accentLime,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Events Coming Soon',
                                style: theme.textTheme.headlineSmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Explore and support eco-friendly projects that make a real difference. Contribute to verified carbon offset initiatives around the world.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDarkMode
                                      ? AppTheme.textSecondary
                                      : AppTheme.textSecondaryLight,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              // Add Host Event Button
                              const SizedBox(height: 32),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.accentTeal,
                                      AppTheme.accentLime
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppTheme.accentTeal.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // Navigate to the CreateEventScreen when clicked
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateEventScreen(),
                                        ),
                                      ).then((result) {
                                        if (result == true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Cleanup event created successfully!'),
                                              backgroundColor:
                                                  AppTheme.accentTeal,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 24,
                                              color: isDarkMode
                                                  ? AppTheme.primaryDark
                                                  : Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'HOST EVENT',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode
                                                    ? AppTheme.primaryDark
                                                    : Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.category_outlined,
                        title: 'Event Categories',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildEventCategoryCard(
                        title: 'Reforestation',
                        description:
                            'Tree planting and forest restoration projects',
                        icon: Icons.forest,
                        color: Colors.green.shade700,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildEventCategoryCard(
                        title: 'Renewable Energy',
                        description:
                            'Solar, wind, and other clean energy initiatives',
                        icon: Icons.solar_power,
                        color: Colors.amber.shade700,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildEventCategoryCard(
                        title: 'Ocean Conservation',
                        description:
                            'Protecting marine ecosystems and reducing pollution',
                        icon: Icons.water,
                        color: Colors.blue.shade700,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.location_on_outlined,
                        title: 'Featured Locations',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildLocationCard(
                              name: 'Amazon Rainforest',
                              country: 'Brazil',
                              assetImage: null, // Replace with actual asset
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 12),
                            _buildLocationCard(
                              name: 'Great Barrier Reef',
                              country: 'Australia',
                              assetImage: null, // Replace with actual asset
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 12),
                            _buildLocationCard(
                              name: 'Borneo',
                              country: 'Indonesia',
                              assetImage: null, // Replace with actual asset
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildPremiumActionButton(
                        icon: Icons.notifications_active_outlined,
                        label: 'Get Notified When Events Launch',
                        color: AppTheme.accentLime,
                        isDarkMode: isDarkMode,
                        isFilled: true,
                        isWide: true,
                        onPressed: () {
                          // Coming soon functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'You\'ll be notified when events launch!'),
                              backgroundColor: AppTheme.accentLime,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCategoryCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return _buildPremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppTheme.textPrimary
                          : AppTheme.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDarkMode
                  ? AppTheme.textSecondary
                  : AppTheme.textSecondaryLight,
            ),
          ],
        ),
      ),
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildLocationCard({
    required String name,
    required String country,
    required ImageProvider? assetImage,
    required bool isDarkMode,
  }) {
    return Container(
      width: 160,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode
            ? AppTheme.secondaryDark.withOpacity(0.7)
            : Colors.white.withOpacity(0.8),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.8),
          width: 1,
        ),
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
      child: Stack(
        children: [
          Positioned.fill(
            child: assetImage != null
                ? Image(
                    image: assetImage,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                    child: Icon(
                      Icons.image,
                      size: 30,
                      color: isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    country,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
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

// Common widgets extracted from WalletScreen.dart to be reused across pages
Widget _buildPremiumCard({
  required Widget child,
  required bool isDarkMode,
  List<Color>? gradientColors,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
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
            gradient: gradientColors != null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  )
                : null,
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

Widget _buildSectionHeader({
  required IconData icon,
  required String title,
  required bool isDarkMode,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode
              ? AppTheme.accentTeal
              : AppTheme.primaryDark.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
          ),
        ),
      ],
    ),
  );
}

Widget _buildPremiumActionButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onPressed,
  required bool isDarkMode,
  bool isFilled = false,
  bool isWide = false,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          gradient: isFilled
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                )
              : null,
          color: isFilled
              ? null
              : isDarkMode
                  ? AppTheme.secondaryDark
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isFilled ? 0.3 : 0.1),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
          border: isFilled
              ? null
              : Border.all(
                  color: color.withOpacity(0.5),
                  width: 1.5,
                ),
        ),
        child: Container(
          width: isWide ? double.infinity : null,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isWide ? 14 : 12,
          ),
          child: Row(
            mainAxisSize: isWide ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment:
                isWide ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isFilled ? Colors.white : color,
                size: 20,
              ),
              SizedBox(width: isWide ? 12 : 8),
              Text(
                label,
                style: TextStyle(
                  color: isFilled ? Colors.white : color,
                  fontWeight: FontWeight.w600,
                  fontSize: isWide ? 16 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final authProvider = AuthProvider.of(context);
    final user = authProvider.currentUser;

    return Scaffold(
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
              SliverAppBar(
                pinned: true,
                title: const Text('Profile'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit Profile',
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );

                      if (result == true && context.mounted) {
                        authProvider.refreshUser();
                      }
                    },
                  ),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPremiumCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor:
                                    AppTheme.accentTeal.withOpacity(0.2),
                                backgroundImage: user?.photoUrl != null
                                    ? NetworkImage(user!.photoUrl!)
                                    : null,
                                child: user?.photoUrl == null
                                    ? Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppTheme.accentTeal,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.displayName ?? 'Eco Warrior',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? AppTheme.textPrimary
                                            : AppTheme.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user?.email ?? 'No email provided',
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textSecondary
                                            : AppTheme.textSecondaryLight,
                                      ),
                                    ),
                                    if (user?.bio != null &&
                                        user!.bio!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        user.bio!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: isDarkMode
                                              ? AppTheme.textSecondary
                                              : AppTheme.textSecondaryLight,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        isDarkMode: isDarkMode,
                        gradientColors: isDarkMode
                            ? [
                                AppTheme.primaryDark.withOpacity(0.9),
                                AppTheme.secondaryDark.withOpacity(0.8)
                              ]
                            : [
                                Colors.white.withOpacity(0.9),
                                AppTheme.lightBackground.withOpacity(0.8)
                              ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.settings,
                        title: 'Account Settings',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildProfileMenuCard(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        subtitle: 'Change your personal information',
                        isDarkMode: isDarkMode,
                        onTap: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileEditScreen(),
                            ),
                          );

                          if (result == true && context.mounted) {
                            authProvider.refreshUser();
                          }
                        },
                      ),
                      if (user?.hasWallet == true)
                        _buildProfileMenuCard(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Connected Wallet',
                          subtitle: _formatWalletAddress(user?.walletAddress),
                          isDarkMode: isDarkMode,
                          onTap: () {
                            if (context.mounted) {
                              final homeState = context
                                  .findAncestorStateOfType<_HomeScreenState>();
                              if (homeState != null) {
                                homeState._onItemTapped(3);
                              }
                            }
                          },
                        ),
                      _buildProfileMenuCard(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage notification preferences',
                        isDarkMode: isDarkMode,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Notifications coming soon'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                      _buildProfileMenuCard(
                        icon: Icons.security_outlined,
                        title: 'Security',
                        subtitle: 'Update password and security settings',
                        isDarkMode: isDarkMode,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Security settings coming soon'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.data_usage_outlined,
                        title: 'Usage & Data',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildProfileStatsCard(
                        title: 'Carbon Credits Balance',
                        value: user?.carbonCredits.toString() ?? '0',
                        icon: Icons.shopping_cart_outlined,
                        iconColor: AppTheme.accentTeal,
                        isDarkMode: isDarkMode,
                      ),
                      _buildProfileStatsCard(
                        title: 'Carbon Footprint',
                        value: user?.carbonFootprint != null
                            ? '${user?.carbonFootprint.toStringAsFixed(1)} Tonnes'
                            : '0.0 Tonnes',
                        icon: Icons.eco_outlined,
                        iconColor: AppTheme.accentLime,
                        isDarkMode: isDarkMode,
                      ),
                      _buildProfileStatsCard(
                        title: 'Offset Percentage',
                        value: user?.offsetPercentage != null
                            ? '${user?.offsetPercentage}%'
                            : '0%',
                        icon: Icons.leaderboard_outlined,
                        iconColor: Colors.orange,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.help_outline,
                        title: 'Support',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildProfileMenuCard(
                        icon: Icons.help_center_outlined,
                        title: 'Help Center',
                        subtitle: 'FAQs and support resources',
                        isDarkMode: isDarkMode,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Help Center coming soon'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                      _buildProfileMenuCard(
                        icon: Icons.contact_support_outlined,
                        title: 'Contact Us',
                        subtitle: 'Get in touch with our support team',
                        isDarkMode: isDarkMode,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Contact form coming soon'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildPremiumActionButton(
                        icon: Icons.logout,
                        label: 'Sign Out',
                        color: Colors.red.shade700,
                        isDarkMode: isDarkMode,
                        isFilled: false,
                        isWide: true,
                        onPressed: () => _signOut(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWalletAddress(String? address) {
    if (address == null || address.isEmpty) {
      return '';
    }

    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }

    return address;
  }

  void _signOut(BuildContext context) async {
    final authProvider = AuthProvider.of(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await authProvider.signOut();

      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildProfileMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: _buildPremiumCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppTheme.primaryDark.withOpacity(0.5)
                        : AppTheme.accentTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppTheme.accentTeal.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: AppTheme.accentTeal,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AppTheme.textPrimary
                              : AppTheme.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode
                              ? AppTheme.textSecondary
                              : AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isDarkMode
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryLight,
                ),
              ],
            ),
          ),
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  Widget _buildProfileStatsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: _buildPremiumCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppTheme.textSecondary
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppTheme.textPrimary
                            : AppTheme.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        isDarkMode: isDarkMode,
      ),
    );
  }
}
