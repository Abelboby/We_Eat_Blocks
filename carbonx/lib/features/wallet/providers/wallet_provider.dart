import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/wallet_service.dart';
import '../../../services/user_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _walletService;
  final UserService _userService;

  Credentials? _credentials;
  String? _address;
  EtherAmount? _balance;
  bool _isLoading = false;
  String? _error;
  bool _isBalanceLoading = false;
  String? _previousAddress;

  WalletProvider(this._walletService, this._userService) {
    _initWallet();
  }

  bool get hasWallet => _credentials != null;
  String? get address => _address;
  EtherAmount? get balance => _balance;
  bool get isLoading => _isLoading;
  bool get isBalanceLoading => _isBalanceLoading;
  String? get error => _error;
  Credentials? get credentials => _credentials;

  Future<void> _initWallet() async {
    try {
      final privateKey = await _walletService.getStoredPrivateKey();
      if (privateKey != null) {
        await importWallet(privateKey);
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error initializing wallet: $e');
    }
  }

  Future<void> importWallet(String privateKey) async {
    try {
      _setLoading(true);
      _error = null;

      // Store the current address before changing it
      _previousAddress = _address;

      _credentials = await _walletService.importWallet(privateKey);
      _address = (await _credentials!.extractAddress()).hex;

      // Save wallet address to user document
      await _saveWalletAddressToUser();

      await _updateBalance();
    } catch (e) {
      _error = 'Failed to import wallet: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Replace current wallet with a new one in a single operation
  Future<void> replaceWallet(String newPrivateKey) async {
    try {
      _setLoading(true);
      _error = null;

      // Store the current address before changing it
      _previousAddress = _address;

      // First remove the old wallet locally
      await _walletService.removeWallet();

      // Import the new wallet
      _credentials = await _walletService.importWallet(newPrivateKey);
      _address = (await _credentials!.extractAddress()).hex;

      // Update the wallet address in Firebase directly
      // This avoids setting it to empty temporarily
      await _saveWalletAddressToUser(isReplacement: true);

      await _updateBalance();
    } catch (e) {
      _error = 'Failed to replace wallet: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveWalletAddressToUser({bool isReplacement = false}) async {
    if (_address == null) return;

    final userId = _userService.currentUserId;
    if (userId == null) {
      debugPrint('Cannot save wallet address: User not logged in');
      return;
    }

    // Skip update if the address hasn't changed
    if (_previousAddress == _address && !isReplacement) {
      debugPrint('Wallet address unchanged, skipping Firebase update');
      return;
    }

    try {
      // For replacements, add additional data about the replacement
      if (isReplacement && _previousAddress != null) {
        await _userService.updateUserData(userId, {
          'walletAddress': _address,
          'walletConnectedAt': FieldValue.serverTimestamp(),
          'previousWalletAddress': _previousAddress,
          'walletReplacedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Wallet address replaced in user document');
      } else {
        await _userService.updateWalletAddress(userId, _address!);
        debugPrint('Wallet address saved to user document');
      }
    } catch (e) {
      // Just log the error but don't set _error because the wallet import itself succeeded
      debugPrint('Error saving wallet address to user document: $e');
    }
  }

  Future<void> _updateBalance() async {
    if (_address == null) return;

    try {
      _isBalanceLoading = true;
      notifyListeners();

      _balance = await _walletService.getBalance(_address!);
      _error = null;
    } catch (e) {
      _error = 'Failed to update balance: ${e.toString()}';
      debugPrint(_error);
      // Set a zero balance to prevent UI issues
      _balance = EtherAmount.zero();
    } finally {
      _isBalanceLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeWallet() async {
    try {
      _setLoading(true);

      // Store previous address before removing
      _previousAddress = _address;

      await _walletService.removeWallet();

      // Remove wallet address from user document
      await _removeWalletAddressFromUser();

      _credentials = null;
      _address = null;
      _balance = null;
      _error = null;
    } catch (e) {
      _error = 'Failed to remove wallet: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _removeWalletAddressFromUser() async {
    final userId = _userService.currentUserId;
    if (userId == null) {
      debugPrint('Cannot remove wallet address: User not logged in');
      return;
    }

    try {
      // Update Firebase with additional historical data
      await _userService.updateUserData(userId, {
        'walletAddress': '',
        'lastWalletAddress':
            _previousAddress, // Store the last wallet address for history
        'walletDisconnectedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('Wallet address removed from user document');
    } catch (e) {
      debugPrint('Error removing wallet address from user document: $e');
    }
  }

  Future<void> refreshBalance() async {
    _error = null;
    await _updateBalance();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
