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
            iconSelected: Icons.home,
            iconDisabled: Icons.home_outlined,
            label: context.l10n.home,
            index: 0,
            selectedIndex: selectedIndex,
            onTap: onTap,
          ),
          _NavItem(
            iconSelected: Icons.chat_bubble,
            iconDisabled: Icons.chat_bubble_outline_outlined,
            label: context.l10n.chat,
            index: 1,
            selectedIndex: selectedIndex,
            onTap: onTap,
          ),
          _NavItem(
            iconSelected: Icons.person,
            iconDisabled: Icons.person_outline,
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
  final IconData iconSelected;
  final IconData iconDisabled;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.iconSelected,
    required this.iconDisabled,
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
                isSelected ? iconSelected : iconDisabled,
                color: isSelected
                    ? context.theme.colorScheme.onSecondaryContainer
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
                          style: context.theme.textTheme.titleMedium?.copyWith(
                            color: isSelected
                                ? context.theme.colorScheme.onSecondaryContainer
                                : null,
                            fontWeight: FontWeight.w600,
                          ),
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
