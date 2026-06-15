import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_loading_screen.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/chatbotpage/provider/message_provider.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Homechatscreen extends StatefulWidget {
  const Homechatscreen({super.key});

  @override
  State<StatefulWidget> createState() => _StateHomescreen();
}

class _StateHomescreen extends State<Homechatscreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController inputcontroller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool showSecond = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    inputcontroller.dispose();
    _scrollController.dispose();

    super.dispose();
  }

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

    return AppScreen(
      body: Stack(
        children: [
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
          // _buildTopBar(),
          _buildBottomBar(provider),
        ],
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
          return AppLoadingScreen();
          // Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });

        return ClipRRect(
          borderRadius: BorderRadius.circular(40.r),
          child: ListView.builder(
            padding: EdgeInsets.only(top: 50.r, bottom: 70.r),
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
          ),
        );
      },
    );
  }

  Widget _buildStreamingBubble(MessageProvider provider) {
    final hasText = provider.streamingText.isNotEmpty;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
        child: hasText
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,

                onDoubleTap: () {
                  log("---------------------tapped");
                  provider.skipAnimation();
                },

                onLongPress: () async {
                  final text = provider.streamingText.trim();
                  log("COPYING: $text");
                  if (text.isEmpty) return;
                  await Clipboard.setData(ClipboardData(text: text));
                  if (!mounted) return;
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.heightOf(context) / 2 - 30,
                          left: 20.r,
                          right: 20.r,
                        ),
                        content: SizedBox(
                          width: MediaQuery.widthOf(context),
                          child: Text(
                            context.l10n.copied,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                },

                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: context.theme.colorScheme.outline.withValues(
                      alpha: 0.2,
                    ),
                  ),
                  padding: EdgeInsets.all(
                    14.r,
                  ), // Adjust padding for better touch target on smaller screens
                  child: MarkdownBody(
                    data: provider.streamingText,

                    styleSheet: MarkdownStyleSheet.fromTheme(context.theme)
                        .copyWith(
                          p: context.theme.textTheme.labelMedium,

                          //  TextStyle(fontSize: 15.sp)
                        ),
                  ),
                ),
              )
            : _buildTypingIndicator(),
      ),
    );
  }

  Widget _buildMessageBubble(bool isUser, String content) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
        child: GestureDetector(
          onLongPress: () async {
            log("COPYING: $content");
            if (content.isEmpty) return;
            if (!mounted) return;
            await Clipboard.setData(ClipboardData(text: content));
            if (!mounted) return;
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.heightOf(context) / 2 - 30,
                    left: 20.r,
                    right: 20.r,
                  ),
                  content: SizedBox(
                    width: MediaQuery.widthOf(context),
                    child: Text(
                      context.l10n.copied,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
          },

          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: isUser
                  ? context.theme.colorScheme.onSecondaryContainer.withValues(
                      alpha: 0.20,
                    )
                  : context.theme.colorScheme.outline.withValues(alpha: 0.10),
            ),
            padding: EdgeInsets.all(14.r),
            child: MarkdownBody(
              data: content,
              selectable: false,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(
                    h3: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    strong: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    em: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.primary,
        BlendMode.srcIn,
      ),
      child: SizedBox(
        height: 60.sp,
        width: 60.sp,
        child: Lottie.asset('assets/lottie/Loading.json'),
      ),
    );
  }

  Widget _buildBottomBar(MessageProvider provider) {
    final isStreaming = provider.isStreaming;
    final isDisabled = provider.isSendingCooldown;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(12.r),
        height: 100.sp,
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: TextFormField(
                focusNode: context.read<HomescreenProvider>().focus,
                controller: inputcontroller,
                minLines: 1,
                maxLines: 15,
                enabled: !isStreaming,
                style: context.text.bodyMedium,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: context.l10n.askAnything,
                  hintStyle: context.text.bodyMedium,
                ),
              ),
            ),
            SizedBox(width: 5.r),
            AppContainer(
              borderRadius: 10.r,
              backgroundColor: context.theme.colorScheme.primary.withValues(
                alpha: 0.20,
              ),
              widget: IconButton(
                onPressed: isDisabled
                    ? null
                    : () async {
                        await _sendMessage(provider);
                      },
                icon: Icon(isStreaming ? Icons.stop : Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage(MessageProvider provider) async {
    if (provider.isStreaming) {
      await provider.stopGeneration();
      return;
    }

    final text = inputcontroller.text.trim();
    if (text.isEmpty || provider.isSendingCooldown) return;

    inputcontroller.clear();
    FocusScope.of(context).unfocus();

    await provider.sendMessage(text, uid);

    provider.resetSpeed();
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
                textAlign: TextAlign.center,
                context.l10n.helloThere,
                speed: Duration(milliseconds: 90),
                textStyle: TextStyle(fontSize: 30.sp),
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
                  textAlign: TextAlign.center,
                  context.l10n.howCanIHelpYouToday,
                  speed: Duration(milliseconds: 90),
                  textStyle: TextStyle(fontSize: 30.sp),
                ),
              ],
            ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
