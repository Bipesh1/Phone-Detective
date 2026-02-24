// Phone Detective - Case Complete Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class CaseCompleteScreen extends StatefulWidget {
  final bool isCorrect;
  final Duration timeTaken;

  const CaseCompleteScreen({
    super.key,
    required this.isCorrect,
    required this.timeTaken,
  });

  @override
  State<CaseCompleteScreen> createState() => _CaseCompleteScreenState();
}

class _CaseCompleteScreenState extends State<CaseCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    HapticService.heavyTap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final caseData = gameState.currentCase;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.success.withValues(alpha: 0.2),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'CASE SOLVED!',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    caseData.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Detective Rank
                  _DetectiveRank(
                    cluesFound: gameState.currentClues.length,
                    totalClues: caseData.totalClues,
                    redHerringsMarked: gameState.redHerringCount,
                    timelineCompleted: gameState.timelineCompleted,
                  ),
                  const SizedBox(height: 32),
                  // Stats
                  _StatCard(
                    children: [
                      _StatRow(
                        label: 'Time Taken',
                        value: _formatDuration(widget.timeTaken),
                      ),
                      _StatRow(
                        label: 'Clues Found',
                        value:
                            '${gameState.currentClues.length}/${caseData.totalClues}',
                      ),
                      _StatRow(
                        label: 'Suspects Marked',
                        value: '${gameState.currentSuspects.length}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Resolution
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resolution',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          caseData.solution.resolution,
                          style: GoogleFonts.roboto(
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.mainMenu,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          child: const Text('MENU'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final nextCase = caseData.caseNumber + 1;
                            if (nextCase <= 10 &&
                                gameState.isCaseUnlocked(nextCase)) {
                              gameState.startCase(nextCase);
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.caseIntro,
                              );
                            } else {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.caseSelect,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('NEXT CASE'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}

class _StatCard extends StatelessWidget {
  final List<Widget> children;
  const _StatCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetectiveRank extends StatelessWidget {
  final int cluesFound;
  final int totalClues;
  final int redHerringsMarked;
  final bool timelineCompleted;

  const _DetectiveRank({
    required this.cluesFound,
    required this.totalClues,
    required this.redHerringsMarked,
    required this.timelineCompleted,
  });

  String get rank {
    double score = 0;
    if (totalClues > 0) score += (cluesFound / totalClues) * 40;
    if (redHerringsMarked == 0) score += 30;
    if (timelineCompleted) score += 30;

    if (score >= 90) return '⭐ MASTER DETECTIVE';
    if (score >= 70) return '🔍 SENIOR DETECTIVE';
    if (score >= 50) return '🕵️ DETECTIVE';
    return '📋 ROOKIE';
  }

  Color get rankColor {
    final r = rank;
    if (r.contains('MASTER')) return const Color(0xFFFFD700);
    if (r.contains('SENIOR')) return const Color(0xFFC0C0C0);
    if (r.contains('DETECTIVE')) return const Color(0xFFCD7F32);
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: rankColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: rankColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        rank,
        style: GoogleFonts.robotoMono(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: rankColor,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
