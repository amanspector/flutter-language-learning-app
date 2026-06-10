import 'dart:developer';
import 'package:chatbot_app/modules/chatbotpage/repo/gemini_repo.dart';
import 'package:chatbot_app/modules/chatbotpage/service/firebase_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  final FirebaseChatService service;
  final GeminiRepo repo;

  MessageProvider({required this.repo, required this.service});

  String? streamingMessageId;
  String streamingText = "";
  bool isSendingCooldown = false;
  bool isTyping = false;
  bool isStreaming = false;
  bool isStopped = false;
  bool isSkipped = false;
  String? currentChatId;
  String? editChatId;
  TextEditingController? editChatNameController;
  // int speedinms = 50;
  String? deletingChatId;
  FocusNode? editfocusnode;

  Future<void> sendMessage(String text, String uid) async {
    if (isSendingCooldown) return;

    isSendingCooldown = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      isSendingCooldown = false;
      notifyListeners();
    });

    String? chatIdForThisMessage;

    try {
      if (currentChatId == null) {
        currentChatId = await service.createChat(uid);
        notifyListeners();
      }

      isStreaming = true;
      isTyping = true;
      isStopped = false;
      isSkipped = false;
      streamingText = "";
      streamingMessageId = "temp";
      notifyListeners();
      chatIdForThisMessage = currentChatId!;

      await service.sendMessage(
        uid: uid,
        chatid: chatIdForThisMessage,
        content: text,
        isUser: true,
      );

      final reply = await repo.sendMessage(text);

      if (isStopped) {
        streamingText = "";
        streamingMessageId = null;
        isStreaming = false;
        notifyListeners();
        return;
      }

      String current = "";
      final words = reply.split(" ");

      for (int i = 0; i < words.length; i++) {
        if (isStopped) {
          streamingText = ""; // Clear FIRST
          streamingMessageId = null;
          isStreaming = false;
          isTyping = false;
          notifyListeners();
          // Save what we have so far
          if (current.isNotEmpty) {
            await service.sendMessage(
              uid: uid,
              chatid: chatIdForThisMessage,
              content: current,
              isUser: false,
            );
          }
          return;
        }

        if (isSkipped) {
          current = reply;
          streamingText = current;
          notifyListeners();
          break;
        }

        current += (i == 0) ? words[i] : " ${words[i]}";
        streamingText = current;
        notifyListeners();

        await Future.delayed(Duration(milliseconds: 10));

        if (isSkipped) {
          current = reply;
          streamingText = current;
          notifyListeners();
          break;
        }
      }

      if (!isStopped) {
        streamingText = "";
        streamingMessageId = null;
        isTyping = false;
        isStreaming = false;
        notifyListeners();

        // CHECK: If chat was deleted, don't save
        if (deletingChatId == chatIdForThisMessage) {
          return; // Exit, chat is being deleted
        }
        await service.sendMessage(
          uid: uid,
          chatid: chatIdForThisMessage,
          content: current,
          isUser: false,
        );
        streamingText = "";
      }
    } catch (e) {
      log("Error in sendMessage: $e");

      if (chatIdForThisMessage != null &&
          deletingChatId != chatIdForThisMessage) {
        await service.sendMessage(
          uid: uid,
          chatid: chatIdForThisMessage,
          content: "Error: $e",
          isUser: false,
        );
      }

      streamingText = "";
      streamingMessageId = null;
      isTyping = false;
      isStreaming = false;
      notifyListeners();
    }
  }

  Future<void> stopGeneration() async {
    repo.stopSending();
    isStopped = true;
    isTyping = false;
    isStreaming = false;

    // streamingText = "";
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

  void startEditChat(String chatId, String currentTitle) {
    if (editChatId == chatId) return; // prevent rebuild issues
    editChatId = chatId;
    editfocusnode = FocusNode();
    editChatNameController = TextEditingController(text: currentTitle);
    notifyListeners();
  }

  void cancelEditChat() {
    editChatId = null;
    editChatNameController?.dispose();
    editChatNameController = null;
    editfocusnode?.dispose();
    notifyListeners();
  }

  Future<void> saveEditChat(String uid, String chatId) async {
    if (editChatNameController?.text.trim().isEmpty ?? true) {
      cancelEditChat();
      return;
    }
    await service.updateChatTitle(
      uid,
      chatId,
      editChatNameController!.text.trim(),
    );
    editChatNameController?.dispose();
    editfocusnode?.dispose();
    editChatNameController = null;
    editfocusnode = null;

    editChatId = null;
    notifyListeners();
  }

  /// Delete a chat
  Future<void> deleteChat(String uid, String chatId) async {
    deletingChatId = chatId;
    notifyListeners();

    if (currentChatId == chatId) {
      resetChat();
    }
    await service.deleteChat(uid, chatId);

    deletingChatId = null;
    notifyListeners();
  }
}
