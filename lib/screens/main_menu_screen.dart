// Phone Detective - Main Menu Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/animated_button.dart';
import '../services/haptic_service.dart';
import 'help_screen.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    final titleFontSize = (screenWidth * 0.115).clamp(28.0, 48.0);
    final titleLetterSpacing = screenWidth < 360
        ? 2.0
        : (screenWidth < 400 ? 4.0 : 6.0);
    final emojiSize = (screenWidth * 0.13).clamp(36.0, 56.0);
    final badgeFontSize = (screenWidth * 0.035).clamp(11.0, 14.0);
    final buttonWidth = (screenWidth * 0.68).clamp(200.0, 300.0);
    final titleSpacing = screenWidth < 360 ? 40.0 : 60.0;

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
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 360 ? 16 : 32,
                vertical: screenWidth < 400 ? 24 : 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  FadeTransition(
                    opacity: _titleController,
                    child: Column(
                      children: [
                        Text('🔍', style: TextStyle(fontSize: emojiSize)),
                        SizedBox(height: screenWidth < 360 ? 10 : 16),
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
                              fontSize: badgeFontSize,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: titleSpacing),

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
                          Navigator.pushNamed(context, AppRoutes.caseIntro);
                        },
                        width: buttonWidth,
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
                          width: buttonWidth,
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
                        width: buttonWidth,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Bottom buttons - FIXED with responsive layout
                  SlideTransition(
                    position: _buttonSlideAnimations[3],
                    child: FadeTransition(
                      opacity: _buttonsController,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isSmallScreen = constraints.maxWidth < 340;

                          return Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: isSmallScreen ? 12 : 24,
                            runSpacing: 12,
                            children: [
                              _buildMenuButton(
                                icon: Icons.settings,
                                label: 'Settings',
                                onPressed: () {
                                  HapticService.lightTap();
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.settings,
                                  );
                                },
                              ),
                              _buildMenuButton(
                                icon: Icons.help_outline,
                                label: 'How to Play',
                                onPressed: () {
                                  HapticService.lightTap();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HelpScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildMenuButton(
                                icon: Icons.info_outline,
                                label: 'Credits',
                                onPressed: () {
                                  HapticService.lightTap();
                                  _showCreditsDialog();
                                },
                              ),
                            ],
                          );
                        },
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

  // Helper method to build responsive menu buttons
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, color: AppColors.textSecondary, size: 18),
      label: Text(
        label,
        style: GoogleFonts.roboto(color: AppColors.textSecondary, fontSize: 14),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
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
