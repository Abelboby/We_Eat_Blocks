import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class WalletQRScanner extends StatefulWidget {
  final Function(String) onDetect;

  const WalletQRScanner({
    Key? key,
    required this.onDetect,
  }) : super(key: key);

  @override
  State<WalletQRScanner> createState() => _WalletQRScannerState();
}

class _WalletQRScannerState extends State<WalletQRScanner> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanning = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Wallet QR Code'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null &&
                          isValidPrivateKey(barcode.rawValue!)) {
                        widget.onDetect(barcode.rawValue!);
                        Navigator.pop(context, barcode.rawValue);
                        return;
                      }
                    }
                  },
                ),
                if (errorMessage != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.red.withOpacity(0.8),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 100,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Text(
                        'Align QR code within the frame',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          backgroundColor: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isValidPrivateKey(String key) {
    // Remove '0x' prefix if present
    final cleanKey =
        key.toLowerCase().startsWith('0x') ? key.substring(2) : key;

    // Check if it's a valid hex string of correct length (64 characters = 32 bytes)
    if (cleanKey.length != 64) return false;

    // Check if it contains only valid hex characters
    return RegExp(r'^[0-9a-f]{64}$').hasMatch(cleanKey);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
