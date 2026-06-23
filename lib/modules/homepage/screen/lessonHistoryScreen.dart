import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_circular_progress.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';

import 'package:chatbot_app/modules/homepage/screen/lessonReviewScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Lessonhistoryscreen extends StatelessWidget {
  final List<Map<String, dynamic>> lessonHistory;
  const Lessonhistoryscreen({super.key, required this.lessonHistory});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.w),
                AppContainer(
                  borderRadius: 30.r,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.60),
                  widget: IconButton(
                    onPressed: () {
                      context.read<HomescreenProvider>().bottomNavBarIndex(0);
                    },
                    icon: Icon(Icons.arrow_back_outlined),
                  ),
                ).softFocusIn,
                SizedBox(width: 20.w),

                Expanded(
                  child: Text(
                    context.l10n.history,
                    style: context.text.displaySmall,
                  ).fadeInSlideDown,
                ),
              ],
            ),
          ),

          lessonHistory.isEmpty
              ? Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64.r,
                        color: context.theme.colorScheme.outline.withValues(
                          alpha: 0.40,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        context.l10n.noLessonsAttempted,
                        style: context.text.headlineSmall?.copyWith(
                          color: context.theme.colorScheme.outline,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.l10n.completeLessonToSeeHistory,
                        style: context.text.bodySmall?.copyWith(
                          color: context.theme.colorScheme.outline.withValues(
                            alpha: 0.60,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ).fadeInSlideUp,
                )
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 100.r),
                    itemCount: lessonHistory.length,
                    itemBuilder: (context, index) {
                      final session = lessonHistory[index];
                      final score = session['score'] ?? 0;
                      final total = session['total_questions'] ?? 0;
                      final date = (session['completed_at'] as Timestamp)
                          .toDate();
                      final exercises = List<Map<String, dynamic>>.from(
                        session['exercises'] ?? [],
                      );

                      return Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 0.r : 10.r),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => LessonReviewScreen(
                                  exercises: exercises,
                                  score: score,
                                  total: total,
                                ),
                              ),
                            );
                          },
                          child: CustomPaint(
                            painter: TicketPainter(
                              borderColor: context.theme.colorScheme.outline
                                  .withValues(alpha: 0.20),
                              glowColor: context.theme.colorScheme.primary,
                              concaveDepth: 5,
                            ),
                            child: AppContainer(
                              borderColor: ColorConstant.colorTransparent,
                              backgroundColor: ColorConstant.colorTransparent,
                              widget: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.r,
                                  vertical: 18.r,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${context.l10n.lesson} ${lessonHistory.length - index}",
                                            style: context.text.headlineSmall,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            DateFormat(
                                              'dd MMM yyyy • hh:mm a',
                                            ).format(date),
                                            style: context.text.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),

                                    AppCircularProgress(
                                      score: score,
                                      total: total,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).fadeInSlideUpDelayed(40 + index * 20);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
