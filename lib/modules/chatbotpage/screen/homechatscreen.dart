import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_loading_screen.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/chatbotpage/provider/message_provider.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        duration: const Duration(milliseconds: 300),
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
          // Background Message Stream List / Welcome screen
          Column(
            children: [
              Expanded(
                child: provider.currentChatId == null
                    ? _buildWelcomePage()
                    : _buildMessageList(provider),
              ),
            ],
          ),

          // Custom floating top bar with dynamic Firestore title stream
          _buildTopBar(provider),

          // Floating bottom text input area with gradients
          _buildBottomBar(provider),
        ],
      ),
    );
  }

  Widget _buildTopBar(MessageProvider provider) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: MediaQuery.paddingOf(context).top + 8.h,
          bottom: 12.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.95,
              ),
              context.theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.85,
              ),
              context.theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.0,
              ),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: Row(
          children: [
            AppContainer(
              borderRadius: 30.r,
              backgroundColor: context.colors.surface.withValues(alpha: 0.70),
              borderColor: context.colors.outline.withValues(alpha: 0.15),
              widget: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: context.colors.onSurface,
                ),
              ),
            ).softFocusIn,
            SizedBox(width: 16.w),
            Expanded(
              child: provider.currentChatId == null
                  ? Text(
                      context.l10n.chat,
                      style: context.text.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.onSurface,
                      ),
                    )
                  : StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('chats')
                          .doc(provider.currentChatId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String title = context.l10n.chat;
                        if (snapshot.hasData && snapshot.data!.exists) {
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          title = data?['title'] ?? title;
                        }
                        return Text(
                          title,
                          style: context.text.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
            ),
            if (provider.currentChatId != null) ...[
              SizedBox(width: 8.w),
              AppContainer(
                borderRadius: 30.r,
                backgroundColor: context.colors.surface.withValues(alpha: 0.70),
                borderColor: context.colors.outline.withValues(alpha: 0.15),
                widget: IconButton(
                  onPressed: () {
                    provider.resetChat();
                  },
                  icon: Icon(Icons.add_rounded, color: context.colors.primary),
                  tooltip: context.l10n.newChat,
                ),
              ).softFocusIn,
            ],
          ],
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
          return const AppLoadingScreen();
        }
        final docs = snapshot.data!.docs;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });

        return ListView.builder(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 70.h,
            bottom: MediaQuery.paddingOf(context).bottom + 70.h,
          ),
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: docs.length + (provider.isStreaming ? 1 : 0),
          itemBuilder: (context, index) {
            if (provider.isStreaming && index == docs.length) {
              return _buildStreamingBubble(provider).fadeInSlideUp;
            }

            final data = docs[index].data() as Map<String, dynamic>;
            final isUser = data['isUser'] ?? false;
            final content = data['content'] ?? '';
            final messageId = docs[index].id;

            if (!isUser && content.isEmpty) {
              if (provider.isStreaming &&
                  provider.streamingMessageId == messageId) {
                return const SizedBox.shrink();
              }
            }

            final bubble = _buildMessageBubble(isUser, content);
            final isLast = index == docs.length - 1;
            if (isLast && !provider.isStreaming) {
              return bubble.fadeInSlideUp;
            }
            return bubble;
          },
        );
      },
    );
  }

  Widget _buildStreamingBubble(MessageProvider provider) {
    final hasText = provider.streamingText.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: context.colors.primary.withValues(alpha: 0.15),
            child: Icon(
              Icons.smart_toy_rounded,
              size: 20.r,
              color: context.colors.primary,
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
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
                            duration: const Duration(seconds: 1),
                          ),
                        );
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.72,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.surface.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(4.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                        border: Border.all(
                          color: context.colors.outline.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: MarkdownBody(
                        data: provider.streamingText,
                        styleSheet: MarkdownStyleSheet.fromTheme(context.theme)
                            .copyWith(
                              p: context.text.bodyMedium?.copyWith(
                                color: context.colors.onSurface,
                                height: 1.4,
                              ),
                            ),
                      ),
                    ),
                  )
                : _buildTypingIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(bool isUser, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 18.r,
              backgroundColor: context.colors.primary.withValues(alpha: 0.15),
              child: Icon(
                Icons.smart_toy_rounded,
                size: 20.r,
                color: context.colors.primary,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
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
                      duration: const Duration(seconds: 1),
                    ),
                  );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                decoration: BoxDecoration(
                  color: isUser
                      ? context.colors.primary.withValues(alpha: 0.15)
                      : context.colors.surface.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(isUser ? 20.r : 4.r),
                    bottomRight: Radius.circular(isUser ? 4.r : 20.r),
                  ),
                  border: Border.all(
                    color: isUser
                        ? context.colors.primary.withValues(alpha: 0.3)
                        : context.colors.outline.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: MarkdownBody(
                  data: content,
                  selectable: false,
                  styleSheet: MarkdownStyleSheet.fromTheme(context.theme)
                      .copyWith(
                        p: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurface,
                          height: 1.4,
                        ),
                        h3: context.text.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                        strong: context.text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                        em: context.text.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: context.colors.onSurface,
                        ),
                      ),
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: context.colors.secondary.withValues(alpha: 0.15),
              child: Icon(
                Icons.person_rounded,
                size: 20.r,
                color: context.colors.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      constraints: BoxConstraints(maxWidth: 100.w),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.65),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(4.r),
          bottomRight: Radius.circular(20.r),
        ),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          context.theme.colorScheme.primary,
          BlendMode.srcIn,
        ),
        child: SizedBox(
          height: 36.h,
          width: 48.w,
          child: Lottie.asset('assets/lottie/loading_spinner.json'),
        ),
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
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 12.h,
          bottom: MediaQuery.paddingOf(context).bottom + 12.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.theme.colorScheme.onPrimary.withValues(alpha: 0.0),
              context.theme.colorScheme.onPrimary.withValues(alpha: 0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: context.colors.outline.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextFormField(
                  focusNode: context.read<HomescreenProvider>().focus,
                  controller: inputcontroller,
                  minLines: 1,
                  maxLines: 5,
                  enabled: !isStreaming,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    hintText: context.l10n.askAnything,
                    hintStyle: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            AppContainer(
              borderRadius: 24.r,
              backgroundColor: isStreaming
                  ? context.colors.error.withValues(alpha: 0.2)
                  : context.colors.primary.withValues(alpha: 0.2),
              borderColor: isStreaming
                  ? context.colors.error.withValues(alpha: 0.4)
                  : context.colors.primary.withValues(alpha: 0.4),
              widget: IconButton(
                onPressed: isDisabled
                    ? null
                    : () async {
                        await _sendMessage(provider);
                      },
                icon: Icon(
                  isStreaming ? Icons.stop_rounded : Icons.send_rounded,
                  color: isStreaming
                      ? context.colors.error
                      : context.colors.primary,
                  size: 22.r,
                ),
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
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/logo.json',
              height: 160.r,
              width: 160.r,
            ).fadeInScale,
            SizedBox(height: 24.h),
            AnimatedTextKit(
              displayFullTextOnTap: true,
              totalRepeatCount: 1,
              animatedTexts: [
                TyperAnimatedText(
                  textAlign: TextAlign.center,
                  context.l10n.helloThere,
                  speed: const Duration(milliseconds: 80),
                  textStyle: context.text.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colors.primary,
                  ),
                ),
              ],
              onFinished: () {
                setState(() {
                  showSecond = true;
                });
              },
            ),
            if (showSecond) ...[
              SizedBox(height: 12.h),
              AnimatedTextKit(
                displayFullTextOnTap: true,
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText(
                    textAlign: TextAlign.center,
                    context.l10n.howCanIHelpYouToday,
                    speed: const Duration(milliseconds: 60),
                    textStyle: context.text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
