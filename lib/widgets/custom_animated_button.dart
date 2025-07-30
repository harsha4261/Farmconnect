import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// A modern animated button widget with smooth hover effects
class CustomAnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final bool isDisabled;
  final ButtonStyle buttonStyle;
  final double elevation;
  final List<BoxShadow>? boxShadow;

  const CustomAnimatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.isDisabled = false,
    this.buttonStyle = ButtonStyle.primary,
    this.elevation = 8.0,
    this.boxShadow,
  }) : super(key: key);

  @override
  State<CustomAnimatedButton> createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _shadowAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation * 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;

    final bool isLight = Theme.of(context).brightness == Brightness.light;

    switch (widget.buttonStyle) {
      case ButtonStyle.primary:
        return isLight ? AppTheme.primaryLight : AppTheme.primaryDark;
      case ButtonStyle.secondary:
        return isLight ? AppTheme.secondaryLight : AppTheme.secondaryDark;
      case ButtonStyle.accent:
        return isLight ? AppTheme.accentLight : AppTheme.accentDark;
      case ButtonStyle.success:
        return isLight ? AppTheme.successLight : AppTheme.successDark;
      case ButtonStyle.warning:
        return isLight ? AppTheme.warningLight : AppTheme.warningDark;
      case ButtonStyle.error:
        return isLight ? AppTheme.errorLight : AppTheme.errorDark;
    }
  }

  Color _getTextColor(BuildContext context) {
    if (widget.textColor != null) return widget.textColor!;

    final bool isLight = Theme.of(context).brightness == Brightness.light;

    switch (widget.buttonStyle) {
      case ButtonStyle.primary:
      case ButtonStyle.secondary:
      case ButtonStyle.accent:
      case ButtonStyle.success:
      case ButtonStyle.warning:
      case ButtonStyle.error:
        return isLight ? AppTheme.onPrimaryLight : AppTheme.onPrimaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isDisabled || widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height ?? 56,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: widget.isDisabled
                    ? backgroundColor.withValues(alpha: 0.5)
                    : backgroundColor,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                boxShadow: widget.boxShadow ??
                    [
                      BoxShadow(
                        color: isLight
                            ? backgroundColor.withValues(alpha: 0.3)
                            : backgroundColor.withValues(alpha: 0.2),
                        blurRadius: _shadowAnimation.value,
                        offset: Offset(0, _shadowAnimation.value * 0.5),
                      ),
                    ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  else if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 8),
                  ],
                  if (!widget.isLoading)
                    Text(
                      widget.text,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: widget.isDisabled
                                ? textColor.withValues(alpha: 0.5)
                                : textColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

enum ButtonStyle {
  primary,
  secondary,
  accent,
  success,
  warning,
  error,
}
