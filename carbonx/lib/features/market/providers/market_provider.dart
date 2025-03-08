import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import '../../../core/services/contract_service.dart';
import '../../../features/wallet/providers/wallet_provider.dart';

class MarketProvider extends ChangeNotifier {
  final ContractService _contractService;
  final WalletProvider _walletProvider;

  bool _isLoading = false;
  BigInt _tokenBalance = BigInt.zero;
  BigInt _citizenTokenBalance = BigInt.zero;
  BigInt _tokenSellPrice = BigInt.zero;
  String? _lastTransactionHash;
  String? _errorMessage;
  bool _disposed = false;

  MarketProvider({
    required ContractService contractService,
    required WalletProvider walletProvider,
  })  : _contractService = contractService,
        _walletProvider = walletProvider {
    _loadData();
  }

  bool get isLoading => _isLoading;
  BigInt get tokenBalance => _tokenBalance;
  BigInt get citizenTokenBalance => _citizenTokenBalance;
  BigInt get tokenSellPrice => _tokenSellPrice;
  String? get lastTransactionHash => _lastTransactionHash;
  String? get errorMessage => _errorMessage;

  Future<void> _loadData() async {
    if (_walletProvider.address == null) return;

    try {
      _isLoading = true;
      _safeNotifyListeners();

      _tokenBalance =
          await _contractService.getTokenBalance(_walletProvider.address!);
      _citizenTokenBalance = await _contractService
          .getCitizenTokenBalance(_walletProvider.address!);
      _tokenSellPrice = await _contractService.getTokenSellPrice();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load market data: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Calculate estimated ETH to receive based on token amount and current sell price
  BigInt calculateEstimatedEth(BigInt tokenAmount) {
    return tokenAmount * _tokenSellPrice;
  }

  Future<bool> sellTokens(BigInt amount) async {
    if (_walletProvider.credentials == null) {
      _errorMessage = 'Wallet not connected';
      _safeNotifyListeners();
      return false;
    }

    if (amount <= BigInt.zero) {
      _errorMessage = 'Amount must be greater than zero';
      _safeNotifyListeners();
      return false;
    }

    // Check both regular tokens and citizen tokens
    final totalTokens = _tokenBalance + _citizenTokenBalance;
    if (amount > totalTokens) {
      _errorMessage =
          'Not enough tokens. You have $totalTokens tokens in total.';
      _safeNotifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      _safeNotifyListeners();

      _lastTransactionHash = await _contractService.sellTokens(
        credentials: _walletProvider.credentials!,
        tokenAmount: amount,
      );

      // Refresh token balance after transaction
      await _loadData();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to sell tokens: $e';
      debugPrint(_errorMessage);
      _safeNotifyListeners();
      return false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  void refreshData() {
    _loadData();
  }

  // Clear transaction hash
  void clearTransactionHash() {
    _lastTransactionHash = null;
    _safeNotifyListeners();
  }

  // Safely call notifyListeners() to avoid calling it after dispose
  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
