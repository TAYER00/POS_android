import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrlButton extends StatelessWidget {
  final String url;

  const LaunchUrlButton({Key? key, required this.url}) : super(key: key);

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Opens in external browser
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // Handle the error appropriately in your UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchURL,
      child: const Text('Open in Browser'),
    );
  }
}