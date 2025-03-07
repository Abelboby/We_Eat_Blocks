import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../home/home_screen.dart';

void main() {
  testWidgets('ProfilePage displays user information correctly',
      (WidgetTester tester) async {
    // Create a mock AuthService
    final mockAuthService = AuthService();

    // Create a mock UserService
    final mockUserService = UserService();

    // Create a mock AuthProvider
    final mockAuthProvider = AuthProvider(mockAuthService);

    // Create a mock user
    final mockUser = UserModel(
      id: 'test-id',
      displayName: 'Test User',
      email: 'test@example.com',
      bio: 'This is a test bio',
    );

    // Set up the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Provider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const ProfilePage(),
        ),
      ),
    );

    // Verify that the user's name is displayed
    expect(find.text('Test User'), findsOneWidget);

    // Verify that the user's email is displayed
    expect(find.text('test@example.com'), findsOneWidget);

    // Verify that the user's bio is displayed
    expect(find.text('This is a test bio'), findsOneWidget);
  });
}
