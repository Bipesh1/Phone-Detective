// Phone Detective - Main Menu Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/animated_button.dart';
import '../services/haptic_service.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _buttonsController;
  late List<Animation<Offset>> _buttonSlideAnimations;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonSlideAnimations = List.generate(5, (index) {
      final start = index * 0.1;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _buttonsController,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    _titleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _buttonsController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A1628),
              AppColors.background,
              const Color(0xFF0A0A12),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  FadeTransition(
                    opacity: _titleController,
                    child: Column(
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 56)),
                        const SizedBox(height: 16),
                        Text(
                          'PHONE',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 6,
                          ),
                        ),
                        Text(
                          'DETECTIVE',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '10 Cases to Solve',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Buttons
                  SlideTransition(
                    position: _buttonSlideAnimations[0],
                    child: FadeTransition(
                      opacity: _buttonsController,
                      child: AnimatedButton(
                        text: 'NEW GAME',
                        icon: Icons.play_arrow_rounded,
                        onPressed: () {
                          HapticService.mediumTap();
                          gameState.startCase(1);
                          Navigator.pushNamed(context, AppRoutes.phoneHome);
                        },
                        width: 260,
                      ),
                    ),
                  ),
                  if (gameState.hasSaveData) ...[
                    const SizedBox(height: 16),
                    SlideTransition(
                      position: _buttonSlideAnimations[1],
                      child: FadeTransition(
                        opacity: _buttonsController,
                        child: AnimatedButton(
                          text: 'CONTINUE',
                          icon: Icons.play_circle_outline,
                          onPressed: () {
                            HapticService.lightTap();
                            Navigator.pushNamed(context, AppRoutes.phoneHome);
                          },
                          isPrimary: false,
                          width: 260,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _buttonSlideAnimations[2],
                    child: FadeTransition(
                      opacity: _buttonsController,
                      child: AnimatedButton(
                        text: 'CASE SELECT',
                        icon: Icons.folder_open,
                        onPressed: () {
                          HapticService.lightTap();
                          Navigator.pushNamed(context, AppRoutes.caseSelect);
                        },
                        isOutlined: true,
                        width: 260,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Bottom buttons
                  SlideTransition(
                    position: _buttonSlideAnimations[3],
                    child: FadeTransition(
                      opacity: _buttonsController,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              HapticService.lightTap();
                              Navigator.pushNamed(context, AppRoutes.settings);
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            label: Text(
                              'Settings',
                              style: GoogleFonts.roboto(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          TextButton.icon(
                            onPressed: () {
                              HapticService.lightTap();
                              _showCreditsDialog();
                            },
                            icon: const Icon(
                              Icons.info_outline,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            label: Text(
                              'Credits',
                              style: GoogleFonts.roboto(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreditsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Credits',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone Detective',
              style: GoogleFonts.roboto(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A mystery investigation game built with Flutter.',
              style: GoogleFonts.roboto(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.roboto(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.roboto(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
