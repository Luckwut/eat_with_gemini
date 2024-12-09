import 'package:flutter/material.dart';

import '../../models/settings_model.dart';
import '../../services/settings_storage.dart';
import 'widgets/api_key_input.dart';
import 'widgets/gemini_model_dropdown.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsStorage = SettingsStorage();

  final _apiKeyTextController = TextEditingController();
  final List<String> _geminiModelDropdownList = [
    'gemini-1.5-flash',
    'gemini-1.5-pro'
  ];
  // `gemini-1.5-flash` is the default value
  String _dropdownValue = 'gemini-1.5-flash';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _saveSettings();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsStorage.getData();
    setState(() {
      _apiKeyTextController.text = settings?.apiKey ?? '';
      _dropdownValue = settings?.geminiModel ?? 'gemini-1.5-flash';
    });
  }

  void _saveSettings() {
    _settingsStorage.saveData(SettingsModel(
      apiKey: _apiKeyTextController.text,
      geminiModel: _dropdownValue,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _saveSettings();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          /*
           * Added `AlwaysScrollableScrollPhysics` because of :
           * https://github.com/flutter/flutter/issues/104798#issuecomment-1950787631
           */
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ApiKeyInput(
                  textController: _apiKeyTextController,
                ),
                const SizedBox(height: 32.0),
                GeminiModelDropdown(
                  dropdownValue: _dropdownValue,
                  options: _geminiModelDropdownList,
                  onChanged: (String? value) {
                    setState(() {
                      _dropdownValue = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
