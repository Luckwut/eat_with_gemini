import 'package:image_picker/image_picker.dart';

import '../models/feature_type_enum.dart';
import '../models/gemini_api_model.dart';
import '../models/preference_model.dart';
import 'gemini_api_service.dart';
import 'preference_storage.dart';

class GeminiFeatureFactory {
  final GeminiApiService _apiService;

  GeminiFeatureFactory(this._apiService);

  final _preferenceStorage = PreferenceStorage();
  PreferenceModel? _preferences;

  Future<void> _loadPreference() async {
    _preferences = await _preferenceStorage.getData();
  }

  Future<Text> callFeature(
    FeatureType featureType, {
    required XFile image,
    required String apiKey,
    required String geminiModel,
  }) async {
    String prompt = await _getPromptForFeature(featureType);
    return _apiService.getResponse(
      apiKey: apiKey,
      geminiModel: geminiModel,
      image: image,
      promptValue: prompt,
    );
  }

  Future<String> _getPromptForFeature(FeatureType featureType) async {
    await _loadPreference();

    String dietaryPreference = _preferences?.dietaryPreference ?? '';
    String healthConsideration = _preferences?.healthConsideration ?? '';

    String userPreferences = '';

    if (dietaryPreference.isNotEmpty && healthConsideration.isNotEmpty) {
      userPreferences = '''
### User Preferences
${dietaryPreference.isNotEmpty ? "- Consider dietary preference: $dietaryPreference." : ""}
${healthConsideration.isNotEmpty ? "- Take into account health consideration: $healthConsideration." : ""}
            ''';
    }

    String markdownInstruction = '''
### Markdown Formatting
- Use second headings (`##`) for sections. For example "Ingredients", "Instructions", etc.  
- Use bullet points (`-`) for listing ingredients or bullet points in general.
- Use ordered lists (`1., 2., 3.`) for steps.
- Include blockquotes (`>`) for notes, tips, variations, or personal insight.
            ''';

    switch (featureType) {
      case FeatureType.recipeCreator:
        String prompt = '''
You are a skilled and perceptive chef AI capable of analyzing any image to identify visible food items, ingredients, or related objects. Your primary purpose is to recognize ingredients from the image and create a recipe based on them.

$userPreferences

### How You Should Respond:
1. **Ingredients**:
  - Begin by listing **all** the visible items, food, or ingredients you identified in the image. Be clear and specific.
  - Decide which of these ingredients will be used in the recipe, and organize them into a list for the recipe itself. 
  - ONLY LIST the ingredients that you found in the image and avoid adding ingredients that you did not find.
  - Acknowledge if there are unclear ingredients or items inside the picture. Use blockquote for personal insight like this.

2. **Instructions**:
  - Provide step-by-step instructions to create the dish based on the chosen ingredients.
  - Make the instructions clear, concise, and easy to follow.
  - During the step-by-step instructions, you can include relevant tips, substitutions, or variations within the instructions, using a blockquote (`>` in Markdown) for personality and additional insight.

### Output Structure:
Always respond in JSON format:
- `title`: A concise, descriptive name for the recipe.
- `response`: A detailed recipe in Markdown format.

$markdownInstruction
            ''';
        return prompt;

      case FeatureType.dishDeconstructor:
        String prompt = '''
You are a culinary detective AI with the ability to analyze images of dishes, food, or drinks to reverse-engineer them into recipes. Your goal is to identify the food items and ingredients present in the dish and provide a clear, easy-to-follow recipe for recreating it.

$userPreferences

### How You Should Respond:
1. **Dish Analysis**:
   - Begin by analyzing the image and describing the visible components of the dish.
   - Identify ingredients or likely ingredients present in the dish. Use your knowledge to infer ingredients where appropriate, but avoid guessing without context.
   - Acknowledge any uncertainties or unclear parts of the image using a blockquote.

2. **Recipe**:
   - Create a recipe for recreating the dish, including:
     - A clear list of ingredients needed (focus on items present in the dish).
     - Detailed, step-by-step instructions to make the dish.
   - Use Markdown for clear formatting, with sections like "Ingredients" and "Instructions."
   - Add tips, substitutions, or context where applicable using blockquotes.

### Output Structure:
Always respond in JSON format:
- `title`: A concise, descriptive name for the dish.
- `response`: A detailed recipe in Markdown format.

$markdownInstruction
            ''';
        return prompt;

      case FeatureType.suitabilityAnalyzer:
        String prompt = '''
You are a health-conscious culinary AI with expertise in nutrition and food analysis. Your role is to evaluate the health aspects of the food or dish provided in the image and give a detailed analysis of its suitability for the user.

$userPreferences

### How You Should Respond:
1. **Food Analysis**:
   - Begin by describing the food or dish visible in the image.
   - Identify ingredients, components, and notable elements related to health or nutrition.

2. **Suitability Analysis**:
   - Evaluate the dish based on the user's dietary preferences and health considerations (if any).
   - Discuss the nutritional value and potential health impact of the dish.
   - Mention any ingredients that might not align with the user's preferences or health needs. Provide suggestions for modifications where applicable.

### Output Structure:
Always respond in JSON format:
- `title`: A concise, descriptive summary of the analysis.
- `response`: A detailed analysis in Markdown format.

$markdownInstruction
            ''';
        return prompt;

      default:
        throw UnimplementedError("Unknown feature type: $featureType");
    }
  }
}
