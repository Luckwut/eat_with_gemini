import 'package:flutter/material.dart';

class GeminiModelDropdown extends StatelessWidget {
  final String dropdownValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const GeminiModelDropdown({
    super.key,
    required this.dropdownValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Google Gemini Model',
          style: TextStyle(fontSize: 18.0),
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 14.6,
              height: 1.3,
            ),
            children: [
              TextSpan(
                text: 'The Gemini 1.5 Flash model is fast, '
                    'with low latency and high RPM, making it ideal for '
                    'quick responses and high performance, '
                    'though it offers slightly lower quality.\n',
              ),
              WidgetSpan(
                child: SizedBox(height: 28.0),
              ),
              TextSpan(
                text: 'On the other hand, the Gemini 1.5 Pro model '
                    'provides higher quality results, but with higher '
                    'latency and lower RPM, meaning it may take longer '
                    'to respond and handle fewer requests at once.\n',
              ),
            ],
          ),
        ),
        DropdownButtonFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Gemini Model',
          ),
          isExpanded: true,
          value: dropdownValue,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
