import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/nav_item.dart';

class AppConfigService {
  static const String _boxName = 'app_config_cache';
  final _fs = FirebaseFirestore.instance;

  static Future<Box> _ensureAndGetBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Stream<List<NavItem>> navItemsStream(String role) async* {
    final box = await _ensureAndGetBox();
    // Emit cached first
    final cached = box.get('nav_$role') as List?;
    if (cached != null) {
      yield cached.cast<Map>().map((e) => NavItem.fromMap(e.cast())).toList();
    }
    // Live from Firestore
    final snap = _fs.collection('app_config').doc('navigation').snapshots();
    await for (final doc in snap) {
      final data = doc.data() ?? {};
      final items = (data['bottom'] as List<dynamic>? ?? [])
          .map((e) => NavItem.fromMap(e as Map<String, dynamic>))
          .where((n) => n.roles.isEmpty || n.roles.contains(role))
          .toList();
      await box.put('nav_$role', items.map((e) => {
            'title': e.title,
            'icon': e.icon,
            'route': e.route,
            'roles': e.roles,
          }).toList());
      yield items;
    }
  }
}


