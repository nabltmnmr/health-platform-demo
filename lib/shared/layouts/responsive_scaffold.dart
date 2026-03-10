import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Responsive scaffold: optional rail/sidebar on desktop, content adapts.
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    this.title,
    this.actions,
    this.railDestinations,
    this.onRailDestinationSelected,
    this.selectedRailIndex = 0,
    this.body,
    this.floatingActionButton,
  });

  final String? title;
  final List<Widget>? actions;
  final List<NavigationRailDestination>? railDestinations;
  final ValueChanged<int>? onRailDestinationSelected;
  final int selectedRailIndex;
  final Widget? body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
              backgroundColor: AppColors.surface,
            )
          : null,
      body: Row(
        children: [
          if (isDesktop && railDestinations != null && railDestinations!.isNotEmpty)
            NavigationRail(
              backgroundColor: AppColors.surface,
              selectedIndex: selectedRailIndex,
              onDestinationSelected: onRailDestinationSelected ?? (_) {},
              labelType: NavigationRailLabelType.all,
              destinations: railDestinations!,
            ),
          Expanded(child: body ?? const SizedBox.shrink()),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
