import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:ui';
import '../../providers/wallet_provider.dart';
import '../../widgets/import_wallet_dialog.dart';
import '../../../../services/user_service.dart';
import '../../../../theme/theme_provider.dart';
import '../../../../theme/app_theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _importWallet() async {
    final privateKey = await showDialog<String>(
      context: context,
      builder: (context) => const ImportWalletDialog(),
    );

    if (privateKey != null && context.mounted) {
      try {
        final provider = Provider.of<WalletProvider>(context, listen: false);
        await provider.importWallet(privateKey);

        if (context.mounted) {
          if (provider.error != null) {
            _showErrorSnackBar(provider.error!);
          } else {
            final userService =
                Provider.of<UserService>(context, listen: false);
            final userId = userService.currentUserId;

            if (userId != null) {
              final hasConnected = await userService.hasConnectedWallet(userId);
              if (hasConnected) {
                _showSuccessSnackBar(
                    'Wallet successfully connected to your account!');
              } else {
                _showSuccessSnackBar('Wallet imported successfully!');
              }
            } else {
              _showSuccessSnackBar('Wallet imported successfully!');
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          _showErrorSnackBar('Error: $e');
        }
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.accentTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  String _formatEtherAmount(EtherAmount amount) {
    // Convert wei to ether and format to 6 decimal places
    final inEther = amount.getValueInUnit(EtherUnit.ether);
    return inEther.toStringAsFixed(6);
  }

  String _shortenAddress(String address) {
    if (address.length > 12) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            isDarkMode ? AppTheme.secondaryDark : AppTheme.accentTeal,
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
        child: Consumer<WalletProvider>(
          builder: (context, walletProvider, _) {
            if (walletProvider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.accentTeal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Loading wallet...',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDarkMode
                            ? AppTheme.textPrimary
                            : AppTheme.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!walletProvider.hasWallet) {
              return _buildNoWalletUI(isDarkMode);
            }

            return RefreshIndicator(
              onRefresh: walletProvider.refreshBalance,
              color: AppTheme.accentTeal,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: AnimatedOpacity(
                  opacity: walletProvider.hasWallet ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wallet Status Card
                      _buildPremiumCard(
                        child: _buildWalletStatusCard(
                            walletProvider, theme, isDarkMode),
                        isDarkMode: isDarkMode,
                        gradientColors: isDarkMode
                            ? [
                                Color(0xFF1B4332).withOpacity(0.9),
                                Color(0xFF052e16).withOpacity(0.8)
                              ]
                            : [
                                Color(0xFFDCFCE7).withOpacity(0.9),
                                Color(0xFFD1FAE5).withOpacity(0.8)
                              ],
                      ),

                      const SizedBox(height: 24),

                      // Wallet Address Card
                      _buildSectionHeader(
                        icon: Icons.account_balance_wallet,
                        title: 'Wallet Address',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildPremiumCard(
                        child: _buildWalletAddressCard(
                            walletProvider, theme, isDarkMode),
                        isDarkMode: isDarkMode,
                      ),

                      const SizedBox(height: 24),

                      // Balance Card
                      _buildSectionHeader(
                        icon: Icons.account_balance,
                        title: 'Balance',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildPremiumCard(
                        child: _buildBalanceCard(
                            walletProvider, theme, isDarkMode),
                        isDarkMode: isDarkMode,
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      _buildSectionHeader(
                        icon: Icons.settings,
                        title: 'Wallet Actions',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildPremiumActionButton(
                              icon: Icons.swap_horiz,
                              label: 'Replace Wallet',
                              color: Colors.orange,
                              isDarkMode: isDarkMode,
                              onPressed: () async {
                                final privateKey = await showDialog<String>(
                                  context: context,
                                  builder: (context) =>
                                      const ImportWalletDialog(
                                    title: 'Replace Wallet',
                                    buttonLabel: 'Replace',
                                  ),
                                );

                                if (privateKey != null && context.mounted) {
                                  try {
                                    final provider =
                                        Provider.of<WalletProvider>(
                                      context,
                                      listen: false,
                                    );

                                    await provider.replaceWallet(privateKey);

                                    if (context.mounted) {
                                      if (provider.error != null) {
                                        _showErrorSnackBar(provider.error!);
                                      } else {
                                        _showSuccessSnackBar(
                                            'Wallet successfully replaced!');
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      _showErrorSnackBar('Error: $e');
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 120, // Fixed width for the Remove button
                            child: _buildPremiumActionButton(
                              icon: Icons.delete_outline,
                              label: 'Remove',
                              color: Colors.red.shade700,
                              isDarkMode: isDarkMode,
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Remove Wallet'),
                                    content: const Text(
                                      'Are you sure you want to disconnect this wallet?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade700,
                                        ),
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true && context.mounted) {
                                  await walletProvider.removeWallet();
                                  if (context.mounted) {
                                    _showSuccessSnackBar('Wallet removed');
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPremiumCard(
      {required Widget child,
      required bool isDarkMode,
      List<Color>? gradientColors}) {
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

  Widget _buildNoWalletUI(bool isDarkMode) {
    return Container(
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo container
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppTheme.secondaryDark : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentTeal.withOpacity(
                              0.1 + _animationController.value * 0.3),
                          spreadRadius: 5,
                          blurRadius: 30 * _animationController.value,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 80,
                      color: AppTheme.accentTeal,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                'Connect Your Wallet',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? AppTheme.textPrimary
                      : AppTheme.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Import your existing wallet to manage your crypto assets and participate in carbon credit trading.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryLight,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              _buildPremiumActionButton(
                icon: Icons.add_circle_outline,
                label: 'Import Wallet',
                color: AppTheme.accentTeal,
                isDarkMode: isDarkMode,
                isFilled: true,
                isWide: true,
                onPressed: _importWallet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletStatusCard(
      WalletProvider walletProvider, ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.green.withOpacity(0.2)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet Connected',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode
                        ? AppTheme.textPrimary
                        : AppTheme.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your wallet is connected to Sepolia Testnet',
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
        ],
      ),
    );
  }

  Widget _buildWalletAddressCard(
      WalletProvider walletProvider, ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _shortenAddress(walletProvider.address ?? 'Unknown'),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode
                      ? AppTheme.textPrimary
                      : AppTheme.textPrimaryLight,
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (walletProvider.address != null) {
                      Clipboard.setData(
                          ClipboardData(text: walletProvider.address!));
                      _showSuccessSnackBar('Address copied to clipboard');
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 20,
                      color: AppTheme.accentTeal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppTheme.primaryDark.withOpacity(0.4)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Text(
              walletProvider.address ?? '',
              style: TextStyle(
                color: isDarkMode
                    ? AppTheme.textSecondary
                    : AppTheme.textSecondaryLight,
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
      WalletProvider walletProvider, ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (walletProvider.isBalanceLoading)
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.accentTeal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Updating...',
                      style: TextStyle(
                        color: AppTheme.accentTeal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        walletProvider.balance != null
                            ? _formatEtherAmount(walletProvider.balance!)
                            : '0.000000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: isDarkMode
                              ? AppTheme.textPrimary
                              : AppTheme.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'ETH',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? AppTheme.textSecondary
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Sepolia Testnet',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
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
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: walletProvider.refreshBalance,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode
                          ? AppTheme.secondaryDark.withOpacity(0.3)
                          : Colors.grey.shade100,
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: AppTheme.accentTeal,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (walletProvider.error != null &&
              walletProvider.error!.contains('balance'))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.shade100,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade400,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Balance may not be accurate due to network issues',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                        ),
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
                  isWide ? MainAxisAlignment.center : MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isFilled ? Colors.white : color,
                  size: 20,
                ),
                SizedBox(width: isWide ? 12 : 8),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isFilled ? Colors.white : color,
                      fontWeight: FontWeight.w600,
                      fontSize: isWide ? 16 : 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
