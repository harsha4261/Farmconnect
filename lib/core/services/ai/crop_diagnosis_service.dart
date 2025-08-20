import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../../app_config.dart';

class CropDiagnosisService {
  final GenerativeModel? _model;

  CropDiagnosisService()
      : _model = (AppConfig.instance?.geminiApiKey?.isNotEmpty ?? false)
            ? GenerativeModel(
                model: 'gemini-1.5-flash',
                apiKey: AppConfig.instance!.geminiApiKey!,
              )
            : null;

  Future<String?> diagnoseFromImage(XFile image, {String locale = 'en'}) async {
    if (_model == null) return 'AI not configured. Add GEMINI_API_KEY in env.json.';

    final bytes = await File(image.path).readAsBytes();
    final prompt = Content.multi([
      TextPart(
          'You are an agronomy expert. Identify the plant disease (if any) in this photo and give concise treatment advice. Reply in $locale. Keep it under 120 words.'),
      DataPart('image/jpeg', bytes),
    ]);
    final response = await _model.generateContent([prompt]);
    return response.text;
  }
}


