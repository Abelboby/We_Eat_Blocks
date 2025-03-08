import 'package:flutter/material.dart';

/// A central repository for all constants used in the CarbonX application
/// This helps maintain consistency and makes updates easier
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();
}

/// Ethereum Network Constants
class NetworkConstants {
  // Private constructor to prevent instantiation
  NetworkConstants._();

  /// The RPC URL for connecting to the Ethereum network (Sepolia testnet)
  static const String rpcUrl =
      'https://sepolia.infura.io/v3/8e3f90378e12472097f8bb798dad8934';

  /// The deployed contract address for the CarbonX smart contract
  static const String contractAddress =
      '0xb45503b9af7ec3b2bfd58c08daa70926cd4ef539';

  /// The chain ID for the Ethereum network (Sepolia testnet)
  static const int chainId = 11155111;

  /// Etherscan base URL for transaction exploration
  static const String etherscanBaseUrl = 'https://sepolia.etherscan.io';

  /// Gas limit for token transactions
  static const int defaultGasLimit = 300000;
}

/// Theme and UI-related Constants
class UIConstants {
  // Private constructor to prevent instantiation
  UIConstants._();

  /// App Name
  static const String appName = 'CarbonX';

  /// Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  /// Spacing Constants
  static const double spacing1 = 4.0;
  static const double spacing2 = 8.0;
  static const double spacing3 = 16.0;
  static const double spacing4 = 24.0;
  static const double spacing5 = 32.0;
  static const double spacing6 = 48.0;
  static const double spacing7 = 64.0;

  /// Border Radius Constants
  static const double borderRadius1 = 4.0;
  static const double borderRadius2 = 8.0;
  static const double borderRadius3 = 12.0;
  static const double borderRadius4 = 16.0;
  static const double borderRadius5 = 24.0;
  static const double borderRadiusCircular = 100.0;
}

/// Color Constants
class ColorConstants {
  // Private constructor to prevent instantiation
  ColorConstants._();

  /// Main Theme Colors
  static const Color primaryDark = Color(0xFF0F172A);
  static const Color secondaryDark = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color accentTeal = Color(0xFF76EAD7);
  static const Color accentLime = Color(0xFFC4FB6D);

  /// Light Theme Colors
  static const Color primaryLight = Color(0xFFF8FAFC);
  static const Color secondaryLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  /// Background colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0F172A);

  /// Card colors
  static const Color lightCardColor = Colors.white;
  static const Color darkCardColor = Color(0xFF1E293B);
}

/// Text Constants used throughout the app
class TextConstants {
  // Private constructor to prevent instantiation
  TextConstants._();

  /// Dashboard Screen
  static const String dashboardTitle = 'Dashboard';
  static const String dashboardOverview = 'Dashboard Overview';
  static const String carbonStats = 'Your Carbon Stats';
  static const String recentActivity = 'Recent Activity';
  static const String availableTokens = 'Available Tokens';
  static const String totalBalanceSubtitle =
      'Your total balance across all accounts';
  static const String noRecentActivity = 'No Recent Activity';
  static const String actionsWillAppear =
      'Your recent actions will appear here';
  static const String viewAllTransactions = 'View All Transactions';

  /// Marketplace Screen
  static const String marketplaceTitle = 'Marketplace';
  static const String carbonCreditMarketplace = 'Carbon Credit Marketplace';
  static const String marketTrends = 'Market Trends';
  static const String transactionHistory = 'Transaction History';
  static const String noWalletConnected = 'No Wallet Connected';
  static const String connectWalletMessage =
      'Connect a wallet to view your transaction history';
  static const String noTransactionHistory = 'No Transaction History';
  static const String transactionsAppearHere =
      'Your transactions will appear here';
  static const String connectWalletToTrade = 'Connect Wallet to Trade';
  static const String sellTokens = 'Sell Carbon Tokens';

  /// Transaction Types
  static const String buyTransaction = 'Buy';
  static const String sellTransaction = 'Sell';
  static const String mintTransaction = 'Mint';
  static const String unknownTransaction = 'Unknown';

  /// Error Messages
  static const String walletNotConnected = 'Wallet not connected';
  static const String amountGreaterThanZero =
      'Amount must be greater than zero';
  static const String notEnoughTokens = 'Not enough tokens';
  static const String failedToSellTokens = 'Failed to sell tokens';
  static const String failedToLoadMarketData = 'Failed to load market data';
}

/// Transaction Types as defined in the smart contract
class TransactionTypeConstants {
  // Private constructor to prevent instantiation
  TransactionTypeConstants._();

  static const int buy = 0;
  static const int sell = 1;
  static const int mint = 2;
}
