import 'package:cloud_firestore/cloud_firestore.dart';

class JobRepository {
  final CollectionReference<Map<String, dynamic>> _jobs =
      FirebaseFirestore.instance.collection('jobs');

  Future<String> createJob(Map<String, dynamic> job) async {
    final doc = await _jobs.add(job);
    return doc.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listJobs({
    String? skill,
    String? location,
  }) {
    Query<Map<String, dynamic>> query = _jobs.orderBy('createdAt', descending: true);
    if (skill != null) {
      query = query.where('skills', arrayContains: skill);
    }
    if (location != null) {
      query = query.where('location.code', isEqualTo: location);
    }
    return query.snapshots();
  }
}


