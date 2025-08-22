import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_glassmorphism_card.dart';
import '../../../widgets/custom_gradient_container.dart';
import '../../../core/services/ai/agents/multi_agent_orchestrator.dart';
import '../../../core/services/ai/precautions_service.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;
  final _ai = MultiAgentOrchestrator();
  final _precautions = PrecautionsService();
  List<String> _advisories = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomGradientContainer(
                gradientType: GradientType.primary,
                padding: EdgeInsets.all(6.w),
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.getElevatedShadow(),
                child: Stack(
                  children: [
                    // Background decoration
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Main content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Weather',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleLarge
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'location_on',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                            .withValues(alpha: 0.8),
                                        size: 16,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        'Rajkot, Gujarat',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary
                                              .withValues(alpha: 0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CustomGlassmorphismCard(
                              padding: EdgeInsets.all(3.w),
                              borderRadius: BorderRadius.circular(20),
                              opacity: 0.2,
                              child: CustomIconWidget(
                                iconName: 'wb_sunny',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 40,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 3.h),

                        // Temperature and Weather Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withValues(alpha: 0.7),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    '—',
                                    style: AppTheme
                                        .lightTheme.textTheme.displayMedium
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                FutureBuilder<String>(
                                  future: _ai.route('weather forecast'),
                                  builder: (context, snapshot) {
                                    final txt = snapshot.data ??
                                        'Fetching local forecast...';
                                    return Text(
                                      txt,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                            .withValues(alpha: 0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomGlassmorphismCard(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  borderRadius: BorderRadius.circular(16),
                                  opacity: 0.2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'water_drop',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 18,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        '65%',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                CustomGlassmorphismCard(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  borderRadius: BorderRadius.circular(16),
                                  opacity: 0.2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'air',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 18,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        '12 km/h',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 3.h),

                        // Weather Recommendation
                        CustomGlassmorphismCard(
                          padding: EdgeInsets.all(4.w),
                          borderRadius: BorderRadius.circular(16),
                          opacity: 0.2,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: 'lightbulb',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Farm Recommendation',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    FutureBuilder<List<String>>(
                                      future:
                                          _precautions.getPrecautions(crop: 'Tomato'),
                                      builder: (context, snap) {
                                        _advisories = snap.data ?? _advisories;
                                        final first = _advisories.isNotEmpty
                                            ? _advisories.first
                                            : 'Stay updated with local advisories.';
                                        return Text(
                                          first,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.colorScheme.onPrimary
                                                .withValues(alpha: 0.9),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
