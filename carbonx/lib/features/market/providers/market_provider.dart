import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import '../../../core/services/contract_service.dart';
import '../../../features/wallet/providers/wallet_provider.dart';

class TokenTransaction {
  final String account;
  final BigInt amount;
  final BigInt price;
  final DateTime timestamp;
  final int txType; // 0: Buy, 1: Sell, 2: Mint

  TokenTransaction({
    required this.account,
    required this.amount,
    required this.price,
    required this.timestamp,
    required this.txType,
  });

  String get typeString {
    switch (txType) {
      case 0: // Buy
        return 'Buy';
      case 1: // Sell
        return 'Sell';
      case 2: // Mint
        return 'Mint';
      default:
        return 'Unknown';
    }
  }

  String get formattedDate {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
  }
}

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
  List<TokenTransaction> _transactionHistory = [];
  DateTime _lastRefreshed = DateTime.now();

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
  List<TokenTransaction> get transactionHistory => _transactionHistory;
  DateTime get lastRefreshed => _lastRefreshed;

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

      // Load transaction history
      await _loadTransactionHistory();

      _lastRefreshed = DateTime.now();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load market data: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> _loadTransactionHistory() async {
    if (_walletProvider.address == null) return;

    try {
      final transactions = await _contractService
          .getTokenTransactionHistory(_walletProvider.address!);

      debugPrint('Transactions data: $transactions');

      _transactionHistory = transactions.map((tx) {
        // Handle tx as a List instead of a Map
        // In Solidity structs, fields are accessed by index, not by name
        final List<dynamic> txData = tx as List<dynamic>;

        return TokenTransaction(
          account: txData[0].toString(), // address field
          amount: txData[1] as BigInt, // amount field
          price: txData[2] as BigInt, // price field
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            (txData[3] as BigInt).toInt() * 1000, // timestamp field
          ),
          txType: (txData[4] as BigInt).toInt(), // txType field (enum as uint8)
        );
      }).toList();

      // Sort by timestamp, most recent first
      _transactionHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      debugPrint('Loaded ${_transactionHistory.length} transactions');
    } catch (e) {
      debugPrint('Error loading transaction history: $e');
      // Add stack trace for better debugging
      debugPrint(StackTrace.current.toString());
      // Don't throw here, just log the error and continue
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

  Future<void> refreshData() async {
    await _loadData();
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
