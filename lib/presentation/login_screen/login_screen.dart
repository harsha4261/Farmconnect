import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/services/auth/auth_service.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/country_code_picker_widget.dart';

// Login method selection (top-level)
enum _LoginMethod { phone, email }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _selectedCountryCode = '+91';
  String? _phoneError;
  String? _passwordError;
  String? _generalError;
  bool _rememberPhone = true;
  String? _verificationId;
  _LoginMethod _loginMethod = _LoginMethod.phone;

  @override
  void initState() {
    super.initState();
    _loadSavedPhone();
    _setupKeyboardListener();
  }

  void _setupKeyboardListener() {
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        setState(() {
          _phoneError = null;
        });
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          _passwordError = null;
        });
      }
    });
  }

  void _loadSavedPhone() {
    // Simulate loading saved phone number
    if (_rememberPhone) {
      _phoneController.text = '9876543210';
    }
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      _phoneError = null;
      _passwordError = null;
      _generalError = null;
    });

    final input = _phoneController.text.trim();
    final isEmailMethod = _loginMethod == _LoginMethod.email;

    if (isEmailMethod) {
      // Basic email validation
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegex.hasMatch(input)) {
        setState(() {
          _phoneError = 'Enter a valid email address';
        });
        isValid = false;
      }
      if (_passwordController.text.isEmpty) {
        setState(() {
          _passwordError = 'Password is required';
        });
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        setState(() {
          _passwordError = 'Password must be at least 6 characters';
        });
        isValid = false;
      }
    } else {
      // Phone validation
      if (input.isEmpty) {
        setState(() {
          _phoneError = 'Phone number is required';
        });
        isValid = false;
      } else {
        final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length < 10) {
          setState(() {
            _phoneError = 'Please enter a valid 10-digit phone number';
          });
          isValid = false;
        }
      }
    }

    return isValid;
  }

  Future<void> _handleLogin() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      final input = _phoneController.text.trim();
      final isEmailMethod = _loginMethod == _LoginMethod.email;

      if (isEmailMethod) {
        final password = _passwordController.text.trim();
        try {
          await AuthService().signInWithEmail(input, password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            await AuthService().createUserWithEmail(input, password);
          } else if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
            setState(() {
              _generalError = 'Incorrect password. Please try again.';
            });
            return;
          } else {
            setState(() {
              _generalError = e.message ?? 'Authentication error';
            });
            return;
          }
        }
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login successful'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacementNamed(context, '/farmer-dashboard');
      } else {
        final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
        final phoneNumber = '$_selectedCountryCode$digits';
        await AuthService().sendOtp(
          phoneNumber,
          onVerified: (cred) async {
            await AuthService().signInWithCredential(cred);
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/farmer-dashboard');
          },
          onFailed: (e) {
            setState(() {
              _generalError = e.message ?? 'Phone verification failed';
            });
          },
          onCodeSent: (verificationId, _) {
            _verificationId = verificationId;
            _showOtpDialog();
          },
          onAutoRetrievalTimeout: (verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } catch (e) {
      setState(() {
        _generalError =
            'Network error. Please check your connection and try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showOtpDialog() {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter OTP',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: TextField(
            controller: codeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '6-digit code'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final code = codeController.text.trim();
                if (_verificationId != null && code.isNotEmpty) {
                  try {
                    await AuthService().signInWithSmsCode(
                      verificationId: _verificationId!,
                      smsCode: code,
                    );
                    if (!mounted) return;
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, '/farmer-dashboard');
                  } catch (e) {
                    setState(() {
                      _generalError = 'Invalid code. Please try again.';
                    });
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Password reset link will be sent to your registered phone number via SMS.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset SMS sent successfully!'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Send SMS'),
          ),
        ],
      ),
    );
  }

  // No dedicated signup screen; email login will auto-create accounts when needed.

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 6.h),

                  // App Logo
                  _buildAppLogo(),

                  SizedBox(height: 6.h),

                  // Welcome Text
                  _buildWelcomeText(),

                  SizedBox(height: 4.h),

                  // Login method toggle
                  _buildLoginMethodToggle(),

                  // Phone Number Input
                  _buildPhoneNumberField(),

                  SizedBox(height: 3.h),

                  // Password Input
                  if (_loginMethod == _LoginMethod.email) _buildPasswordField(),

                  SizedBox(height: 1.h),

                  // Forgot Password Link
                  _buildForgotPasswordLink(),

                  SizedBox(height: 1.h),

                  // General Error Message
                  _buildErrorMessage(),

                  SizedBox(height: 4.h),

                  // Login Button
                  _buildLoginButton(),

                  SizedBox(height: 3.h),

                  // Biometric Authentication
                  BiometricAuthWidget(
                    onBiometricSuccess: () {
                      setState(() {
                        _loginMethod = _LoginMethod.email;
                        _phoneController.text = 'test@example.com';
                        _passwordController.text = 'StrongPass!123';
                      });
                      _handleLogin();
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Sign Up link removed (JIT account creation in email flow)

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginMethodToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Phone'),
          selected: _loginMethod == _LoginMethod.phone,
          onSelected: (_) => setState(() => _loginMethod = _LoginMethod.phone),
        ),
        SizedBox(width: 3.w),
        ChoiceChip(
          label: const Text('Email'),
          selected: _loginMethod == _LoginMethod.email,
          onSelected: (_) => setState(() => _loginMethod = _LoginMethod.email),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'agriculture',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'Farm',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Sign in to connect with agricultural workforce',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _loginMethod == _LoginMethod.email ? 'Email' : 'Phone Number',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        if (_loginMethod == _LoginMethod.phone)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: _phoneError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Row(
              children: [
                CountryCodePickerWidget(
                  selectedCountryCode: _selectedCountryCode,
                  onCountryCodeChanged: (code) {
                    setState(() {
                      _selectedCountryCode = code;
                    });
                  },
                ),
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      prefixIcon: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          )
        else
          TextFormField(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter email address',
              prefixIcon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(
                  color: _phoneError != null
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
            ),
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
        if (_phoneError != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            _phoneError!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Enter password',
            prefixIcon: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: CustomIconWidget(
                iconName: _isPasswordVisible ? 'visibility' : 'visibility_off',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: _passwordError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: _passwordError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: _passwordError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        if (_passwordError != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            _passwordError!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(
          'Forgot Password?',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return _generalError != null
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _generalError!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                'Login',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }

  // Sign Up UI removed.
}
