import 'package:hive_flutter/hive_flutter.dart';

class LocalStore {
  static const String offlineBoxName = 'offline_cache';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(offlineBoxName);
  }

  static Box get offlineBox => Hive.box(offlineBoxName);
}


