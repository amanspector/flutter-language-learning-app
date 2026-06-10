import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.r, vertical: 16.r),
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.r,
            offset: Offset(0, 2.r),
            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ],
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: context.l10n.home,
            index: 0,
            selectedIndex: selectedIndex,
            onTap: onTap,
          ),
          _NavItem(
            icon: Icons.chat_bubble_rounded,
            label: context.l10n.chat,
            index: 1,
            selectedIndex: selectedIndex,
            onTap: onTap,
          ),
          _NavItem(
            icon: Icons.person_rounded,
            label: context.l10n.profile,
            index: 2,
            selectedIndex: selectedIndex,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 18.r, vertical: 8.r),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SizedBox(
          height: 30,
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? context.theme.colorScheme.onSurface
                    : context.theme.colorScheme.outline,
                // size: 30.sp,
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: isSelected
                    ? Padding(
                        padding: EdgeInsets.only(left: 6.r),
                        child: Text(
                          label,
                          style: context.theme.textTheme.titleMedium,
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
