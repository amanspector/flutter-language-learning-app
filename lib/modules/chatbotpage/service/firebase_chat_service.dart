import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> createChat(String uid) async {
    try {
      final chatRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .add({
            'timestamp': FieldValue.serverTimestamp(),
            'lastMessage': '',
            'createdAt': FieldValue.serverTimestamp(),
          });

      return chatRef.id;
    } catch (e) {
      throw Exception('Failed to create chat: $e');
    }
  }

  Future<String> sendMessage({
    required String uid,
    required String chatid,
    required String content,
    required bool isUser,
  }) async {
    try {
      final messageRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .add({
            'content': content,
            'isUser': isUser,
            'timestamp': FieldValue.serverTimestamp(),
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          });

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(chatid)
          .update({
            'lastMessage': content.isEmpty
                ? (isUser ? 'User message' : 'AI typing...')
                : content,
            'timestamp': FieldValue.serverTimestamp(),
          });

      return messageRef.id;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> updateMessage({
    required String uid,
    required String chatid,
    required String messageId,
    required String content,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .doc(messageId)
          .update({
            'content': content,
            'timestamp': FieldValue.serverTimestamp(),
          });

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(chatid)
          .update({
            'lastMessage': content,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to update message: $e');
    }
  }

  Stream<QuerySnapshot> getmessage(String uid, String chatid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatid)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllChats(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteMessage({
    required String uid,
    required String chatid,
    required String messageId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  Future<void> deleteChat(String uid, String chatId) async {
    try {
      // Delete all messages in the chat
      final messages = await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (var doc in messages.docs) {
        await doc.reference.delete();
      }

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(chatId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }

  Future<void> deleteAllChats(String uid) async {
    try {
      final chats = await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .get();

      for (var chat in chats.docs) {
        await deleteChat(uid, chat.id);
      }
    } catch (e) {
      throw Exception('Failed to delete all chats: $e');
    }
  }

  Future<DocumentSnapshot> getChat(String uid, String chatId) async {
    return await _firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .get();
  }

  Future<void> updateChatTitle(String uid, String chatId, String title) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(chatId)
          .update({'title': title});
    } catch (e) {
      throw Exception('Failed to update chat title: $e');
    }
  }
}
