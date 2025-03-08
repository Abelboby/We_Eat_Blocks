import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/market_provider.dart';
import '../../../theme/app_theme.dart';

class SellTokensSection extends StatefulWidget {
  const SellTokensSection({Key? key}) : super(key: key);

  @override
  _SellTokensSectionState createState() => _SellTokensSectionState();
}

class _SellTokensSectionState extends State<SellTokensSection> {
  final TextEditingController _amountController = TextEditingController();
  BigInt _estimatedEthAmount = BigInt.zero;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateEstimatedEth);
  }

  @override
  void dispose() {
    _amountController.removeListener(_updateEstimatedEth);
    _amountController.dispose();
    super.dispose();
  }

  void _updateEstimatedEth() {
    final marketProvider = Provider.of<MarketProvider>(context, listen: false);
    try {
      if (_amountController.text.isNotEmpty) {
        final amount = BigInt.parse(_amountController.text);
        setState(() {
          _estimatedEthAmount = marketProvider.calculateEstimatedEth(amount);
        });
      } else {
        setState(() {
          _estimatedEthAmount = BigInt.zero;
        });
      }
    } catch (e) {
      setState(() {
        _estimatedEthAmount = BigInt.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<MarketProvider>(
      builder: (context, marketProvider, child) {
        final tokenBalance = marketProvider.tokenBalance;
        final citizenTokenBalance = marketProvider.citizenTokenBalance;
        final totalTokens = tokenBalance + citizenTokenBalance;
        final tokenSellPrice = marketProvider.tokenSellPrice;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sell,
                      color: AppTheme.accentTeal,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sell Carbon Tokens',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.accentTeal.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Available Tokens:',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          totalTokens.toString(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentTeal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                // Container(
                //   padding: const EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     color: theme.primaryColor.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         'Your Token Balance:',
                //         style: theme.textTheme.bodyLarge,
                //       ),
                //       Text(
                //         tokenBalance.toString(),
                //         style: theme.textTheme.bodyLarge?.copyWith(
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 12.0),
                // Container(
                //   padding: const EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     color: theme.primaryColor.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   // child: Row(
                //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   //   // children: [
                //   //   //   //Text(
                //   //   //   //  'Your Citizen Token Balance:',
                //   //   //   //  style: theme.textTheme.bodyLarge,
                //   //   //   //),
                //   //   //   Flexible(
                //   //   //     child: Text(
                //   //   //       citizenTokenBalance.toString(),
                //   //   //       style: theme.textTheme.bodyLarge?.copyWith(
                //   //   //         fontWeight: FontWeight.bold,
                //   //   //       ),
                //   //   //       overflow: TextOverflow.ellipsis,
                //   //   //     ),
                //   //   //   ),
                //   //   // ],
                //   // ),
                // ),
                // const SizedBox(height: 12.0),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Sell Price:',
                        style: theme.textTheme.bodyLarge,
                      ),
                      Flexible(
                        child: Text(
                          '${tokenSellPrice.toString()} ETH per token',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount to Sell',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter token amount',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _amountController.clear();
                      },
                    ),
                    prefixIcon: const Icon(Icons.token),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.accentTeal.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You will receive:',
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        '$_estimatedEthAmount ETH',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentTeal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (marketProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Text(
                        marketProvider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: marketProvider.isLoading
                        ? null
                        : () => _sellTokens(context, marketProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: marketProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Sell Tokens',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (marketProvider.lastTransactionHash != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Transaction Submitted',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('Transaction Hash:'),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => _openTransactionInExplorer(
                              marketProvider.lastTransactionHash!,
                            ),
                            child: Text(
                              marketProvider.lastTransactionHash!,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              icon: const Icon(Icons.open_in_new),
                              label: const Text('View on Explorer'),
                              onPressed: () => _openTransactionInExplorer(
                                marketProvider.lastTransactionHash!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sellTokens(
      BuildContext context, MarketProvider marketProvider) async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter an amount'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    try {
      final amount = BigInt.parse(_amountController.text);
      final success = await marketProvider.sellTokens(amount);

      if (success && context.mounted) {
        _amountController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tokens sold successfully!'),
            backgroundColor: AppTheme.accentTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid amount: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _openTransactionInExplorer(String hash) async {
    final url = 'https://sepolia.etherscan.io/tx/$hash';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error opening transaction in explorer: $e');
    }
  }
}
