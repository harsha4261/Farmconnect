import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final CollectionReference<Map<String, dynamic>> _conversations =
      FirebaseFirestore.instance.collection('conversations');

  Stream<QuerySnapshot<Map<String, dynamic>>> messages(String conversationId) {
    return _conversations
        .doc(conversationId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String conversationId, Map<String, dynamic> msg) {
    return _conversations
        .doc(conversationId)
        .collection('messages')
        .add(msg);
  }
}


