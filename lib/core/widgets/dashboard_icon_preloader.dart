import 'package:flutter/material.dart';

/// Simple widget that can be used to wrap dashboard content
/// Icon preloading is handled automatically by flutter_svg
class DashboardIconPreloader extends StatelessWidget {
  const DashboardIconPreloader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // flutter_svg handles caching automatically
    // No need for manual preloading in most cases
    return child;
  }
}
