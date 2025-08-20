import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_glassmorphism_card.dart';
import '../../widgets/custom_gradient_container.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/network_status_widget.dart';
import './widgets/seasonal_background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _logoController;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoScaleAnimation;

  bool _isLoading = true;
  bool _hasConnectivity = true;
  bool _showBiometricPrompt = false;
  String _loadingStage = 'Initializing...';
  int _currentStage = 0;

  final List<String> _loadingStages = [
    'Initializing...',
    'Checking connectivity...',
    'Syncing user data...',
    'Preparing dashboard...',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _pulseController.repeat(reverse: true);
    _logoController.forward();
  }

  Future<void> _startLoadingSequence() async {
    for (int i = 0; i < _loadingStages.length; i++) {
      setState(() {
        _currentStage = i;
        _loadingStage = _loadingStages[i];
      });

      if (i == 1) {
        // Check connectivity
        await _checkConnectivity();
      }

      await Future.delayed(const Duration(milliseconds: 1200));
    }

    // Check if user has biometric setup
    await _checkBiometricSetup();
  }

  Future<void> _checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      setState(() {
        _hasConnectivity = connectivityResult != ConnectivityResult.none;
      });

      if (!_hasConnectivity) {
        await Future.delayed(const Duration(seconds: 10));
        if (!_hasConnectivity) {
          _navigateToOfflineMode();
          return;
        }
      }
    } catch (e) {
      setState(() {
        _hasConnectivity = false;
      });
    }
  }

  Future<void> _checkBiometricSetup() async {
    // Simulate biometric check
    await Future.delayed(const Duration(milliseconds: 500));

    // For returning users, show biometric prompt
    setState(() {
      _showBiometricPrompt = true;
    });
  }

  void _onBiometricSuccess() {
    HapticFeedback.lightImpact();
    _navigateToMainApp();
  }

  void _onBiometricSkip() {
    _navigateToMainApp();
  }

  void _navigateToMainApp() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  void _navigateToOfflineMode() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Enhanced seasonal background with gradient overlay
          const SeasonalBackgroundWidget(),

          // Beautiful gradient overlay
          CustomGradientContainer(
            gradientType: GradientType.background,
            child: Container(),
          ),

          // Safe area content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Network status indicator
                  NetworkStatusWidget(
                    hasConnectivity: _hasConnectivity,
                  ),

                  // Main content
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Enhanced logo with beautiful animations
                          AnimatedBuilder(
                            animation: Listenable.merge([
                              _pulseAnimation,
                              _logoRotationAnimation,
                              _logoScaleAnimation,
                            ]),
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value *
                                    _logoScaleAnimation.value,
                                child: Transform.rotate(
                                  angle: _logoRotationAnimation.value,
                                  child: CustomGlassmorphismCard(
                                    height: 140,
                                    width: 140,
                                    borderRadius: BorderRadius.circular(70),
                                    opacity: 0.2,
                                    blurRadius: 30,
                                    child: Center(
                                      child: ShaderMask(
                                        shaderCallback: (bounds) {
                                          return AppTheme.getPrimaryGradient()
                                              .createShader(bounds);
                                        },
                                        child: Text(
                                          'FC',
                                          style: GoogleFonts.inter(
                                            fontSize: 40.sp,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 24.h),

                          // Enhanced app title with gradient text
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return AppTheme.getPrimaryGradient()
                                  .createShader(bounds);
                            },
                            child: Text(
                              'FarmConnect',
                              style: GoogleFonts.inter(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Enhanced subtitle with beautiful styling
                          CustomGlassmorphismCard(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            opacity: 0.15,
                            blurRadius: 15,
                            child: Text(
                              'Connecting Farmers & Workers',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 64.h),

                          // Enhanced loading indicator
                          CustomGlassmorphismCard(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 20),
                            opacity: 0.15,
                            blurRadius: 20,
                            child: LoadingIndicatorWidget(
                              stage: _loadingStage,
                              progress:
                                  (_currentStage + 1) / _loadingStages.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Enhanced bottom section
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        // Biometric prompt
                        if (_showBiometricPrompt)
                          CustomGlassmorphismCard(
                            opacity: 0.2,
                            blurRadius: 25,
                            child: BiometricPromptWidget(
                              onSuccess: _onBiometricSuccess,
                              onSkip: _onBiometricSkip,
                            ),
                          ),

                        SizedBox(height: 16.h),

                        // Enhanced app version and compliance
                        CustomGlassmorphismCard(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          opacity: 0.1,
                          blurRadius: 10,
                          child: Text(
                            'Version 1.0.0 • Agricultural Labor Compliant',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
