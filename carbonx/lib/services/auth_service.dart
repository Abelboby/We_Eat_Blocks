import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      _currentUser != null && _currentUser!.isAuthenticated;

  // Constructor to initialize the service and listen for auth changes
  AuthService() {
    _initializeAuth();
  }

  // Initialize and listen to auth changes
  void _initializeAuth() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        try {
          // First get basic user data from Firebase Auth
          _currentUser = UserModel.fromFirebase(user);
          notifyListeners();

          // Then try to get complete user data from Firestore
          final firestoreUser =
              await _userService.getUserFromFirestore(user.uid);
          if (firestoreUser != null) {
            _currentUser = firestoreUser;
          } else {
            // If user doesn't exist in Firestore yet, save them
            await _userService.saveUserToFirestore(user);
            // Then get the fresh data
            final newUser = await _userService.getUserFromFirestore(user.uid);
            if (newUser != null) {
              _currentUser = newUser;
            }
          }
        } catch (e) {
          debugPrint('Error in auth state change: $e');
          // Keep the basic user model if Firestore operations fail
        } finally {
          notifyListeners();
        }
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailPassword(
      String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _userService.saveUserToFirestore(userCredential.user!);
        final firestoreUser =
            await _userService.getUserFromFirestore(userCredential.user!.uid);
        _currentUser =
            firestoreUser ?? UserModel.fromFirebase(userCredential.user!);
      }

      _setLoading(false);
      return _currentUser;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with Google - main method that tries different approaches
  Future<UserModel?> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      debugPrint("Starting Google Sign-In with platform-specific approach");

      // Try different approaches based on platform
      if (kIsWeb) {
        // Web approach
        return await _signInWithGoogleWeb();
      } else {
        // Mobile approach
        try {
          final user = await _signInWithGoogleMobile();
          return user;
        } catch (e) {
          debugPrint("Mobile sign-in failed with: $e");
          debugPrint("Trying alternative approach...");

          // If the standard approach fails, try a more direct approach
          try {
            // Create a minimal credential directly
            final googleProvider = GoogleAuthProvider();
            googleProvider.addScope('email');
            googleProvider.addScope('profile');

            // Sign in directly with Firebase
            final userCredential =
                await _auth.signInWithProvider(googleProvider);

            // Create minimal user directly
            _currentUser = UserModel(
              id: userCredential.user?.uid ?? '',
              displayName: userCredential.user?.displayName,
              email: userCredential.user?.email,
              photoUrl: userCredential.user?.photoURL,
              provider: 'google.com',
            );

            return _currentUser;
          } catch (finalError) {
            debugPrint("All Google Sign-In approaches failed: $finalError");
            _setError("Authentication failed: Unable to sign in with Google.");
            return null;
          }
        }
      }
    } catch (e) {
      debugPrint("Unexpected error in Google Sign-In: $e");
      _setError('Authentication failed: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Web-specific implementation
  Future<UserModel?> _signInWithGoogleWeb() async {
    try {
      _setLoading(true);
      _clearError();

      // Create a Google auth provider
      final googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      // Try sign in with popup first
      try {
        final userCredential = await _auth.signInWithPopup(googleProvider);
        final user = userCredential.user;

        if (user == null) {
          _setError('Failed to get user details from Firebase');
          return null;
        }

        // Create basic user model
        final basicUser = UserModel(
          id: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
          provider: 'google.com',
        );

        // Save user to Firestore
        await _userService.saveUserToFirestore(user);

        // Set current user
        _currentUser = basicUser;
        return basicUser;
      } catch (popupError) {
        debugPrint('Popup sign-in failed, trying redirect: $popupError');

        // If popup fails, try redirect
        try {
          await _auth.signInWithRedirect(googleProvider);
          final result = await _auth.getRedirectResult();
          final user = result.user;

          if (user == null) {
            _setError('Failed to get user details from redirect sign-in');
            return null;
          }

          // Create basic user model
          final basicUser = UserModel(
            id: user.uid,
            displayName: user.displayName,
            email: user.email,
            photoUrl: user.photoURL,
            provider: 'google.com',
          );

          // Save user to Firestore
          await _userService.saveUserToFirestore(user);

          // Set current user
          _currentUser = basicUser;
          return basicUser;
        } catch (redirectError) {
          debugPrint('Redirect sign-in failed: $redirectError');
          _setError('Authentication failed: ${redirectError.toString()}');
          return null;
        }
      }
    } catch (e) {
      debugPrint('Web Google Sign-In failed: $e');
      _setError('Authentication failed: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);

    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      _currentUser = null;
    } catch (e) {
      _setError('Error signing out: $e');
    }

    _setLoading(false);
  }

  // Refresh current user data from Firestore
  Future<void> refreshCurrentUser() async {
    final currentFirebaseUser = _auth.currentUser;
    if (currentFirebaseUser == null) {
      _currentUser = null;
      return;
    }

    try {
      final userId = currentFirebaseUser.uid;
      final updatedUser = await _userService.getUserFromFirestore(userId);

      if (updatedUser != null) {
        _currentUser = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error refreshing user data: $e');
      // Don't set error because this is a background operation
    }
  }

  // Get the latest user data from Firestore
  Future<void> refreshUserData() async {
    try {
      if (_auth.currentUser != null) {
        final firestoreUser =
            await _userService.getUserFromFirestore(_auth.currentUser!.uid);
        if (firestoreUser != null) {
          _currentUser = firestoreUser;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error refreshing user data: $e');
    }
  }

  // Stream of current user data
  Stream<UserModel?> get userStream {
    if (_auth.currentUser == null) {
      return Stream.value(null);
    }
    return _userService.userStream(_auth.currentUser!.uid);
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _handleAuthError(FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No user found with this email.';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is invalid.';
        break;
      case 'user-disabled':
        errorMessage = 'This user account has been disabled.';
        break;
      case 'account-exists-with-different-credential':
        errorMessage =
            'An account already exists with the same email but different sign-in credentials.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'This sign-in operation is not allowed.';
        break;
      case 'weak-password':
        errorMessage = 'The password is too weak.';
        break;
      case 'network-request-failed':
        errorMessage = 'Network error. Please check your connection.';
        break;
      default:
        errorMessage = e.message ?? 'An unknown error occurred.';
    }

    _setError(errorMessage);
  }

  // Sign in with Google - mobile fallback method
  Future<UserModel?> _signInWithGoogleMobile() async {
    try {
      _setLoading(true);
      _clearError();

      // Initialize GoogleSignIn with proper scopes
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );

      // Try to get the Google user
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // If user canceled the sign-in
      if (googleUser == null) {
        _setError('Sign in cancelled by user');
        return null;
      }

      try {
        // Get authentication tokens
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase
        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user == null) {
          _setError('Failed to get user details from Firebase');
          return null;
        }

        // Create basic user model directly
        final basicUser = UserModel(
          id: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
          provider: 'google.com',
        );

        // Save user to Firestore
        await _userService.saveUserToFirestore(user);

        // Set current user
        _currentUser = basicUser;
        return basicUser;
      } catch (authError) {
        debugPrint('Firebase authentication error: $authError');
        _setError('Authentication failed: ${authError.toString()}');
        // Sign out from Google
        await googleSignIn.signOut();
        return null;
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      _setError('Sign in failed: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Utility method to retry operations that might fail temporarily
  Future<T?> _retryOperation<T>(Future<T?> Function() operation,
      {int maxRetries = 3}) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final result = await operation();
        return result; // Return on success
      } catch (e) {
        debugPrint('Operation failed (attempt ${attempt + 1}/$maxRetries): $e');

        if (attempt == maxRetries - 1) {
          // This was the last attempt, rethrow the error
          rethrow;
        }

        // Wait before retrying (use exponential backoff)
        await Future.delayed(Duration(milliseconds: 300 * (attempt + 1)));
      }
    }
    return null; // Should never reach here, but return null just in case
  }
}
