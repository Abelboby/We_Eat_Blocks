import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import '../../../core/services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _walletService;

  Credentials? _credentials;
  String? _address;
  EtherAmount? _balance;
  bool _isLoading = false;
  String? _error;
  bool _isBalanceLoading = false;

  WalletProvider(this._walletService) {
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

      _credentials = await _walletService.importWallet(privateKey);
      _address = (await _credentials!.extractAddress()).hex;
      await _updateBalance();
    } catch (e) {
      _error = 'Failed to import wallet: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _setLoading(false);
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
      await _walletService.removeWallet();
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

  Future<void> refreshBalance() async {
    _error = null;
    await _updateBalance();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
