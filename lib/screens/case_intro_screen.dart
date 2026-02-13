// Phone Detective - Case Introduction Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../models/contact.dart';

class CaseIntroScreen extends StatefulWidget {
  const CaseIntroScreen({super.key});

  @override
  State<CaseIntroScreen> createState() => _CaseIntroScreenState();
}

class _CaseIntroScreenState extends State<CaseIntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _typewriterController;
  late AnimationController _objectiveController;
  late AnimationController _buttonController;

  String _displayedScenario = '';
  bool _scenarioComplete = false;
  bool _showObjective = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _objectiveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeController.forward();

    // Start typewriter effect after header fades in
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _startTypewriter();
    });
  }

  void _startTypewriter() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    final scenario = gameState.currentCase.scenario;

    _typewriterController.addListener(() {
      if (!mounted) return;
      final charCount = (_typewriterController.value * scenario.length).round();
      setState(() {
        _displayedScenario = scenario.substring(0, charCount);
      });
    });

    _typewriterController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _scenarioComplete = true);
        _showObjectiveSection();
      }
    });

    _typewriterController.forward();
  }

  void _showObjectiveSection() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _showObjective = true);
      _objectiveController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          setState(() => _showButton = true);
          _buttonController.forward();
        });
      });
    });
  }

  void _skipAnimation() {
    if (_scenarioComplete) return;
    _typewriterController.value = 1.0;
  }

  void _startInvestigation() {
    HapticService.heavyTap();
    final gameState = Provider.of<GameStateProvider>(context, listen: false);

    // Find the "owner" contact to get their name
    final owner = gameState.currentCase.contacts.firstWhere(
      (c) => c.relationship == 'Phone Owner' || c.id == 'owner' || c.id == 'me',
      orElse: () => Contact(
        id: 'owner',
        firstName: 'Unknown',
        lastName: 'Device',
        phoneNumber: '',
        relationship: 'Owner',
        avatarColor: Colors.grey,
      ),
    );

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.hackingSimulator,
      arguments: {
        'targetName': '${owner.firstName} ${owner.lastName}\'s Phone'
      },
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _typewriterController.dispose();
    _objectiveController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final caseData = gameState.currentCase;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: _skipAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                caseData.themeColor.withValues(alpha: 0.15),
                AppColors.background,
                const Color(0xFF0A0A12),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width < 360 ? 16 : 28,
                vertical: MediaQuery.of(context).size.width < 400 ? 20 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  FadeTransition(
                    opacity: _fadeController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Case number badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: caseData.themeColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: caseData.themeColor.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            'CASE ${caseData.caseNumber}'
                                .padLeft(7, '0')
                                .substring(0, 7),
                            style: GoogleFonts.robotoMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: caseData.themeColor,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Case title
                        Text(
                          caseData.title,
                          style: GoogleFonts.playfairDisplay(
                            fontSize:
                                (MediaQuery.of(context).size.width * 0.078)
                                    .clamp(22.0, 32.0),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          caseData.subtitle,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                caseData.themeColor.withValues(alpha: 0.6),
                                caseData.themeColor.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Opening Story section
                  FadeTransition(
                    opacity: _fadeController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_stories,
                              color: caseData.themeColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'BRIEFING',
                              style: GoogleFonts.robotoMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: caseData.themeColor,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Typewriter text
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary.withValues(
                              alpha: 0.7,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.surfaceDark),
                          ),
                          child: Text(
                            _displayedScenario.isEmpty
                                ? ' '
                                : _displayedScenario,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                              height: 1.7,
                            ),
                          ),
                        ),

                        // Tap to skip hint
                        if (!_scenarioComplete)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Center(
                              child: Text(
                                'Tap anywhere to skip',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Mission Objective
                  if (_showObjective) ...[
                    const SizedBox(height: 28),
                    FadeTransition(
                      opacity: _objectiveController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _objectiveController,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                caseData.themeColor.withValues(alpha: 0.15),
                                caseData.themeColor.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: caseData.themeColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.flag_rounded,
                                    color: caseData.themeColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'MISSION OBJECTIVE',
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: caseData.themeColor,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                caseData.objective,
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Difficulty badge
                  if (_showObjective) ...[
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _objectiveController,
                      child: Row(
                        children: [
                          _buildInfoChip(
                            Icons.signal_cellular_alt,
                            caseData.difficulty.name.toUpperCase(),
                            caseData.themeColor,
                          ),
                          const SizedBox(width: 12),
                          _buildInfoChip(
                            Icons.search,
                            '${caseData.totalClues} CLUES',
                            AppColors.clue,
                          ),
                        ],
                      ),
                    ),
                  ],

                  // How to Investigate Guide
                  if (_showObjective) ...[
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: _objectiveController,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                AppColors.textTertiary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.tips_and_updates,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'HOW TO INVESTIGATE',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTipRow(
                              Icons.smartphone,
                              'Check Messages, Calls, Emails, Notes, and Gallery',
                            ),
                            const SizedBox(height: 12),
                            _buildTipRow(
                              Icons.touch_app,
                              'Long-press any item to mark as evidence',
                            ),
                            const SizedBox(height: 12),
                            _buildTipRow(
                              Icons.bookmark,
                              'Review collected clues in Detective Journal',
                            ),
                            const SizedBox(height: 12),
                            _buildTipRow(
                              Icons.gavel,
                              'When ready, tap "Solve Case" in the Journal',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Start button
                  if (_showButton) ...[
                    const SizedBox(height: 36),
                    FadeTransition(
                      opacity: _buttonController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _buttonController,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _startInvestigation,
                            icon: const Icon(Icons.phone_android, size: 22),
                            label: Text(
                              'BEGIN INVESTIGATION',
                              style: GoogleFonts.robotoMono(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: caseData.themeColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                              shadowColor: caseData.themeColor.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, color: AppColors.textSecondary, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.robotoMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
