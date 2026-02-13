// Phone Detective - Case Select Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/case_data.dart';
// import '../data/cases/all_cases.dart'; // Removed to prevent accidental usage

import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class CaseSelectScreen extends StatefulWidget {
  const CaseSelectScreen({super.key});

  @override
  State<CaseSelectScreen> createState() => _CaseSelectScreenState();
}

class _CaseSelectScreenState extends State<CaseSelectScreen> {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SELECT A CASE',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: gameState.cases.length,
        itemBuilder: (context, index) {
          final caseData = gameState.cases[index];
          final isUnlocked = gameState.isCaseUnlocked(caseData.caseNumber);
          final isSolved = gameState.isCaseSolved(caseData.caseNumber);
          final cluesFound = gameState.currentCaseNumber == caseData.caseNumber
              ? gameState.currentClues.length
              : 0;

          return _CaseCard(
            caseData: caseData,
            isUnlocked: isUnlocked,
            isSolved: isSolved,
            cluesFound: cluesFound,
            onTap: () => _onCaseTap(caseData, isUnlocked, gameState),
          );
        },
      ),
    );
  }

  void _onCaseTap(
    CaseData caseData,
    bool isUnlocked,
    GameStateProvider gameState,
  ) {
    if (!isUnlocked) {
      HapticService.lightTap();
      _showLockedDialog();
      return;
    }

    HapticService.mediumTap();
    _showCaseIntro(caseData, gameState);
  }

  void _showLockedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lock, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(
              'Case Locked',
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Complete previous cases to unlock this mystery.',
          style: GoogleFonts.roboto(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.roboto(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showCaseIntro(CaseData caseData, GameStateProvider gameState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Case number badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: caseData.difficulty.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'CASE ${caseData.caseNumber}',
                        style: GoogleFonts.roboto(
                          color: caseData.difficulty.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      caseData.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Difficulty
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: 16,
                            color: i < caseData.difficulty.stars
                                ? caseData.difficulty.color
                                : AppColors.surfaceLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          caseData.difficulty.label,
                          style: GoogleFonts.roboto(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Scenario
                    Text(
                      caseData.scenario,
                      style: GoogleFonts.roboto(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Start button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticService.heavyTap();
                          gameState.startCase(caseData.caseNumber);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.caseIntro,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'START INVESTIGATION',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
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
    );
  }
}

class _CaseCard extends StatelessWidget {
  final CaseData caseData;
  final bool isUnlocked;
  final bool isSolved;
  final int cluesFound;
  final VoidCallback onTap;

  const _CaseCard({
    required this.caseData,
    required this.isUnlocked,
    required this.isSolved,
    required this.cluesFound,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
          border: isSolved
              ? Border.all(color: AppColors.success.withValues(alpha: 0.5))
              : null,
        ),
        child: Row(
          children: [
            // Case number badge
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: isUnlocked
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          caseData.difficulty.color,
                          caseData.difficulty.color.withValues(alpha: 0.6),
                        ],
                      )
                    : null,
                color: isUnlocked ? null : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        '${caseData.caseNumber}',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.lock,
                        color: AppColors.textTertiary,
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caseData.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    caseData.subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Difficulty stars
                      ...List.generate(
                        caseData.difficulty.stars,
                        (i) => Icon(
                          Icons.star,
                          size: 12,
                          color: isUnlocked
                              ? caseData.difficulty.color
                              : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Progress
                      if (isUnlocked && cluesFound > 0)
                        Text(
                          'Clues: $cluesFound/${caseData.totalClues}',
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSolved
                    ? AppColors.success.withValues(alpha: 0.2)
                    : isUnlocked
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isSolved
                    ? '✅ Solved'
                    : isUnlocked
                    ? '🔓 Available'
                    : '🔒 Locked',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSolved
                      ? AppColors.success
                      : isUnlocked
                      ? AppColors.primary
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
