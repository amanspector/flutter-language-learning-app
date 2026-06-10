import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
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
      return SizedBox();
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.r),
            child: AppContainer(
              backgroundColor: context.theme.colorScheme.secondaryContainer
                  .withValues(alpha: 0.6),
              borderColor: context.theme.colorScheme.onPrimaryContainer
                  .withValues(alpha: 0.3),
              widget: ListTile(
                leading: Icon(Icons.add_circle_outline),
                title: Text(context.l10n.newChat),
                onTap: () {
                  provider.resetChat();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homechatscreen()),
                  );
                  context.read<HomescreenProvider>().keyboardfocus();
                },
              ),
            ),
          ),

          Divider(),
          Expanded(
            child: StreamBuilder(
              stream: provider.getChatList(uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data!.docs;

                if (chats.isEmpty) {
                  return Center(child: Text(context.l10n.noChatHistory));
                }

                return Padding(
                  padding: EdgeInsets.all(10.r),
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final chatId = chat.id;
                      final data = chat.data() as Map<String, dynamic>;
                      final timestamp = data['timestamp'] as Timestamp?;

                      final title =
                          data['title'] ?? 'Chat ${chats.length - index}';

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: AppContainer(
                          backgroundColor: context
                              .theme
                              .colorScheme
                              .secondaryContainer
                              .withValues(alpha: 0.6),
                          borderColor: context
                              .theme
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: 0.3),
                          widget: ListTile(
                            selected: provider.currentChatId == chatId,
                            leading: Icon(Icons.chat_bubble_outline),
                            title: provider.editChatId == chatId
                                ? Row(
                                    children: [
                                      Flexible(
                                        flex: 6,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5.r,
                                          ),
                                          child: TextFormField(
                                            focusNode: provider.editfocusnode,
                                            autofocus: true,
                                            controller:
                                                provider.editChatNameController,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,

                                            onFieldSubmitted: (value) {
                                              provider.saveEditChat(
                                                uid,
                                                chatId,
                                              );
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: IconButton(
                                          icon: Icon(Icons.check, size: 20),
                                          onPressed: () => provider
                                              .saveEditChat(uid, chatId),
                                        ),
                                      ),
                                      Flexible(
                                        child: IconButton(
                                          icon: Icon(Icons.close, size: 20),
                                          onPressed: () =>
                                              provider.cancelEditChat(),
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    title,
                                    style: provider.currentChatId == chatId
                                        ? Theme.of(context).textTheme.bodySmall
                                        : Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                  ),
                            subtitle: timestamp != null
                                ? Text(
                                    _formatTimestamp(context, timestamp),
                                    style: TextStyle(fontSize: 12),
                                  )
                                : null,
                            trailing: provider.deletingChatId == chatId
                                ? CircularProgressIndicator()
                                : PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: "edit",
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              context.l10n.edit,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Icon(Icons.edit, size: 20),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        // onTap: () {
                                        // },
                                        value: "delete",
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              context.l10n.delete,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Icon(Icons.delete, size: 20),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (val) {
                                      if (val == "delete") {
                                        provider.deleteChat(uid, chatId);
                                      } else if (val == "edit") {
                                        Future.microtask(() {
                                          provider.startEditChat(chatId, title);
                                        });
                                        // provider.startEditChat(chatId, title);
                                      }
                                    },
                                  ),
                            onTap: () {
                              if (provider.deletingChatId == chatId) {
                                return;
                              }
                              provider.loadChat(uid, chatId);
                              // focus.unfocus();

                              context
                                  .read<HomescreenProvider>()
                                  .keyboardUnfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homechatscreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
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
    // final  = now.difference(date);

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
