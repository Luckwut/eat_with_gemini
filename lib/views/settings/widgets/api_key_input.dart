import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiKeyInput extends StatelessWidget {
  final TextEditingController textController;

  const ApiKeyInput({
    super.key,
    required this.textController,
  });

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://ai.google.dev/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Google Gemini API Key',
          style: TextStyle(fontSize: 18.0),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14.6,
              height: 1.3,
            ),
            children: [
              const TextSpan(
                text:
                    'To use most of the features in this app, you need to provide an API Key. '
                    'If you don\'t have one, you can obtain it by visiting ',
              ),
              TextSpan(
                text: 'ai.google.dev',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = _launchURL,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'API Key',
            border: OutlineInputBorder(),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('(\'|"|`)')),
          ],
        ),
      ],
    );
  }
}
