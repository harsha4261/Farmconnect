import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable gradient container widget for beautiful backgrounds
class CustomGradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final GradientType gradientType;

  const CustomGradientContainer({
    Key? key,
    required this.child,
    this.colors,
    this.begin,
    this.end,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.gradientType = GradientType.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    LinearGradient gradient;
    switch (gradientType) {
      case GradientType.primary:
        gradient = AppTheme.getPrimaryGradient(isLight: isLight);
        break;
      case GradientType.secondary:
        gradient = AppTheme.getSecondaryGradient(isLight: isLight);
        break;
      case GradientType.accent:
        gradient = AppTheme.getAccentGradient(isLight: isLight);
        break;
      case GradientType.background:
        gradient = AppTheme.getBackgroundGradient(isLight: isLight);
        break;
      case GradientType.custom:
        gradient = LinearGradient(
          colors: colors ?? AppTheme.primaryGradientLight,
          begin: begin ?? Alignment.topLeft,
          end: end ?? Alignment.bottomRight,
        );
        break;
    }

    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: boxShadow ?? AppTheme.getCardShadow(isLight: isLight),
        border: border,
      ),
      child: child,
    );
  }
}

enum GradientType {
  primary,
  secondary,
  accent,
  background,
  custom,
}
