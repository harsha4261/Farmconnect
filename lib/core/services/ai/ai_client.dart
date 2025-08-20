import 'package:google_generative_ai/google_generative_ai.dart';
import '../../app_config.dart';

class AiClient {
  static GenerativeModel? _geminiModel;

  static GenerativeModel? get gemini {
    if (_geminiModel != null) return _geminiModel;
    final key = AppConfig.instance?.geminiApiKey;
    if (key == null || key.isEmpty) return null;
    _geminiModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: key);
    return _geminiModel;
  }
}


