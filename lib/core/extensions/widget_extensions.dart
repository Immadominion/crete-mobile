import 'package:flutter/material.dart';
import '../theme/spacing.dart';

extension WidgetExtensions on Widget {
  /// Adds padding to all sides
  Widget padding(double value) => Padding(padding: EdgeInsets.all(value), child: this);

  /// Adds symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) => Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );

  /// Adds padding only to specific sides
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );

  /// Adds margin to all sides
  Widget margin(double value) => Container(margin: EdgeInsets.all(value), child: this);

  /// Adds symmetric margin
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) => Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );

  /// Adds margin only to specific sides
  Widget marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Container(
      margin: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );

  /// Centers the widget
  Widget get center => Center(child: this);

  /// Aligns the widget
  Widget align(Alignment alignment) => Align(alignment: alignment, child: this);

  /// Expands the widget
  Widget get expanded => Expanded(child: this);

  /// Makes the widget flexible
  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);

  /// Adds a background color
  Widget backgroundColor(Color color) => ColoredBox(color: color, child: this);

  /// Adds a decoration container
  Widget decorated({
    Color? color,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
  }) => DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: this,
    );

  /// Adds a rounded border
  Widget rounded(double radius) => ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);

  /// Adds a circular border
  Widget get circular =>
      ClipRRect(borderRadius: BorderRadius.circular(1000), child: this);

  /// Makes the widget clickable
  Widget onTap(VoidCallback? onTap) => GestureDetector(onTap: onTap, child: this);

  /// Makes the widget clickable with InkWell
  Widget inkWell({VoidCallback? onTap, BorderRadius? borderRadius}) => InkWell(onTap: onTap, borderRadius: borderRadius, child: this);

  /// Adds a shadow
  Widget shadow({
    Color color = Colors.black26,
    double blurRadius = 8.0,
    Offset offset = const Offset(0, 2),
  }) => DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: color, blurRadius: blurRadius, offset: offset),
        ],
      ),
      child: this,
    );

  /// Adds elevation
  Widget elevation(double elevation) => Material(elevation: elevation, child: this);

  /// Makes the widget scrollable
  Widget get scrollable => SingleChildScrollView(child: this);

  /// Sets the widget size
  Widget size({double? width, double? height}) => SizedBox(width: width, height: height, child: this);

  /// Sets fixed width
  Widget width(double width) => SizedBox(width: width, child: this);

  /// Sets fixed height
  Widget height(double height) => SizedBox(height: height, child: this);

  /// Makes widget occupy full width
  Widget get fullWidth => SizedBox(width: double.infinity, child: this);

  /// Makes widget occupy full height
  Widget get fullHeight => SizedBox(height: double.infinity, child: this);

  /// Adds opacity
  Widget opacity(double opacity) => Opacity(opacity: opacity, child: this);

  /// Makes the widget visible/invisible
  Widget visible(bool visible) => Visibility(visible: visible, child: this);

  /// Adds a hero animation
  Widget hero(String tag) => Hero(tag: tag, child: this);

  /// Wraps in SafeArea
  Widget get safeArea => SafeArea(child: this);

  /// Adds a positioned widget (for use in Stack)
  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) => Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );

  /// Fills the available space in Stack
  Widget get fill => Positioned.fill(child: this);

  /// Adds animation scale transition
  Widget scale(double scale) => Transform.scale(scale: scale, child: this);

  /// Adds rotation transform
  Widget rotate(double angle) => Transform.rotate(angle: angle, child: this);

  /// Adds translation transform
  Widget translate({double x = 0, double y = 0}) => Transform.translate(offset: Offset(x, y), child: this);

  /// Clips the widget to specific shape
  Widget clipRect() => ClipRect(child: this);
  Widget clipRRect(BorderRadius borderRadius) =>
      ClipRRect(borderRadius: borderRadius, child: this);
  Widget clipOval() => ClipOval(child: this);
  Widget clipPath(CustomClipper<Path> clipper) =>
      ClipPath(clipper: clipper, child: this);

  /// Adds shimmer effect placeholder
  Widget shimmer() => DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: this,
    );

  /// Wraps with Tooltip
  Widget tooltip(String message) => Tooltip(message: message, child: this);

  /// Makes the widget ignore pointer events
  Widget get ignorePointer => IgnorePointer(child: this);

  /// Absorbs pointer events
  Widget get absorbPointer => AbsorbPointer(child: this);

  /// Adds a border
  Widget border({
    Color color = Colors.grey,
    double width = 1.0,
    BorderRadius? borderRadius,
  }) => DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: borderRadius,
      ),
      child: this,
    );

  /// Adds a card-like appearance
  Widget card({
    Color? color,
    double elevation = 2.0,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
  }) => Card(
      color: color,
      elevation: elevation,
      margin: margin,
      shape: borderRadius != null
          ? RoundedRectangleBorder(borderRadius: borderRadius)
          : null,
      child: this,
    );
}
