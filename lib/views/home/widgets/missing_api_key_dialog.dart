import 'package:flutter/material.dart';

import '../../settings/settings_screen.dart';

class MissingApiKeyDialog extends StatelessWidget {
  const MissingApiKeyDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('API Key needed'),
      content: const Text(
        'You need to provide an API Key to use this feature. '
        'Visit Settings for more information',
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          child: const Text(
            'Go to Settings',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
