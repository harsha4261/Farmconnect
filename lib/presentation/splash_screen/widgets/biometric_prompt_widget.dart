import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricPromptWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onSkip;

  const BiometricPromptWidget({
    Key? key,
    required this.onSuccess,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<BiometricPromptWidget> createState() => _BiometricPromptWidgetState();
}

class _BiometricPromptWidgetState extends State<BiometricPromptWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
    });

    // Simulate biometric authentication
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      widget.onSuccess();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                      color: Colors.white.withAlpha(242),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 20,
                            offset: const Offset(0, 10)),
                      ]),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    // Biometric icon
                    Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(26),
                            shape: BoxShape.circle),
                        child: Icon(Icons.fingerprint,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24.sp)),

                    SizedBox(height: 16.h),

                    // Title
                    Text('Quick Access',
                        style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface)),

                    SizedBox(height: 8.h),

                    // Description
                    Text('Use your fingerprint or face ID for faster login',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(179)),
                        textAlign: TextAlign.center),

                    SizedBox(height: 20.h),

                    // Action buttons
                    Row(children: [
                      Expanded(
                          child: TextButton(
                              onPressed:
                                  _isAuthenticating ? null : widget.onSkip,
                              child: Text('Skip',
                                  style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500)))),
                      SizedBox(width: 12.w),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: _isAuthenticating
                                  ? null
                                  : _authenticate,
                              child: _isAuthenticating
                                  ? SizedBox(
                                      width: 16.w,
                                      height: 16.w,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary)))
                                  : Text('Authenticate',
                                      style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500)))),
                    ]),
                  ])));
        });
  }
}
