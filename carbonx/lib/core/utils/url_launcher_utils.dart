import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  /// Launch Sepolia etherscan explorer for the given wallet address
  static Future<bool> openWalletExplorer(String address,
      {BuildContext? context}) async {
    final url = Uri.parse('https://sepolia.etherscan.io/address/$address');

    try {
      final result = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      return result;
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open: ${url.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  /// Generic URL launcher with error handling
  static Future<bool> openUrl(String urlString, {BuildContext? context}) async {
    try {
      final url = Uri.parse(urlString);
      final result = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      return result;
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open URL: $urlString'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }
}
