import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/inventory_item.dart';

class InventoryRepository {
  final CollectionReference<Map<String, dynamic>> _items =
      FirebaseFirestore.instance.collection('inventory');

  Future<String> upsertItem(InventoryItem item) async {
    if (item.id.isEmpty) {
      final doc = await _items.add(item.toMap());
      return doc.id;
    } else {
      await _items.doc(item.id).set(item.toMap(), SetOptions(merge: true));
      return item.id;
    }
  }

  Future<void> deleteItem(String id) async {
    await _items.doc(id).delete();
  }

  Stream<List<InventoryItem>> itemsForOwner(String ownerId) {
    return _items
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => InventoryItem.fromDoc(d.id, d.data()))
            .toList());
  }
}


