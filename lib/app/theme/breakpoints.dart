/// Responsive breakpoints for Assist Health Institute.
/// Use with MediaQuery.sizeOf(context).width or LayoutBuilder.
abstract final class Breakpoints {
  /// Mobile: single column, compact padding, drawer nav
  static const double mobile = 600;

  /// Tablet: two-column layouts, medium padding
  static const double tablet = 840;

  /// Desktop: rail nav, full layouts
  static const double desktop = 1200;

  /// Max content width on ultra-wide displays
  static const double maxContentWidth = 1400;

  static bool isMobile(double width) => width < mobile;
  static bool isTabletOrWider(double width) => width >= mobile;
  static bool isDesktop(double width) => width >= tablet;
  static bool isWideDesktop(double width) => width >= desktop;
}
