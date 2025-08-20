import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentRepository {
  final CollectionReference<Map<String, dynamic>> _equipments =
      FirebaseFirestore.instance.collection('equipments');

  Future<String> createEquipment(Map<String, dynamic> item) async {
    final doc = await _equipments.add(item);
    return doc.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listEquipments() {
    return _equipments.orderBy('createdAt', descending: true).snapshots();
  }
}


