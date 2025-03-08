import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme_provider.dart';
import 'services/auth_service.dart';
import 'services/auth_provider.dart';
import 'services/user_service.dart';
import 'core/services/wallet_service.dart';
import 'core/services/contract_service.dart';
import 'features/wallet/providers/wallet_provider.dart';
import 'features/market/providers/market_provider.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'providers/events_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Get shared preferences for wallet
  final sharedPreferences = await SharedPreferences.getInstance();

  // Create services
  final userService = UserService();
  final authService = AuthService();
  final walletService = WalletService(sharedPreferences);
  final contractService = ContractService();

  runApp(
    MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Auth Services
        Provider<UserService>(create: (_) => userService),
        ChangeNotifierProvider<AuthService>(create: (_) => authService),
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
          update: (context, authService, previous) =>
              previous ?? AuthProvider(authService),
        ),

        // Wallet Services
        Provider<WalletService>(create: (_) => walletService),
        Provider<ContractService>(create: (_) => contractService),
        ChangeNotifierProvider<WalletProvider>(
          create: (context) => WalletProvider(
            context.read<WalletService>(),
            context.read<UserService>(),
          ),
        ),

        // Market Provider
        ChangeNotifierProxyProvider<WalletProvider, MarketProvider>(
          create: (context) => MarketProvider(
            contractService: contractService,
            walletProvider: context.read<WalletProvider>(),
          ),
          update: (context, walletProvider, previous) => MarketProvider(
            contractService: contractService,
            walletProvider: walletProvider,
          ),
        ),

        // Events Provider
        ChangeNotifierProvider<EventsProvider>(
          create: (_) => EventsProvider(),
        ),
      ],
      child: const CarbonXApp(),
    ),
  );
}

class CarbonXApp extends StatelessWidget {
  const CarbonXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'CarbonX',
          theme: themeProvider.themeData,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              // Show HomeScreen if user is authenticated, otherwise show LoginScreen
              return authProvider.isAuthenticated
                  ? const HomeScreen()
                  : const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
