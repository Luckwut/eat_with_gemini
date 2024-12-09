import 'package:flutter/material.dart';

import '../../models/preference_model.dart';
import '../../services/preference_storage.dart';
import 'widgets/preference_text_field.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _preferenceStorage = PreferenceStorage();

  final _dietaryPreferenceTextController = TextEditingController();
  final _healthConsiderationTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  @override
  void dispose() {
    _savePreference();
    super.dispose();
  }

  Future<void> _loadPreference() async {
    final preferences = await _preferenceStorage.getData();
    setState(() {
      _dietaryPreferenceTextController.text = preferences?.dietaryPreference ?? '';
      _healthConsiderationTextController.text =
          preferences?.healthConsideration ?? '';
    });
  }

  void _savePreference() {
    _preferenceStorage.saveData(PreferenceModel(
      dietaryPreference: _dietaryPreferenceTextController.text,
      healthConsideration: _healthConsiderationTextController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _savePreference();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Personal Preferences'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dietary Preferences',
                  style: TextStyle(fontSize: 18.0),
                ),
                const Text('e.g. Pescetarian, Vegetarian, Vegan'),
                const SizedBox(height: 12.0),
                PreferenceTextField(
                  textController: _dietaryPreferenceTextController,
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Health Consideration',
                  style: TextStyle(fontSize: 18.0),
                ),
                const Text('e.g. Diabetic, Lactose Intolerant, Gluten-Free'),
                const SizedBox(height: 12.0),
                PreferenceTextField(
                  textController: _healthConsiderationTextController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
