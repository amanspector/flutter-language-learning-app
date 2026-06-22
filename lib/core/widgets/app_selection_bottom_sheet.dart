import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<T> items;
  final bool Function(T item) isSelected;
  final Widget Function(BuildContext context, T item, bool isActive) leadingBuilder;
  final String Function(BuildContext context, T item) titleBuilder;
  final String? Function(BuildContext context, T item)? subtitleBuilder;
  final void Function(BuildContext context, T item) onItemTap;
  final String? activeBadgeText;
  final Widget? bottomActionButton;
  final ScrollController scrollController;

  const AppSelectionBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.items,
    required this.isSelected,
    required this.leadingBuilder,
    required this.titleBuilder,
    this.subtitleBuilder,
    required this.onItemTap,
    this.activeBadgeText,
    this.bottomActionButton,
    required this.scrollController,
  });

  static Future<void> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<T> items,
    required bool Function(T item) isSelected,
    required Widget Function(BuildContext context, T item, bool isActive) leadingBuilder,
    required String Function(BuildContext context, T item) titleBuilder,
    String? Function(BuildContext context, T item)? subtitleBuilder,
    required void Function(BuildContext context, T item) onItemTap,
    String? activeBadgeText,
    Widget? bottomActionButton,
    double initialChildSize = 0.55,
    double minChildSize = 0.35,
    double maxChildSize = 0.85,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          builder: (_, scrollController) {
            return AppSelectionBottomSheet<T>(
              title: title,
              subtitle: subtitle,
              items: items,
              isSelected: isSelected,
              leadingBuilder: leadingBuilder,
              titleBuilder: titleBuilder,
              subtitleBuilder: subtitleBuilder,
              onItemTap: onItemTap,
              activeBadgeText: activeBadgeText,
              bottomActionButton: bottomActionButton,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // ── Drag handle + header (fixed, not scrollable) ──
          Padding(
            padding: EdgeInsets.fromLTRB(24.r, 12.r, 24.r, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: scheme.onSurface.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Title row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: context.text.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: 2.h),
                            Text(
                              subtitle!,
                              style: context.text.bodySmall?.copyWith(
                                color: scheme.onSurface.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Divider(
                  height: 1,
                  color: scheme.outline.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),

          // ── Scrollable list ──
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.symmetric(vertical: 8.r),
              itemCount: items.length,
              separatorBuilder: (_, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.r),
                child: Divider(
                  height: 1,
                  color: scheme.outline.withValues(alpha: 0.07),
                ),
              ),
              itemBuilder: (_, i) {
                final item = items[i];
                final isActive = isSelected(item);
                final leadingWidget = leadingBuilder(context, item, isActive);
                final itemTitle = titleBuilder(context, item);
                final itemSubtitle = subtitleBuilder?.call(context, item);

                return InkWell(
                  onTap: () => onItemTap(context, item),
                  splashColor: scheme.primary.withValues(alpha: 0.06),
                  highlightColor: scheme.primary.withValues(alpha: 0.04),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: isActive
                          ? scheme.primary.withValues(alpha: 0.05)
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isActive ? scheme.primary : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.r,
                      vertical: 14.r,
                    ),
                    child: Row(
                      children: [
                        // Leading avatar/container
                        leadingWidget,
                        SizedBox(width: 14.w),

                        // Title + subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itemTitle,
                                style: context.text.bodyLarge?.copyWith(
                                  fontWeight: isActive
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isActive
                                      ? scheme.primary
                                      : scheme.onSurface,
                                ),
                              ),
                              if (itemSubtitle != null && itemSubtitle.isNotEmpty) ...[
                                SizedBox(height: 3.h),
                                Text(
                                  itemSubtitle,
                                  style: context.text.bodySmall?.copyWith(
                                    color: scheme.onSurface.withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Active indicator or chevron
                        if (isActive)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.r,
                              vertical: 4.r,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_rounded,
                                  size: 11.sp,
                                  color: scheme.onPrimary,
                                ),
                                if (activeBadgeText != null) ...[
                                  SizedBox(width: 4.w),
                                  Text(
                                    activeBadgeText!,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: scheme.onPrimary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        else
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 20.sp,
                            color: scheme.onSurface.withValues(alpha: 0.25),
                          ),
                      ],
                    ),
                  ),
                ).staggerFadeLeft(i, baseDelayMs: 50);
              },
            ),
          ),

          // ── Bottom action button (optional) ──
          if (bottomActionButton != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                20.r,
                8.r,
                20.r,
                MediaQuery.of(context).padding.bottom + 16.r,
              ),
              child: SizedBox(
                width: double.infinity,
                child: bottomActionButton,
              ),
            ),
        ],
      ),
    );
  }
}
