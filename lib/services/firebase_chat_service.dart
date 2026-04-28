import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new chat
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

  /// Send a message
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

      // Update last message
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

  /// Update an existing message
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

      // Update last message
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

  /// Get messages stream
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

  /// Get all chats for a user
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

  /// Delete a specific chat
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

      // Delete the chat document
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

  /// Delete all chats for a user
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

  /// Get a specific chat
  Future<DocumentSnapshot> getChat(String uid, String chatId) async {
    return await _firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .get();
  }

  /// Update chat title
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
