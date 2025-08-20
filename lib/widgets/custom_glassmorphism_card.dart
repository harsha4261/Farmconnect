import 'package:flutter/material.dart';
import 'dart:ui';

/// A modern glassmorphism card widget with frosted glass effect
class CustomGlassmorphismCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double opacity;
  final double blurRadius;
  final Color? backgroundColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const CustomGlassmorphismCard({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.borderRadius,
    this.opacity = 0.1,
    this.blurRadius = 20,
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    final borderRadiusValue = borderRadius ?? BorderRadius.circular(20);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        child: ClipRRect(
          borderRadius: borderRadiusValue,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
            child: Container(
              padding: padding ?? const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor ??
                    (isLight
                        ? Colors.white.withValues(alpha: opacity)
                        : Colors.black.withValues(alpha: opacity)),
                borderRadius: borderRadiusValue,
                border: border ??
                    Border.all(
                      color: isLight
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                boxShadow: boxShadow ??
                    [
                      BoxShadow(
                        color: isLight
                            ? Colors.black.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
