import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_provider.dart';
import '../../services/auth_provider.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../profile/profile_edit_screen.dart';
import '../authentication/login_screen.dart';
import '../../widgets/animated_bar_indicator.dart';
import 'dart:ui';

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
    const ProjectsPage(),
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
                  label: 'Projects',
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
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text('Dashboard'),
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
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dashboard_customize_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      'Dashboard Coming Soon',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppTheme.spacing2),
                    Text(
                      'Track your carbon footprint and eco-friendly activities',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text('Marketplace'),
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
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      'Marketplace Coming Soon',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppTheme.spacing2),
                    Text(
                      'Buy and sell carbon credits',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text('Projects'),
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
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.eco_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      'Projects Coming Soon',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppTheme.spacing2),
                    Text(
                      'Explore and support eco-friendly projects',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = AuthProvider.of(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              title: const Text('Profile'),
              actions: [
                // Edit profile button
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

                    // Refresh UI if changes were made
                    if (result == true) {
                      authProvider.refreshUser();
                    }
                  },
                ),
                // Theme toggle - using Consumer for proper reactivity
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

            // Profile Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile picture
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.accentTeal.withOpacity(0.2),
                          backgroundImage: user?.photoUrl != null
                              ? NetworkImage(user!.photoUrl!)
                              : null,
                          child: user?.photoUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppTheme.accentTeal,
                                )
                              : null,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileEditScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacing4),

                    // User name
                    Text(
                      user?.displayName ?? 'Eco Warrior',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppTheme.spacing2),

                    // User email
                    Text(
                      user?.email ?? 'No email provided',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),

                    if (user?.bio != null && user!.bio!.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spacing3),
                      Text(
                        user.bio!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const SizedBox(height: AppTheme.spacing5),

                    // Profile Options
                    ..._buildProfileOptions(context),

                    const SizedBox(height: AppTheme.spacing5),

                    // Sign Out Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _signOut(context),
                        icon: const Icon(Icons.logout),
                        label: const Text('Sign Out'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(AppTheme.spacing3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProfileOptions(BuildContext context) {
    final user = AuthProvider.of(context).currentUser;

    return [
      if (user?.hasWallet == true)
        _ProfileOption(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Connected Wallet',
          subtitle: _formatWalletAddress(user?.walletAddress),
          onTap: () {
            // Navigate to wallet tab
            if (context.mounted) {
              final homeState =
                  context.findAncestorStateOfType<_HomeScreenState>();
              if (homeState != null) {
                homeState._onItemTapped(3); // Index 3 is the wallet tab
              }
            }
          },
        ),
      if (user?.hasWallet == true) const SizedBox(height: AppTheme.spacing3),
      _ProfileOption(
        icon: Icons.settings_outlined,
        title: 'Account Settings',
        onTap: () {
          // TODO: Navigate to account settings
        },
      ),
      const SizedBox(height: AppTheme.spacing3),
      _ProfileOption(
        icon: Icons.bar_chart_outlined,
        title: 'Carbon Stats',
        onTap: () {
          // TODO: Navigate to carbon stats
        },
      ),
      const SizedBox(height: AppTheme.spacing3),
      _ProfileOption(
        icon: Icons.history_outlined,
        title: 'Transaction History',
        onTap: () {
          // TODO: Navigate to transaction history
        },
      ),
      const SizedBox(height: AppTheme.spacing3),
      _ProfileOption(
        icon: Icons.notifications_outlined,
        title: 'Notification Settings',
        onTap: () {
          // TODO: Navigate to notification settings
        },
      ),
    ];
  }

  String _formatWalletAddress(String? address) {
    if (address == null || address.isEmpty) {
      return '';
    }

    // Format as 0x1234...5678
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }

    return address;
  }

  void _signOut(BuildContext context) async {
    final authProvider = AuthProvider.of(context, listen: false);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Sign out
    await authProvider.signOut();

    // Close dialog and navigate to login screen
    if (context.mounted) {
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius3),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius3),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: AppTheme.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
