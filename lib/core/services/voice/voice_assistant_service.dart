import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceAssistantService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  Future<bool> initialize() async {
    final available = await _speech.initialize();
    await _tts.setSpeechRate(0.9);
    return available;
  }

  Future<bool> startListening({
    required void Function(String text) onResult,
    String localeId = 'en_US',
  }) async {
    final didStart = await _speech.listen(
      localeId: localeId,
      onResult: (result) => onResult(result.recognizedWords),
    );
    return didStart;
  }

  Future<void> stopListening() => _speech.stop();

  Future<void> speak(String text, {String language = 'en-US'}) async {
    await _tts.setLanguage(language);
    await _tts.speak(text);
  }
}


