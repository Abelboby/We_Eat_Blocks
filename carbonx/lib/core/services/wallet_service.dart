import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class WalletService {
  static const String _privateKeyKey = 'private_key';
  static const String _rpcUrl =
      'https://sepolia.infura.io/v3/8e3f90378e12472097f8bb798dad8934';

  final Web3Client _client;
  final SharedPreferences _prefs;

  WalletService(this._prefs) : _client = Web3Client(_rpcUrl, http.Client());

  Future<Credentials> importWallet(String privateKey) async {
    try {
      // Remove '0x' prefix if it exists
      final cleanKey =
          privateKey.startsWith('0x') ? privateKey.substring(2) : privateKey;

      // Create credentials from private key
      final credentials = EthPrivateKey.fromHex(cleanKey);

      // Extract address (to verify it's a valid key)
      final address = await credentials.extractAddress();
      debugPrint('Wallet imported with address: ${address.hex}');

      // Save private key securely in SharedPreferences
      await _prefs.setString(_privateKeyKey, cleanKey);

      return credentials;
    } catch (e) {
      debugPrint('Error importing wallet: $e');
      throw Exception('Invalid private key');
    }
  }

  Future<String?> getStoredPrivateKey() async {
    return _prefs.getString(_privateKeyKey);
  }

  Future<EtherAmount> getBalance(String address) async {
    try {
      final ethAddress = EthereumAddress.fromHex(address);

      // Add a timeout to prevent hanging
      final balance = await _client.getBalance(ethAddress).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw Exception('Connection timed out'));

      debugPrint('Successfully retrieved balance for $address: $balance');
      return balance;
    } catch (e) {
      debugPrint('Error getting balance: $e');
      // Return zero balance on error instead of throwing to prevent UI errors
      if (e.toString().contains('timeout') ||
          e.toString().contains('connection') ||
          e.toString().contains('network')) {
        debugPrint('Network error, returning zero balance');
        return EtherAmount.zero();
      }
      throw Exception('Failed to retrieve balance');
    }
  }

  Future<void> removeWallet() async {
    await _prefs.remove(_privateKeyKey);
  }

  Future<bool> hasWallet() async {
    return _prefs.containsKey(_privateKeyKey);
  }

  void dispose() {
    _client.dispose();
  }
}
