import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/feature_type_enum.dart';
import '../../models/database_response_model.dart';
import '../../services/gemini_feature_service.dart';
import '../../services/image_handler.dart';
import '../../services/preference_storage.dart';
import '../../services/database_response_helper.dart';
import '../../services/settings_storage.dart';
import '../display_response/response_screen.dart';
import '../user_preference/preferences_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/description_bottom_sheet.dart';
import 'widgets/missing_api_key_dialog.dart';
import 'widgets/response_list_tile.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _settingsStorage = SettingsStorage();
  final _preferenceStorage = PreferenceStorage();
  final _databaseResponseHelper = DatabaseResponseHelper();

  List<DatabaseResponseModel> responses = [];
  FeatureType? _selectedFeature;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadResponseList();
    _loadSettingsAndPreference();
  }

  Future<void> _loadResponseList() async {
    final fetchedResponses = await _databaseResponseHelper.fetchAllResponse();
    setState(() {
      responses = fetchedResponses;
    });
  }

  Future<void> _loadSettingsAndPreference() async {
    await _settingsStorage.getData();
    await _preferenceStorage.getData();
  }

  Future<bool> _checkApiKeyExist() async {
    final settings = await _settingsStorage.getData();
    final apiKey = settings?.apiKey;

    return apiKey != null && apiKey.isNotEmpty;
  }

  Future<void> _onFeatureSelected(FeatureType featureType) async {
    setState(() {
      _selectedFeature = featureType;
      _selectedImage = null;
    });
  }

  Future<void> _handleFeatureSelection(
    BuildContext context, {
    required FeatureType featureType,
    required String imagePath,
    required String description,
  }) async {
    bool isApiKeyExist = await _checkApiKeyExist();

    if (!isApiKeyExist) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const MissingApiKeyDialog();
          },
        );
      }
      return;
    }

    _onFeatureSelected(featureType);

    if (context.mounted) {
      _showDescriptionBottomSheet(
        context: context,
        imagePath: imagePath,
        description: description,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Eat with Gemini'),
        actions: [
          // Go to Preferences
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const PreferencesScreen(),
                ),
              );
            },
          ),
          // Go to Settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: responses.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.question_mark,
                    size: 100.0,
                    color: Colors.grey,
                  ),
                  Text(
                    'Make a Response',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: responses.length,
              itemBuilder: (BuildContext context, int index) {
                final response = responses[index];

                return ResponseListTile(
                  id: response.id ?? 0,
                  title: response.title,
                  createdAt: response.createdAt,
                  featureType: response.featureType,
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 8.0,
        ),
        child: SpeedDial(
          buttonSize: const Size(70.0, 70.0),
          icon: Icons.auto_awesome,
          activeIcon: Icons.keyboard_arrow_down,
          tooltip: 'Interact with Gemini',
          useRotationAnimation: true,
          spacing: 3,
          spaceBetweenChildren: 4,
          children: [
            _buildSpeedDialChild(
              context,
              featureType: FeatureType.recipeCreator,
              icon: Icons.auto_fix_high,
              label: 'Recipe Creator',
              imagePath: 'assets/images/FridgeImage.jpg',
              description: 'Take a picture of your fridge, ingredients, '
                  'or leftovers. The app will analyze the image, '
                  'create a recipe, and suggest ingredients based '
                  'on your preferences and health conditions.',
            ),
            _buildSpeedDialChild(
              context,
              featureType: FeatureType.dishDeconstructor,
              icon: Icons.lunch_dining,
              label: 'Dish Deconstructor',
              imagePath: 'assets/images/FriedRice.jpg',
              description: 'Take a picture of a dish, food, or drink. '
                  'The app will identify the ingredients, create a recipe, '
                  'and suggest alternatives if needed.',
            ),
            _buildSpeedDialChild(
              context,
              featureType: FeatureType.suitabilityAnalyzer,
              icon: Icons.remove_red_eye,
              label: 'Suitability Scanner',
              imagePath: 'assets/images/Salad.jpg',
              description: 'Take a picture of food or drink. '
                  'The app will analyze its nutritional '
                  'value and suitability based on your '
                  'preferences and health conditions, '
                  'then provide a verdict.',
            ),
          ],
        ),
      ),
    );
  }

  Future _showLoadingDialog(
    BuildContext context, {
    String message = "Loading...",
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24.0),
                  Text(message),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future _showErrorDialog(
    BuildContext context, {
    required String errorMessage,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  SpeedDialChild _buildSpeedDialChild(
    BuildContext context, {
    required FeatureType featureType,
    required IconData icon,
    required String label,
    required String imagePath,
    required String description,
  }) {
    return SpeedDialChild(
      shape: const CircleBorder(),
      child: Icon(icon),
      label: label,
      onTap: () => _handleFeatureSelection(
        context,
        featureType: featureType,
        imagePath: imagePath,
        description: description,
      ),
    );
  }

  void _showDescriptionBottomSheet({
    required BuildContext context,
    required String imagePath,
    required String description,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return DescriptionBottomSheet(
          imagePath: imagePath,
          description: description,
          onImageSelected: (XFile image) async {
            setState(() {
              _selectedImage = image;
            });

            // Dismiss the bottom sheet
            if (sheetContext.mounted) Navigator.pop(sheetContext);

            // Then show the loading dialog
            _showLoadingDialog(context);

            // Proceed with the API call
            final geminiFeatureService = GeminiFeatureService();
            final imageHandler = ImageHandler();

            try {
              if (_selectedFeature == null || _selectedImage == null) {
                throw Exception("Feature or image is null");
              }

              final result = await geminiFeatureService.generateFeature(
                _selectedFeature!,
                _selectedImage!,
              );

              final newRecord = DatabaseResponseModel(
                title: result.title,
                responseData: result.response,
                featureType: _selectedFeature!,
                modelType: _settingsStorage.cachedData!.geminiModel,
                imagePath: await imageHandler.storeImage(_selectedImage!),
                createdAt: DateTime.now(),
              );

              final id =
                  await _databaseResponseHelper.insertResponse(newRecord);

              // Dismiss the loading dialog
              if (context.mounted) Navigator.pop(context);

              // Navigate to ResponseScreen
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResponseScreen(
                      id: id,
                      createdAt: newRecord.createdAt,
                    ),
                  ),
                );
              }

              // Refresh the home page responses
              _loadResponseList();
            } catch (e) {
              if (context.mounted) {
                Navigator.pop(context); // Ensure the loading dialog is closed
              }
              if (context.mounted) {
                await _showErrorDialog(
                  context,
                  errorMessage: e.toString(),
                );
              }
            } finally {
              geminiFeatureService.close();
            }
          },
        );
      },
    );
  }
}
