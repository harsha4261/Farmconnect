import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricSuccess;

  const BiometricAuthWidget({
    super.key,
    required this.onBiometricSuccess,
  });

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  bool _isBiometricAvailable = true;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    // Simulate biometric availability check
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isBiometricAvailable = true; // Mock availability
    });
  }

  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful authentication
      final isAuthenticated = await _showBiometricDialog();

      if (isAuthenticated) {
        HapticFeedback.lightImpact();
        widget.onBiometricSuccess();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Biometric authentication failed: ${e.toString()}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<bool> _showBiometricDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'fingerprint',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Biometric Login',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Use your fingerprint or face to login quickly and securely.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 3.h),
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: _isAuthenticating
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'fingerprint',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 10.w,
                        ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _isAuthenticating ? 'Authenticating...' : 'Touch the sensor',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _isAuthenticating
                    ? null
                    : () {
                        // Simulate successful biometric authentication
                        Navigator.of(context).pop(true);
                      },
                child: const Text('Simulate Success'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Biometric Login Button
        Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isAuthenticating ? null : _authenticateWithBiometric,
              borderRadius: BorderRadius.circular(2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isAuthenticating
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'fingerprint',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        ),
                  SizedBox(width: 2.w),
                  Text(
                    _isAuthenticating
                        ? 'Authenticating...'
                        : 'Login with Biometric',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
