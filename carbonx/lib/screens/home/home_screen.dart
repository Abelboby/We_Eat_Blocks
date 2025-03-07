import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_provider.dart';
import '../../services/auth_provider.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../profile/profile_edit_screen.dart';
import '../authentication/login_screen.dart';
import '../../widgets/animated_bar_indicator.dart';

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
      duration: const Duration(milliseconds: 300),
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
    final isDarkMode = ThemeProvider.of(context).isDarkMode;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            animationController: _animationController,
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final AnimationController animationController;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: 'Dashboard',
              index: 0,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.store_outlined,
              activeIcon: Icons.store,
              label: 'Marketplace',
              index: 1,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.eco_outlined,
              activeIcon: Icons.eco,
              label: 'Projects',
              index: 2,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet,
              label: 'Wallet',
              index: 3,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
              index: 4,
            ),
          ],
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

    // Animation for the selected item
    Widget iconWidget = Icon(
      isSelected ? activeIcon : icon,
      color: isSelected
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurface.withOpacity(0.6),
      size: 24,
    );

    if (isSelected) {
      final animation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut,
        ),
      );

      iconWidget = ScaleTransition(
        scale: animation,
        child: iconWidget,
      );
    }

    return InkWell(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isSelected ? 8 : 0),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: iconWidget,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: isSelected ? 12 : 11,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedBarIndicator(
              isActive: isSelected,
              color: theme.colorScheme.primary,
              width: 20,
              height: 3,
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
