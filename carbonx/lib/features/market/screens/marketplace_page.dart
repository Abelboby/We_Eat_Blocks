import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/sell_tokens_section.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_provider.dart';
import '../../wallet/providers/wallet_provider.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final walletProvider = Provider.of<WalletProvider>(context);

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
                title: const Text('Marketplace'),
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
                        icon: Icons.store,
                        title: 'Carbon Credit Marketplace',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),

                      // Show wallet not connected message if no wallet
                      if (!walletProvider.hasWallet)
                        _buildWalletNotConnectedCard(context, isDarkMode),

                      // Show SellTokensSection if wallet is connected
                      if (walletProvider.hasWallet) const SellTokensSection(),

                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.trending_up,
                        title: 'Market Trends',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPremiumCard(
                              child: _buildMarketTrendCard(
                                title: 'Carbon Credit Price',
                                value: '\$25.00',
                                trend: '+2.5%',
                                isDarkMode: isDarkMode,
                                isPositive: true,
                              ),
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPremiumCard(
                              child: _buildMarketTrendCard(
                                title: 'Market Volume',
                                value: '1.2M',
                                trend: '+5.7%',
                                isDarkMode: isDarkMode,
                                isPositive: true,
                              ),
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        icon: Icons.notifications_outlined,
                        title: 'Get Notified',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildPremiumCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Marketplace Updates',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Get updates about new features, token price changes, and market opportunities.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDarkMode
                                      ? AppTheme.textSecondary
                                      : AppTheme.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildPremiumActionButton(
                                icon: Icons.notifications_active_outlined,
                                label: 'Notify Me',
                                color: AppTheme.accentTeal,
                                isDarkMode: isDarkMode,
                                isFilled: true,
                                isWide: true,
                                onPressed: () {
                                  // Coming soon functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'You\'ll receive notifications about marketplace updates!'),
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
                        isDarkMode: isDarkMode,
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

  Widget _buildWalletNotConnectedCard(BuildContext context, bool isDarkMode) {
    return _buildPremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentTeal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 64,
                color: AppTheme.accentTeal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Connect Wallet to Trade',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You need to connect a wallet to buy and sell carbon tokens. Go to the Wallet tab to connect your wallet.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryLight,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildPremiumActionButton(
              icon: Icons.account_balance_wallet,
              label: 'Go to Wallet',
              color: AppTheme.accentTeal,
              isDarkMode: isDarkMode,
              isFilled: true,
              isWide: true,
              onPressed: () {
                // Navigate to wallet tab (index 3)
                // A cleaner approach to navigate without direct state access
                final scaffold = Scaffold.of(context);
                scaffold.context.findAncestorWidgetOfExactType();

                // Just show a message instructing the user to navigate manually
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Please tap on the Wallet icon in the bottom navigation bar'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppTheme.accentTeal.withOpacity(0.2)
                : AppTheme.accentTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.accentTeal,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : AppTheme.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCard({
    required Widget child,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  Colors.grey[900]!,
                  Colors.grey[850]!,
                ]
              : [
                  Colors.white,
                  Colors.grey[50]!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.4)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildMarketTrendCard({
    required String title,
    required String value,
    required String trend,
    required bool isDarkMode,
    required bool isPositive,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color:
                  isDarkMode ? Colors.grey[300] : AppTheme.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
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
    required bool isDarkMode,
    required bool isFilled,
    required bool isWide,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: isWide ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
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
            borderRadius: BorderRadius.circular(12),
            border: isFilled
                ? null
                : Border.all(
                    color: isDarkMode
                        ? color.withOpacity(0.7)
                        : color.withOpacity(0.5),
                    width: 1.5,
                  ),
          ),
          child: Row(
            mainAxisSize: isWide ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment:
                isWide ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isFilled
                    ? Colors.white
                    : isDarkMode
                        ? color.withOpacity(0.9)
                        : color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isFilled
                      ? Colors.white
                      : isDarkMode
                          ? color.withOpacity(0.9)
                          : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
