import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/breakpoints.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/services/app_state_provider.dart';
import '../../../core/services/locale_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/demo_banner.dart';

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = Breakpoints.isDesktop(width);
    final isMobile = Breakpoints.isMobile(width);
    final isSupplyMode = ref.watch(selectedDemoModeProvider) == DemoMode.supplySupervision ||
        ref.watch(selectedDemoModeProvider) == DemoMode.healthDepartmentSupervisor;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: isDesktop ? null : _buildDrawer(context, isSupplyMode),
      body: Row(
        children: [
          if (isDesktop) _buildRail(context, isSupplyMode),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(context, isDesktop, isSupplyMode),
                const DemoBanner(compact: true),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? _buildBottomNav(context, isSupplyMode) : null,
    );
  }

  Widget _buildDrawer(BuildContext context, bool isSupplyMode) {
    final l10n = ref.watch(appLocalizationsProvider);
    final selectedIndex = _selectedIndex(context, isSupplyMode);
    final destinations = _getDestinations(context, isSupplyMode, l10n);

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Builder(
                builder: (context) {
                  final mode = ref.watch(selectedDemoModeProvider);
                  final title = mode == DemoMode.healthDepartmentSupervisor
                      ? l10n.modeHealthDeptSupervisor
                      : isSupplyMode
                          ? l10n.modeSupplySupervision
                          : l10n.modePatientCare;
                  return Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: destinations.length,
                itemBuilder: (context, i) {
                  final d = destinations[i];
                  final selected = selectedIndex == i;
                  return ListTile(
                    leading: Icon(
                      selected ? d.selectedIcon : d.icon,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                      size: 24,
                    ),
                    title: Text(
                      d.label,
                      style: TextStyle(
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        color: selected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    selected: selected,
                    onTap: () {
                      Navigator.of(context).pop();
                      _onNav(context, i, isSupplyMode);
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: AppColors.textSecondary),
              title: Text(l10n.switchDemo, style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/demo-selector');
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  List<_NavDest> _getDestinations(BuildContext context, bool isSupplyMode, AppLocalizations l10n) {
    if (isSupplyMode) {
      return [
        _NavDest(Icons.dashboard_outlined, Icons.dashboard, l10n.navSupervisor),
        _NavDest(Icons.inventory_2_outlined, Icons.inventory_2, l10n.navInventory),
        _NavDest(Icons.local_shipping_outlined, Icons.local_shipping, l10n.navSupply),
        _NavDest(Icons.medication_outlined, Icons.medication, l10n.navPharmacyStock),
        _NavDest(Icons.swap_horiz_outlined, Icons.swap_horiz, l10n.navRecommendations),
      ];
    }
    return [
      _NavDest(Icons.dashboard_outlined, Icons.dashboard, l10n.navDashboard),
      _NavDest(Icons.people_outline, Icons.people, l10n.navPatients),
      _NavDest(Icons.confirmation_number_outlined, Icons.confirmation_number, l10n.navQueue),
      _NavDest(Icons.medication_outlined, Icons.medication, l10n.navPharmacy),
      _NavDest(Icons.science_outlined, Icons.science, l10n.navLab),
      _NavDest(Icons.medication_liquid_outlined, Icons.medication_liquid, l10n.navNursing),
    ];
  }

  Widget _buildBottomNav(BuildContext context, bool isSupplyMode) {
    final l10n = ref.watch(appLocalizationsProvider);
    final destinations = _getDestinations(context, isSupplyMode, l10n);
    final selectedIndex = _selectedIndex(context, isSupplyMode).clamp(0, destinations.length - 1).toInt();

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (i) => _onNav(context, i, isSupplyMode),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      items: destinations
          .map(
            (d) => BottomNavigationBarItem(
              icon: Icon(d.icon),
              activeIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
          )
          .toList(),
    );
  }

  Widget _buildRail(BuildContext context, bool isSupplyMode) {
    final l10n = ref.watch(appLocalizationsProvider);
    final destinations = _getDestinations(context, isSupplyMode, l10n);
    return NavigationRail(
      backgroundColor: AppColors.surface,
      selectedIndex: _selectedIndex(context, isSupplyMode).clamp(0, destinations.length - 1).toInt(),
      onDestinationSelected: (i) => _onNav(context, i, isSupplyMode),
      labelType: NavigationRailLabelType.all,
      leading: const SizedBox(height: 16),
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: IconButton(
          icon: const Icon(Icons.swap_horiz),
          tooltip: ref.watch(appLocalizationsProvider).switchDemo,
          onPressed: () => context.go('/demo-selector'),
        ),
      ),
      destinations: destinations
          .map(
            (d) => NavigationRailDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: Text(d.label),
            ),
          )
          .toList(),
    );
  }

  bool _showBackButton(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    const topLevel = [
      '/',
      '/patients',
      '/queue',
      '/pharmacy',
      '/lab',
      '/nursing',
      '/supply/inventory',
      '/supply/products',
      '/supply/requests',
      '/supply/pharmacy-stock',
      '/supply/recommendations',
    ];
    if (topLevel.contains(path)) return false;
    return path.split('/').where((s) => s.isNotEmpty).length > 2;
  }

  Widget _buildAppBar(BuildContext context, bool isDesktop, bool isSupplyMode) {
    final showBack = _showBackButton(context);
    final width = MediaQuery.sizeOf(context).width;
    final showShortTitle = Breakpoints.isMobile(width);

    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(
        horizontal: Breakpoints.isMobile(width) ? AppSpacing.sm : AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              tooltip: ref.watch(appLocalizationsProvider).menu,
            )
          else
            const SizedBox(width: 8),
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
              tooltip: ref.watch(appLocalizationsProvider).back,
            ),
          GestureDetector(
            onTap: () => context.go('/'),
            child: Text(
              showShortTitle ? ref.watch(appLocalizationsProvider).appTitleShort : ref.watch(appLocalizationsProvider).appTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: ref.watch(appLocalizationsProvider).isAr ? 'English' : 'العربية',
            onPressed: () => toggleLocale(ref),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: ref.watch(appLocalizationsProvider).notifications,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: ref.watch(appLocalizationsProvider).account,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context, bool isSupplyMode) {
    final loc = GoRouterState.of(context).uri.path;
    if (isSupplyMode) {
      if (loc.startsWith('/supply/inventory') ||
          loc.startsWith('/supply/products') ||
          loc.startsWith('/supply/product')) {
        return 1;
      }
      if (loc.startsWith('/supply/requests') || loc.startsWith('/supply/fulfill')) {
        return 2;
      }
      if (loc.startsWith('/supply/pharmacy-stock')) {
        return 3;
      }
      if (loc.startsWith('/supply/recommendations') ||
          loc.startsWith('/supply/transfer') ||
          loc.startsWith('/supply/comparison') ||
          loc.startsWith('/supply/analytics')) {
        return 4;
      }
      return 0;
    }
    if (loc.startsWith('/pharmacy')) {
      return 3;
    }
    if (loc.startsWith('/lab')) {
      return 4;
    }
    if (loc.startsWith('/nursing')) {
      return 5;
    }
    if (loc.startsWith('/queue')) {
      return 2;
    }
    if (loc.startsWith('/patients')) {
      return 1;
    }
    return 0;
  }

  void _onNav(BuildContext context, int i, bool isSupplyMode) {
    if (isSupplyMode) {
      switch (i) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/supply/inventory');
          break;
        case 2:
          context.go('/supply/requests');
          break;
        case 3:
          context.go('/supply/pharmacy-stock');
          break;
        case 4:
          context.go('/supply/recommendations');
          break;
      }
      return;
    }
    switch (i) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/patients');
        break;
      case 2:
        context.go('/queue');
        break;
      case 3:
        context.go('/pharmacy');
        break;
      case 4:
        context.go('/lab');
        break;
      case 5:
        context.go('/nursing');
        break;
    }
  }
}

class _NavDest {
  const _NavDest(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
