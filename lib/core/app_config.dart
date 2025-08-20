import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  final String? supabaseUrl;
  final String? supabaseAnonKey;
  final String? openaiApiKey;
  final String? geminiApiKey;
  final String? anthropicApiKey;
  final String? perplexityApiKey;

  const AppConfig({
    this.supabaseUrl,
    this.supabaseAnonKey,
    this.openaiApiKey,
    this.geminiApiKey,
    this.anthropicApiKey,
    this.perplexityApiKey,
  });

  static AppConfig? _instance;

  static AppConfig? get instance => _instance;

  static Future<void> load() async {
    try {
      final raw = await rootBundle.loadString('env.json');
      final jsonMap = json.decode(raw) as Map<String, dynamic>;
      _instance = AppConfig(
        supabaseUrl: jsonMap['SUPABASE_URL'] as String?,
        supabaseAnonKey: jsonMap['SUPABASE_ANON_KEY'] as String?,
        openaiApiKey: jsonMap['OPENAI_API_KEY'] as String?,
        geminiApiKey: jsonMap['GEMINI_API_KEY'] as String?,
        anthropicApiKey: jsonMap['ANTHROPIC_API_KEY'] as String?,
        perplexityApiKey: jsonMap['PERPLEXITY_API_KEY'] as String?,
      );
    } catch (_) {
      _instance = const AppConfig();
    }
  }
}


