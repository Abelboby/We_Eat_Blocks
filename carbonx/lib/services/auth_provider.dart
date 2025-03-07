import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import '../models/user_model.dart';

/// A provider for accessing the authentication service throughout the app.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  // Getters to expose properties from the auth service
  UserModel? get currentUser => _authService.currentUser;
  bool get isLoading => _authService.isLoading;
  String? get errorMessage => _authService.errorMessage;
  bool get isAuthenticated => _authService.isAuthenticated;

  // Methods to delegate authentication operations to the service
  Future<UserModel?> signInWithEmailPassword(String email, String password) {
    return _authService.signInWithEmailPassword(email, password);
  }

  Future<UserModel?> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }

  Future<void> signOut() {
    return _authService.signOut();
  }

  // Helper method to access the provider
  static AuthProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<AuthProvider>(context, listen: listen);
  }
}
