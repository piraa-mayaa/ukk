import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // Screen sizes
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // If width is more than 1200 then we consider it a desktop
    if (size.width >= 1200) {
      return desktop;
    }
    // If width is more than 600 and tablet widget is provided
    else if (size.width >= 600 && tablet != null) {
      return tablet!;
    }
    // Else we return mobile layout
    else {
      return mobile;
    }
  }
}
