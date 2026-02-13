// Phone Detective - Splash Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _taglineController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _taglineFadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = (screenWidth * 0.105).clamp(26.0, 42.0);
    final titleLetterSpacing = screenWidth < 360
        ? 3.0
        : (screenWidth < 400 ? 5.0 : 8.0);
    final emojiSize = (screenWidth * 0.16).clamp(48.0, 72.0);
    final taglineFontSize = (screenWidth * 0.04).clamp(12.0, 16.0);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoFadeAnimation.value,
                  child: Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  // Magnifying glass icon with glow
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Text('🔍', style: TextStyle(fontSize: emojiSize)),
                  ),
                  SizedBox(height: screenWidth < 360 ? 16 : 24),
                  // Title
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'PHONE',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: titleLetterSpacing,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'DETECTIVE',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: titleLetterSpacing,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Tagline
            AnimatedBuilder(
              animation: _taglineController,
              builder: (context, child) {
                return Opacity(
                  opacity: _taglineFadeAnimation.value,
                  child: child,
                );
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Unlock the truth, one text at a time',
                  style: GoogleFonts.roboto(
                    fontSize: taglineFontSize,
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth < 360 ? 36 : 60),
            // Loading indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
