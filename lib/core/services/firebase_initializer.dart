import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../core/app_export.dart';
import '../../../firebase_options.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      // Request FCM permissions on supported platforms
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final messaging = FirebaseMessaging.instance;
        await messaging.requestPermission();
      }
    } catch (e) {
      debugPrint('Firebase init error: $e');
    }
  }
}


