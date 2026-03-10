import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/breakpoints.dart';
import '../../app/theme/spacing.dart';

/// Consistent page layout with responsive padding and optional max-width.
/// Use for main content areas to ensure visual consistency across screens.
class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.child,
    this.padding,
    this.constrainWidth = true,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool constrainWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final responsivePadding = Breakpoints.isMobile(width)
        ? const EdgeInsets.all(AppSpacing.md)
        : const EdgeInsets.all(AppSpacing.lg);

    Widget content = Padding(
      padding: padding ?? responsivePadding,
      child: child,
    );

    if (constrainWidth && width > Breakpoints.maxContentWidth) {
      content = Center(
        child: SizedBox(
          width: Breakpoints.maxContentWidth,
          child: content,
        ),
      );
    }

    return Container(
      color: backgroundColor ?? AppColors.background,
      child: SafeArea(
        bottom: false,
        child: content,
      ),
    );
  }
}
