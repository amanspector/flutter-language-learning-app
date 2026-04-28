import 'package:chatbot_app/models/message_model.dart';
import 'package:chatbot_app/repository/gemini_repo.dart';
import 'package:chatbot_app/services/firebase_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  final FirebaseChatService service;
  final GeminiRepo repo;

  MessageProvider({required this.repo, required this.service});

  String? streamingMessageId;
  String streamingText = "";
  bool isTyping = false;
  bool isStreaming = false;
  bool isStopped = false;
  bool isSkipped = false;
  String? currentChatId;
  int speedinms = 50; // Changed default speed

  Future<void> sendMessage(String text, String uid) async {
    try {
      // Create chat if doesn't exist
      if (currentChatId == null) {
        currentChatId = await service.createChat(uid);
        notifyListeners();
      }

      // Set streaming state
      isStreaming = true;
      isTyping = true;
      isStopped = false;
      isSkipped = false;
      streamingText = "";
      streamingMessageId = null;
      notifyListeners();

      // Save user message
      await service.sendMessage(
        uid: uid,
        chatid: currentChatId!,
        content: text,
        isUser: true,
      );

      // Create empty AI message placeholder
      final aiMessageId = await service.sendMessage(
        uid: uid,
        chatid: currentChatId!,
        content: "",
        isUser: false,
      );

      streamingMessageId = aiMessageId;
      notifyListeners();

      final reply = await repo.sendMessage(text);

      if (isStopped) {
        return;
      }
      String current = "";
      final words = reply.split(" ");
      int c = 0;

      for (int i = 0; i < words.length; i++) {
        if (isStopped) {
          streamingMessageId = null;
          streamingText = "";
          isStreaming = false;
          notifyListeners();
          return;
        }

        if (isSkipped) {
          current = reply;
          streamingText = current;
          notifyListeners();
          break;
        }

        current += (i == 0) ? words[i] : " ${words[i]}";
        c++;

        if (c % 3 == 0) {
          streamingText = current;
          notifyListeners();
        }

        await Future.delayed(Duration(milliseconds: 50));

        if (isSkipped) {
          current = reply;
          streamingText = current;
          notifyListeners();
          break;
        }
      }

      // Only update Firebase if not stopped
      if (!isStopped) {
        await service.updateMessage(
          uid: uid,
          chatid: currentChatId!,
          messageId: aiMessageId,
          content: current,
        );
        // Clear streaming state
        streamingMessageId = null;
        isTyping = false;
        isStreaming = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error in sendMessage: $e");

      // Save error message
      if (currentChatId != null && streamingMessageId != null) {
        await service.updateMessage(
          uid: uid,
          chatid: currentChatId!,
          messageId: streamingMessageId!,
          content: "Error: $e",
        );
      } else {
        await service.sendMessage(
          uid: uid,
          chatid: currentChatId!,
          content: "Error: $e",
          isUser: false,
        );
      }
      // Clear streaming state
      streamingText = "";
      streamingMessageId = null;
      isTyping = false;
      isStreaming = false;
      notifyListeners();
    }
  }

  /// Stop message generation
  // Future<void> stopGeneration() async {
  //   repo.stopSending();
  //   isStopped = true;
  //   if (streamingMessageId != null && currentChatId != null) {
  //     final uid = FirebaseAuth.instance.currentUser?.uid;
  //     if (uid != null) {
  //       await service.deleteMessage(
  //         uid: uid,
  //         chatid: currentChatId!,
  //         messageId: streamingMessageId!,
  //       );
  //     }
  //   }
  //   isTyping = false;
  //   isStreaming = false;
  //   streamingText = "";
  //   notifyListeners();
  // }
  Future<void> stopGeneration() async {
    repo.stopSending();
    isStopped = true;
    if (streamingMessageId != null && currentChatId != null) {
      try {
        String contentToSave = streamingText.isNotEmpty
            ? streamingText
            : "[Stopped]"; // Or just empty string ""

        await service.updateMessage(
          uid: FirebaseAuth.instance.currentUser!.uid,
          chatid: currentChatId!,
          messageId: streamingMessageId!,
          content: contentToSave,
        );
      } catch (e) {
        print("Error updating message: $e");
      }
    }

    isTyping = false;
    isStreaming = false;
    streamingText = "";
    streamingMessageId = null;
    notifyListeners();
  }

  void skipAnimation() {
    isSkipped = true;

    notifyListeners();
  }

  void resetSpeed() {
    isSkipped = false;
    notifyListeners();
  }

  Future<void> createChat(String uid) async {
    currentChatId = await service.createChat(uid);
    notifyListeners();
  }

  void resetChat() {
    currentChatId = null;
    isTyping = false;
    isStreaming = false;
    streamingText = "";
    streamingMessageId = null;
    isStopped = false;
    notifyListeners();
  }

  /// Send message to Firebase
  Future<void> sendMessageToFirebase(
    String uid,
    String content, {
    bool isUser = true,
  }) async {
    if (currentChatId == null) {
      currentChatId = await service.createChat(uid);
      notifyListeners();
    }

    await service.sendMessage(
      uid: uid,
      chatid: currentChatId!,
      content: content,
      isUser: isUser,
    );
  }

  /// Get message stream from Firebase
  Stream<QuerySnapshot>? getMessageStream(String uid) {
    if (currentChatId == null) return null;
    return service.getmessage(uid, currentChatId!);
  }

  /// Get all chats for a user
  Stream<QuerySnapshot>? getChatList(String uid) {
    return service.getAllChats(uid);
  }

  /// Load a specific chat
  Future<void> loadChat(String uid, String chatId) async {
    currentChatId = chatId;
    streamingText = "";
    streamingMessageId = null;
    isStreaming = false;
    notifyListeners();
  }

  /// Delete a chat
  Future<void> deleteChat(String uid, String chatId) async {
    await service.deleteChat(uid, chatId);
    if (currentChatId == chatId) {
      resetChat();
    }
  }
}
