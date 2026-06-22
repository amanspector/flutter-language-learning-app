import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/modules/chatbotpage/provider/message_provider.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/chatbotpage/screen/homechatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Chathistory extends StatelessWidget {
  const Chathistory({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MessageProvider>();
    if (FirebaseAuth.instance.currentUser == null) {
      return const SizedBox.shrink();
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Styled Header with Back Navigation
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // AppContainer(
                //   borderRadius: 30.r,
                //   backgroundColor: context.colors.surface.withValues(
                //     alpha: 0.60,
                //   ),
                //   widget:

                //   IconButton(
                //     onPressed: () {
                //       context.read<HomescreenProvider>().bottomNavBarIndex(0);
                //     },
                //     icon: const Icon(Icons.arrow_back_outlined),
                //   ),
                // ).softFocusIn,
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    "${context.l10n.chat} ${context.l10n.history}",
                    style: context.text.displaySmall,
                  ).fadeInSlideDown,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: CustomPaint(
              painter: TicketPainter(
                concaveDepth: 8,
                cornerRadius: 24,
                color: context.colors.surface,
                borderColor: context.colors.outline.withValues(alpha: 0.25),
              ),
              child: AppContainer(
                backgroundColor: ColorConstant.colorTransparent,
                borderColor: ColorConstant.colorTransparent,
                widget: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 6.h,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: context.colors.primary.withValues(
                      alpha: 0.9,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: context.colors.onPrimary,
                    ),
                  ),
                  title: Text(
                    context.l10n.newChat,
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16.r,
                    color: context.colors.primary.withValues(alpha: 0.8),
                  ),
                  onTap: () {
                    provider.resetChat();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Homechatscreen(),
                      ),
                    );
                    context.read<HomescreenProvider>().keyboardfocus();
                  },
                ),
              ),
            ),
          ),

          // Chat History List Stream
          Expanded(
            child: StreamBuilder(
              stream: provider.getChatList(uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data!.docs;

                // Stylized Empty State
                if (chats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64.r,
                          color: context.colors.outline.withValues(alpha: 0.40),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          context.l10n.noChatHistory,
                          style: context.text.headlineSmall?.copyWith(
                            color: context.colors.outline,
                          ),
                        ),
                      ],
                    ),
                  ).fadeInSlideUp;
                }

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Divider(
                        color: context.colors.outline.withValues(alpha: 0.15),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                          physics: const BouncingScrollPhysics(),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            final chatId = chat.id;
                            final data = chat.data() as Map<String, dynamic>;
                            final timestamp = data['timestamp'] as Timestamp?;
                            final title =
                                data['title'] ?? 'Chat ${chats.length - index}';
                            final isSelected = provider.currentChatId == chatId;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: CustomPaint(
                                painter: TicketPainter(
                                  concaveDepth: 6,
                                  cornerRadius: 22,
                                  color: isSelected
                                      ? context.colors.secondaryContainer
                                            .withValues(alpha: 0.8)
                                      : context.colors.surface,
                                  borderColor: isSelected
                                      ? context.colors.primary.withValues(
                                          alpha: 0.7,
                                        )
                                      : context.colors.outline.withValues(
                                          alpha: 0.15,
                                        ),
                                  glowColor: isSelected
                                      ? context.colors.primary
                                      : null,
                                ),
                                child: AppContainer(
                                  backgroundColor:
                                      ColorConstant.colorTransparent,
                                  borderColor: ColorConstant.colorTransparent,
                                  widget: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 4.h,
                                    ),
                                    selected: isSelected,
                                    leading: CircleAvatar(
                                      backgroundColor: isSelected
                                          ? context.colors.primary.withValues(
                                              alpha: 0.2,
                                            )
                                          : context.colors.onSurface.withValues(
                                              alpha: 0.06,
                                            ),
                                      child: Icon(
                                        isSelected
                                            ? Icons.chat_bubble_rounded
                                            : Icons.chat_bubble_outline_rounded,
                                        color: isSelected
                                            ? context.colors.primary
                                            : context.colors.onSurface
                                                  .withValues(alpha: 0.6),
                                      ),
                                    ),
                                    title: provider.editChatId == chatId
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 4.h,
                                                  ),
                                                  child: TextFormField(
                                                    focusNode:
                                                        provider.editfocusnode,
                                                    autofocus: true,
                                                    controller: provider
                                                        .editChatNameController,
                                                    style:
                                                        context.text.bodyMedium,
                                                    onFieldSubmitted: (value) {
                                                      provider.saveEditChat(
                                                        uid,
                                                        chatId,
                                                      );
                                                    },
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 10.h,
                                                          ),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: context
                                                              .colors
                                                              .primary,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10.r,
                                                                ),
                                                            borderSide:
                                                                BorderSide(
                                                                  color: context
                                                                      .colors
                                                                      .outline
                                                                      .withValues(
                                                                        alpha:
                                                                            0.5,
                                                                      ),
                                                                ),
                                                          ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10.r,
                                                                ),
                                                            borderSide:
                                                                BorderSide(
                                                                  color: context
                                                                      .colors
                                                                      .primary,
                                                                  width: 2,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                icon: Icon(
                                                  Icons.check_rounded,
                                                  color: context.colors.primary,
                                                  size: 22.r,
                                                ),
                                                onPressed: () => provider
                                                    .saveEditChat(uid, chatId),
                                              ),
                                              SizedBox(width: 8.w),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                icon: Icon(
                                                  Icons.close_rounded,
                                                  color: context.colors.error,
                                                  size: 22.r,
                                                ),
                                                onPressed: () =>
                                                    provider.cancelEditChat(),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            title,
                                            style: context.text.titleMedium
                                                ?.copyWith(
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.w500,
                                                  color: isSelected
                                                      ? context.colors.primary
                                                      : context
                                                            .colors
                                                            .onSurface,
                                                ),
                                          ),
                                    subtitle: timestamp != null
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 4.h),
                                            child: Text(
                                              _formatTimestamp(
                                                context,
                                                timestamp,
                                              ),
                                              style: context.text.bodySmall
                                                  ?.copyWith(
                                                    color: context
                                                        .colors
                                                        .onSurfaceVariant
                                                        .withValues(
                                                          alpha: 0.65,
                                                        ),
                                                  ),
                                            ),
                                          )
                                        : null,
                                    trailing: provider.deletingChatId == chatId
                                        ? SizedBox(
                                            width: 20.r,
                                            height: 20.r,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    context.colors.primary,
                                                  ),
                                            ),
                                          )
                                        : PopupMenuButton<String>(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                            ),
                                            color: context.colors.surface,
                                            elevation: 4,
                                            icon: Icon(
                                              Icons.more_vert_rounded,
                                              color: context
                                                  .colors
                                                  .onSurfaceVariant
                                                  .withValues(alpha: 0.7),
                                            ),
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: "edit",
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      context.l10n.edit,
                                                      style: context
                                                          .text
                                                          .bodyMedium,
                                                    ),
                                                    Icon(
                                                      Icons.edit_rounded,
                                                      size: 18.r,
                                                      color: context
                                                          .colors
                                                          .onSurfaceVariant,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: "delete",
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      context.l10n.delete,
                                                      style: context
                                                          .text
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color: context
                                                                .colors
                                                                .error,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    Icon(
                                                      Icons.delete_rounded,
                                                      size: 18.r,
                                                      color:
                                                          context.colors.error,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onSelected: (val) {
                                              if (val == "delete") {
                                                provider.deleteChat(
                                                  uid,
                                                  chatId,
                                                );
                                              } else if (val == "edit") {
                                                Future.microtask(() {
                                                  provider.startEditChat(
                                                    chatId,
                                                    title,
                                                  );
                                                });
                                              }
                                            },
                                          ),
                                    onTap: () {
                                      if (provider.deletingChatId == chatId) {
                                        return;
                                      }
                                      provider.loadChat(uid, chatId);
                                      context
                                          .read<HomescreenProvider>()
                                          .keyboardUnfocus();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Homechatscreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ).fadeInSlideLeftDelayed(80 + index * 40);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(BuildContext context, Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();

    final todayMidnight = DateTime(now.year, now.month, now.day);
    final dateMidnight = DateTime(date.year, date.month, date.day);
    final differenceInDays = todayMidnight.difference(dateMidnight).inDays;

    if (differenceInDays == 0) {
      return context.l10n.timeToday;
    } else if (differenceInDays == 1) {
      return context.l10n.timeYesterday;
    } else if (differenceInDays < 7) {
      return context.l10n.timeDaysAgo(differenceInDays);
    } else {
      return DateFormat.yMd(
        Localizations.localeOf(context).toString(),
      ).format(date);
    }
  }
}
