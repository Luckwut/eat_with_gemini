import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreferenceTextField extends StatelessWidget {
  final TextEditingController textController;

  const PreferenceTextField({
    super.key,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('(\'|"|`)')),
      ],
    );
  }
}
