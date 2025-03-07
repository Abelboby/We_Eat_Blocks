import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './wallet_qr_scanner.dart';

class ImportWalletDialog extends StatefulWidget {
  final String title;
  final String buttonLabel;

  const ImportWalletDialog({
    super.key,
    this.title = 'Import Wallet',
    this.buttonLabel = 'Import',
  });

  @override
  State<ImportWalletDialog> createState() => _ImportWalletDialogState();
}

class _ImportWalletDialogState extends State<ImportWalletDialog> {
  final _privateKeyController = TextEditingController();
  bool _isPrivateKeyValid = true;
  bool _obscureText = true;

  void _handleQRScan() async {
    final privateKey = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => WalletQRScanner(
          onDetect: (value) => value,
        ),
      ),
    );

    if (privateKey != null && privateKey.isNotEmpty) {
      setState(() {
        _privateKeyController.text = privateKey;
        _isPrivateKeyValid = true;
      });
    }
  }

  bool _validatePrivateKey(String privateKey) {
    // Remove '0x' prefix if it exists
    final cleanKey = privateKey.toLowerCase().startsWith('0x')
        ? privateKey.substring(2)
        : privateKey;

    // Check if it's a valid hex string of correct length (64 characters = 32 bytes)
    if (cleanKey.length != 64) return false;

    // Check if it contains only valid hex characters
    return RegExp(r'^[0-9a-f]{64}$').hasMatch(cleanKey);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: theme.primaryColor),
          const SizedBox(width: 8),
          Text(widget.title),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your wallet private key to import your existing wallet.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _privateKeyController,
                  decoration: InputDecoration(
                    labelText: 'Private Key',
                    errorText: _isPrivateKeyValid
                        ? null
                        : 'Invalid private key format',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          tooltip: _obscureText ? 'Show' : 'Hide',
                        ),
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: _handleQRScan,
                          tooltip: 'Scan QR Code',
                        ),
                      ],
                    ),
                  ),
                  obscureText: _obscureText,
                  maxLines: _obscureText ? 1 : 2,
                  onChanged: (value) {
                    // Validate on each change but don't show error immediately
                    if (!_isPrivateKeyValid && _validatePrivateKey(value)) {
                      setState(() {
                        _isPrivateKeyValid = true;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Never share your private key with anyone. It gives full access to your wallet.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final privateKey = _privateKeyController.text.trim();
            if (_validatePrivateKey(privateKey)) {
              Navigator.pop(context, privateKey);
            } else {
              setState(() => _isPrivateKeyValid = false);
            }
          },
          child: Text(widget.buttonLabel),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }
}
