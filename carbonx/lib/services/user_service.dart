import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Save user to Firestore
  Future<void> saveUserToFirestore(User firebaseUser) async {
    try {
      final userRef = _usersCollection.doc(firebaseUser.uid);
      final userDoc = await userRef.get();

      // Basic user data without complex type casting
      final userData = {
        'uid': firebaseUser.uid,
        'email': firebaseUser.email,
        'displayName': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoURL,
        'provider': 'google.com', // Simplified provider info
      };

      if (!userDoc.exists) {
        // Create new user document with additional data
        await userRef.set({
          ...userData,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'carbonCredits': 50, // Starting credits
          'carbonFootprint': 0.0,
          'offsetPercentage': 0,
        });
      } else {
        // Update existing user with minimal data + timestamp
        await userRef.update({
          ...userData,
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }

      debugPrint(
          "Successfully saved user data to Firestore for: ${firebaseUser.uid}");
    } catch (e) {
      debugPrint('Error saving user to Firestore: $e');
      // Don't rethrow - we want to continue even if Firestore save fails
    }
  }

  // Get user from Firestore
  Future<UserModel?> getUserFromFirestore(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return UserModel.fromFirestore(data, userId);
      }

      return null;
    } catch (e) {
      debugPrint('Error getting user from Firestore: $e');
      return null;
    }
  }

  // Get current user from Firestore
  Future<UserModel?> getCurrentUser() async {
    if (currentUserId == null) return null;
    return getUserFromFirestore(currentUserId!);
  }

  // Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(userId).update(data);
    } catch (e) {
      debugPrint('Error updating user data: $e');
      rethrow;
    }
  }

  // Update carbon credits
  Future<void> updateCarbonCredits(String userId, int credits) async {
    try {
      await _usersCollection.doc(userId).update({
        'carbonCredits': FieldValue.increment(credits),
      });
    } catch (e) {
      debugPrint('Error updating carbon credits: $e');
      rethrow;
    }
  }

  // Update carbon footprint
  Future<void> updateCarbonFootprint(String userId, double footprint) async {
    try {
      await _usersCollection.doc(userId).update({
        'carbonFootprint': footprint,
      });
    } catch (e) {
      debugPrint('Error updating carbon footprint: $e');
      rethrow;
    }
  }

  // Update offset percentage
  Future<void> updateOffsetPercentage(String userId, int percentage) async {
    try {
      await _usersCollection.doc(userId).update({
        'offsetPercentage': percentage,
      });
    } catch (e) {
      debugPrint('Error updating offset percentage: $e');
      rethrow;
    }
  }

  // Update wallet address
  Future<void> updateWalletAddress(String userId, String walletAddress) async {
    try {
      await _usersCollection.doc(userId).update({
        'walletAddress': walletAddress,
        'walletConnectedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('Wallet address updated for user: $userId');
    } catch (e) {
      debugPrint('Error updating wallet address: $e');
      rethrow;
    }
  }

  // Check if user has a wallet connected
  Future<bool> hasConnectedWallet(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return data.containsKey('walletAddress') &&
            data['walletAddress'] != null;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking if user has wallet: $e');
      return false;
    }
  }

  // Stream of user data for real-time updates
  Stream<UserModel?> userStream(String userId) {
    return _usersCollection.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return UserModel.fromFirestore(data, userId);
      }
      return null;
    });
  }

  // Stream of current user data
  Stream<UserModel?> currentUserStream() {
    if (currentUserId == null) {
      return Stream.value(null);
    }
    return userStream(currentUserId!);
  }
}
