import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/team.dart';

class TeamRepository {
  final CollectionReference<Map<String, dynamic>> _teams =
      FirebaseFirestore.instance.collection('teams');

  Future<String> createTeam({
    required String ownerId,
    required String name,
    List<String> memberIds = const [],
  }) async {
    final now = DateTime.now().toUtc();
    final doc = await _teams.add({
      'ownerId': ownerId,
      'name': name,
      'memberIds': memberIds,
      'createdAt': now.millisecondsSinceEpoch,
    });
    return doc.id;
  }

  Future<void> addMember(String teamId, String userId) async {
    await _teams.doc(teamId).update({
      'memberIds': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> removeMember(String teamId, String userId) async {
    await _teams.doc(teamId).update({
      'memberIds': FieldValue.arrayRemove([userId])
    });
  }

  Stream<List<Team>> listTeamsForOwner(String ownerId) {
    return _teams
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Team.fromDoc(d.id, d.data()))
            .toList());
  }
}


