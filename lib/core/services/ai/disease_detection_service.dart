import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../../app_config.dart';

class DiseaseDetectionService {
  final GenerativeModel? _vision;

  DiseaseDetectionService()
      : _vision = (AppConfig.instance?.geminiApiKey?.isNotEmpty ?? false)
            ? GenerativeModel(
                model: 'gemini-1.5-pro-vision',
                apiKey: AppConfig.instance!.geminiApiKey!,
              )
            : null;

  Future<String?> detect(XFile image, {String crop = 'crop', String locale = 'en'}) async {
    if (_vision == null) return 'AI not configured. Add GEMINI_API_KEY.';
    final bytes = await File(image.path).readAsBytes();
    final prompt = Content.multi([
      TextPart('Identify likely diseases on $crop from this photo and give treatment steps. Reply in $locale.'),
      DataPart('image/jpeg', bytes),
    ]);
    final response = await _vision.generateContent([prompt]);
    return response.text;
  }
}



