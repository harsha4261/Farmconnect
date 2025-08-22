import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/supplier.dart';

class SupplierRepository {
  final CollectionReference<Map<String, dynamic>> _suppliers =
      FirebaseFirestore.instance.collection('suppliers');

  Future<String> addSupplier(Supplier supplier) async {
    final doc = await _suppliers.add(supplier.toMap());
    return doc.id;
  }

  Stream<List<Supplier>> listByCategory(String category) {
    return _suppliers
        .where('category', isEqualTo: category)
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Supplier.fromDoc(d.id, d.data()))
            .toList());
  }

  Stream<List<Supplier>> listAll() {
    return _suppliers.orderBy('name').snapshots().map((snap) =>
        snap.docs.map((d) => Supplier.fromDoc(d.id, d.data())).toList());
  }
}


