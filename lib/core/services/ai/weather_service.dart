import 'package:google_generative_ai/google_generative_ai.dart';
import '../../app_config.dart';

class WeatherForecastResult {
  final String summary;
  final List<Map<String, dynamic>> daily; // [{day, tempMin, tempMax, rainChance}]

  WeatherForecastResult({required this.summary, required this.daily});
}

class WeatherService {
  final GenerativeModel? _model;

  WeatherService()
      : _model = (AppConfig.instance?.geminiApiKey?.isNotEmpty ?? false)
            ? GenerativeModel(
                model: 'gemini-1.5-flash',
                apiKey: AppConfig.instance!.geminiApiKey!,
              )
            : null;

  Future<WeatherForecastResult?> forecast({
    required double lat,
    required double lon,
    String locale = 'en',
  }) async {
    if (_model == null) return null;
    final prompt = Content.text(
        'Provide a concise 3-day agricultural weather forecast for coordinates ($lat, $lon). '
        'Focus on rainfall, temperature extremes, and field work advisories. '
        'Reply in $locale, under 120 words.');
    final response = await _model.generateContent([prompt]);
    final text = response.text ?? '';
    return WeatherForecastResult(summary: text, daily: const []);
  }
}


