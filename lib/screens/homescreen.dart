import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/message_provider.dart';
import 'package:chatbot_app/provider/cred_provider.dart';
import 'package:chatbot_app/screens/background/animated_mesh_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<StatefulWidget> createState() => _StateHomescreen();
}

class _StateHomescreen extends State<Homescreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool showSecond = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // void scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     Future.delayed(Duration(milliseconds: 300), () {
  //       if (_scrollController.hasClients) {
  //         _scrollController.animateTo(
  //           _scrollController.position.maxScrollExtent,
  //           duration: Duration(milliseconds: 500),
  //           curve: Curves.easeOut,
  //         );
  //       }
  //     });
  //   }
  // }

  void scrollToBottom() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    final isNearBottom = position.pixels >= position.maxScrollExtent - 200;

    if (isNearBottom) {
      _scrollController.animateTo(
        position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MessageProvider>();
    final gmail = context.read<CredProvider>().gmail;

    return Scaffold(
      drawer: _buildDrawer(gmail),
      backgroundColor: ColorConstant.color_darkblueshade500,
      body: Stack(
        children: [
          Positioned.fill(child: AnimatedMeshBackground()),
          SafeArea(
            child: Column(
              children: [
                Flexible(
                  child: provider.currentChatId == null
                      ? _buildWelcomePage()
                      : _buildMessageList(provider),
                ),
              ],
            ),
          ),
          _buildTopBar(),
          _buildBottomBar(provider),
        ],
      ),
    );
  }

  Widget _buildDrawer(String? gmail) {
    final provider = context.read<MessageProvider>();

    return Drawer(
      surfaceTintColor: ColorConstant.color_darkblueshade200,
      child: SafeArea(
        child: Column(
          children: [
            // User info header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorConstant.color_blueDark_shade,
                        child: Text(
                          gmail?.toUpperCase()[0] ?? "U",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        gmail ?? "Not found",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
            Divider(),

            // New Chat button
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('New Chat'),
              onTap: () {
                provider.resetChat();
                Navigator.pop(context);
              },
            ),

            Divider(),

            // Chat history
            Expanded(
              child: StreamBuilder(
                stream: provider.getChatList(uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final chats = snapshot.data!.docs;

                  if (chats.isEmpty) {
                    return Center(child: Text('No chat history'));
                  }

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final chatId = chat.id;
                      final data = chat.data() as Map<String, dynamic>;
                      final timestamp = data['timestamp'] as Timestamp?;

                      return ListTile(
                        selected: provider.currentChatId == chatId,
                        leading: Icon(Icons.chat_bubble_outline),
                        title: Text(
                          'Chat ${chats.length - index}',
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: timestamp != null
                            ? Text(
                                _formatTimestamp(timestamp),
                                style: TextStyle(fontSize: 12),
                              )
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, size: 20),
                          onPressed: () {
                            provider.deleteChat(uid, chatId);
                          },
                        ),
                        onTap: () {
                          provider.loadChat(uid, chatId);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 45,
      left: 10,
      right: 10,
      child: LiquidGlassLayer(
        child: LiquidGlass(
          shape: LiquidRoundedRectangle(borderRadius: 20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (BuildContext con) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(con).openDrawer();
                        },
                        icon: Icon(Icons.list),
                      );
                    },
                  ),
                  Text(
                    'Chatbot App',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    onPressed: () {
                      final provider = context.read<MessageProvider>();
                      provider.resetChat();
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList(MessageProvider provider) {
    final stream = provider.getMessageStream(uid);

    if (stream == null) {
      return _buildWelcomePage();
    }

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });

        return ListView.builder(
          padding: const EdgeInsets.only(top: 50, bottom: 60),
          controller: _scrollController,
          itemCount: docs.length + (provider.isStreaming ? 1 : 0),
          itemBuilder: (context, index) {
            if (provider.isStreaming && index == docs.length) {
              return _buildStreamingBubble(provider);
            }

            final data = docs[index].data() as Map<String, dynamic>;
            final isUser = data['isUser'] ?? false;
            final content = data['content'] ?? '';
            final messageId = docs[index].id;

            if (!isUser && content.isEmpty) {
              if (provider.isStreaming &&
                  provider.streamingMessageId == messageId) {
                return SizedBox.shrink(); // Don't show empty placeholder
              }
            }

            return _buildMessageBubble(isUser, content);
          },
        );
      },
    );
  }

  Widget _buildStreamingBubble(MessageProvider provider) {
    final hasText = provider.streamingText.isNotEmpty;

    return hasText
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,

            onTap: () {
              print("---------------------tapped");
              provider.skipAnimation();
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorConstant.color_darkblueshade150,
                  ),
                  padding: EdgeInsets.all(14),
                  child: AbsorbPointer(
                    absorbing: provider.isStreaming,
                    child: MarkdownBody(
                      data: provider.streamingText,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ).copyWith(p: const TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
              ),
            ),
          )
        : _buildTypingIndicator();
  }

  /// Build regular message bubble (saved in Firebase)
  Widget _buildMessageBubble(bool isUser, String content) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isUser
                ? ColorConstant.color_darkblueshade200
                : ColorConstant.color_darkblueshade150,
          ),
          padding: EdgeInsets.all(14),
          child: MarkdownBody(
            data: content,
            selectable: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  h3: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  p: const TextStyle(fontSize: 15),
                  strong: const TextStyle(fontWeight: FontWeight.bold),
                  em: const TextStyle(fontStyle: FontStyle.italic),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(ColorConstant.color_white, BlendMode.srcIn),
      child: SizedBox(
        height: 60,
        width: 60,
        child: Lottie.asset('assets/lottie/Loading.json'),
      ),
    );
  }

  Widget _buildBottomBar(MessageProvider provider) {
    final isStreaming = provider.isStreaming;

    return Positioned(
      bottom: 4,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 20),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: controller,
                      maxLines: null,
                      enabled: !isStreaming,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: Textconstant.txt_askevrything,
                        hintStyle: TextStyle(fontFamily: 'InstrumentSerif'),
                      ),
                      onFieldSubmitted: (_) => _sendMessage(provider),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _sendMessage(provider),
                    icon: Icon(isStreaming ? Icons.stop : Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage(MessageProvider provider) async {
    // If streaming, stop it
    if (provider.isStreaming) {
      await provider.stopGeneration();
      return;
    }

    // Get text and validate
    final text = controller.text.trim();
    if (text.isEmpty) return;

    // Clear and unfocus
    controller.clear();
    FocusScope.of(context).unfocus();

    // Send message
    await provider.sendMessage(text, uid);

    // Reset speed after sending
    provider.resetSpeed();

    // Scroll to bottom
    scrollToBottom();
  }

  Widget _buildWelcomePage() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedTextKit(
            displayFullTextOnTap: true,
            totalRepeatCount: 1,
            animatedTexts: [
              TyperAnimatedText(
                Textconstant.txt_hellothere,
                speed: Duration(milliseconds: 90),
                textStyle: TextStyle(fontSize: 30),
              ),
            ],
            onFinished: () {
              setState(() {
                showSecond = true;
              });
            },
          ),
          if (showSecond)
            AnimatedTextKit(
              displayFullTextOnTap: true,
              totalRepeatCount: 1,
              animatedTexts: [
                TyperAnimatedText(
                  Textconstant.txt_howcanihelp,
                  speed: Duration(milliseconds: 90),
                  textStyle: TextStyle(fontSize: 30),
                ),
              ],
            ),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
