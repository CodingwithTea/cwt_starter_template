import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';

/// A circular container widget with optional child, border, and styling.
class TCircularContainer extends StatelessWidget {
  /// Create a circular container.
  ///
  /// Parameters:
  ///   - child: The optional child widget to be placed inside the container.
  ///   - margin: The margin around the container.
  ///   - padding: The padding inside the container.
  ///   - width: The width of the container.
  ///   - height: The height of the container.
  ///   - radius: The radius of the circular border.
  ///   - showBorder: Whether to show a border around the container.
  ///   - backgroundColor: The background color of the container.
  ///   - borderColor: The color of the border (if [showBorder] is true).
  const TCircularContainer({
    super.key,
    this.child,
    this.margin,
    this.padding,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.showBorder = false,
    this.backgroundColor = TColors.white,
    this.borderColor = TColors.borderPrimary,
  });

  final Widget? child;
  final double? width;
  final double radius;
  final double? height;
  final bool showBorder;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
