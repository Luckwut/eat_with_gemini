import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/gemini_api_model.dart';

class GeminiApiService {
  final Map<String, String> header = {'Content-Type': 'application/json'};
  final http.Client _client = http.Client();

  Future<Text> getResponse({
    required String apiKey,
    required String geminiModel,
    required XFile image,
    required String promptValue,
  }) async {
    final String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/$geminiModel:generateContent?key=$apiKey';

    try {
      List<int> imageBytes = await image.readAsBytes();
      String base64File = base64.encode(imageBytes);

      final mimeType = _getMimeType(image.path);

      final Map<String, dynamic> responseSchema = {
        "type": "OBJECT",
        "properties": {
          "title": {"type": "STRING"},
          "response": {"type": "STRING"}
        },
        "required": ["title", "response"]
      };

      final data = {
        "contents": [
          {
            "parts": [
              {"text": promptValue},
              {
                "inlineData": {
                  "mimeType": mimeType,
                  "data": base64File,
                }
              }
            ]
          }
        ],
        "generationConfig": {
          "response_mime_type": "application/json",
          "response_schema": responseSchema,
        }
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: header,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> decoded = jsonDecode(response.body);

        Root root = Root.fromJson(decoded);

        return _extractTextProperty(root);
      } else {
        throw Exception(
            'Request failed with status: ${response.statusCode}. Reason: ${response.reasonPhrase}');
      }
    } on SocketException catch (_) {
      throw Exception('Network error. Please check your connection.');
    } on http.ClientException catch (e) {
      throw Exception('HTTP Client Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred: ${e.toString()}');
    }
  }

  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      default:
        return 'image/jpeg';
    }
  }

  Text _extractTextProperty(Root rootResponse) {
    if (rootResponse.candidates.isEmpty) {
      throw Exception('Candidates is Empty');
    }

    Candidate firstCandidate = rootResponse.candidates.first;
    if (firstCandidate.content.parts.isEmpty) {
      throw Exception('Parts is Empty');
    }

    String rawText = firstCandidate.content.parts.first.text;
    Map<String, dynamic> parsedText = jsonDecode(rawText);

    String title = parsedText["title"];
    String responseText = parsedText["response"];

    return Text(title: title, response: responseText);
  }

  void close() {
    _client.close();
  }
}
