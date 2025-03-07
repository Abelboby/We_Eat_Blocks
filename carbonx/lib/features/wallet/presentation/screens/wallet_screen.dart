import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/import_wallet_dialog.dart';
import '../../../../services/user_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Future<void> _importWallet() async {
    final privateKey = await showDialog<String>(
      context: context,
      builder: (context) => const ImportWalletDialog(),
    );

    if (privateKey != null && context.mounted) {
      try {
        final provider = Provider.of<WalletProvider>(context, listen: false);
        await provider.importWallet(privateKey);

        if (context.mounted) {
          if (provider.error != null) {
            _showErrorSnackBar(provider.error!);
          } else {
            final userService =
                Provider.of<UserService>(context, listen: false);
            final userId = userService.currentUserId;

            if (userId != null) {
              final hasConnected = await userService.hasConnectedWallet(userId);
              if (hasConnected) {
                _showSuccessSnackBar(
                    'Wallet successfully connected to your account!');
              } else {
                _showSuccessSnackBar('Wallet imported successfully!');
              }
            } else {
              _showSuccessSnackBar('Wallet imported successfully!');
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          _showErrorSnackBar('Error: $e');
        }
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatEtherAmount(EtherAmount amount) {
    // Convert wei to ether and format to 6 decimal places
    final inEther = amount.getValueInUnit(EtherUnit.ether);
    return inEther.toStringAsFixed(6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, _) {
          if (walletProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!walletProvider.hasWallet) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Wallet Connected',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Import an existing wallet to continue',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _importWallet,
                    icon: const Icon(Icons.add),
                    label: const Text('Import Wallet'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: walletProvider.refreshBalance,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              walletProvider.address ?? 'Unknown',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              if (walletProvider.address != null) {
                                Clipboard.setData(ClipboardData(
                                    text: walletProvider.address!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Address copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            tooltip: 'Copy Address',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Balance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (walletProvider.isBalanceLoading)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Loading balance...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    walletProvider.balance != null
                                        ? '${_formatEtherAmount(walletProvider.balance!)} ETH'
                                        : '0 ETH',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                const Text(
                                  'Sepolia Testnet',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                if (walletProvider.error != null &&
                                    walletProvider.error!.contains('balance'))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Balance may not be accurate due to network issues',
                                      style: TextStyle(
                                        color: Colors.red[300],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: walletProvider.refreshBalance,
                            tooltip: 'Refresh Balance',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await walletProvider.removeWallet();
                        if (context.mounted) {
                          _showSuccessSnackBar('Wallet removed');
                        }
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove Wallet'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
