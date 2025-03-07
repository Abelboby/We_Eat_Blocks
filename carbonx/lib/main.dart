import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/theme_provider.dart';
import 'services/auth_service.dart';
import 'services/auth_provider.dart';
import 'services/user_service.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create services
  final userService = UserService();
  final authService = AuthService();

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
