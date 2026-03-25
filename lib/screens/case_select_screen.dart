// Phone Detective - Case Select Screen
// Displays all available cases with unlock state, difficulty, and per-case progress.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/case_data.dart';
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
    final solvedCount = gameState.solvedCases.length;
    final totalCount = gameState.cases.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CASE FILES',
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$solvedCount of $totalCount solved',
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress bar at the top
          if (totalCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalCount > 0 ? solvedCount / totalCount : 0,
                      backgroundColor: AppColors.surfaceDark,
                      color: AppColors.success,
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              itemCount: gameState.cases.length,
              itemBuilder: (context, index) {
                final caseData = gameState.cases[index];
                final isUnlocked = gameState.isCaseUnlocked(caseData.caseNumber);
                final isSolved = gameState.isCaseSolved(caseData.caseNumber);
                final cluesFound = gameState.getClueCountForCase(caseData.caseNumber);
                final hasProgress = gameState.hasSavedProgressForCase(
                  caseData.caseNumber,
                );
                final isActive =
                    gameState.currentCaseNumber == caseData.caseNumber;

                return _CaseCard(
                  caseData: caseData,
                  isUnlocked: isUnlocked,
                  isSolved: isSolved,
                  isActive: isActive,
                  cluesFound: cluesFound,
                  hasProgress: hasProgress,
                  onTap: () => _onCaseTap(caseData, isUnlocked, gameState),
                );
              },
            ),
          ),
        ],
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
      _showLockedDialog(caseData);
      return;
    }
    HapticService.mediumTap();
    _showCaseBottomSheet(caseData, gameState);
  }

  void _showLockedDialog(CaseData caseData) {
    // Use DB unlock_requires if set, else fallback to hardcoded map
    final requirements = caseData.unlockRequires.isNotEmpty
        ? caseData.unlockRequires
        : (CaseUnlock.requirements[caseData.caseNumber] ?? []);
    final reqText = requirements.isEmpty
        ? 'Complete earlier cases to unlock.'
        : 'Complete Case${requirements.length > 1 ? 's' : ''} ${requirements.map((r) => '#$r').join(', ')} first.';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lock, color: AppColors.textSecondary, size: 22),
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
          reqText,
          style: GoogleFonts.roboto(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Got it',
              style: GoogleFonts.roboto(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showCaseBottomSheet(CaseData caseData, GameStateProvider gameState) {
    final hasProgress = gameState.hasSavedProgressForCase(caseData.caseNumber);
    final isSolved = gameState.isCaseSolved(caseData.caseNumber);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
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
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Case badge + difficulty
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: caseData.difficulty.color
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: caseData.difficulty.color
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              'CASE ${caseData.caseNumber.toString().padLeft(2, '0')}',
                              style: GoogleFonts.robotoMono(
                                color: caseData.difficulty.color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Stars
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < caseData.difficulty.stars
                                    ? Icons.star
                                    : Icons.star_outline,
                                size: 14,
                                color: i < caseData.difficulty.stars
                                    ? caseData.difficulty.color
                                    : AppColors.surfaceLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            caseData.difficulty.label,
                            style: GoogleFonts.roboto(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Text(
                        caseData.title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        caseData.subtitle,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Scenario
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          caseData.scenario,
                          style: GoogleFonts.roboto(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.65,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Case objective
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: caseData.themeColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: caseData.themeColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.flag_rounded,
                              color: caseData.themeColor,
                              size: 16,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                caseData.objective,
                                style: GoogleFonts.roboto(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Start or Continue button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            HapticService.heavyTap();
                            gameState.startCase(caseData.caseNumber);
                            Navigator.pop(ctx);
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.caseIntro,
                            );
                          },
                          icon: Icon(
                            hasProgress && !isSolved
                                ? Icons.play_arrow
                                : Icons.search,
                            color: Colors.white,
                          ),
                          label: Text(
                            hasProgress && !isSolved
                                ? 'CONTINUE INVESTIGATION'
                                : isSolved
                                    ? 'REPLAY CASE'
                                    : 'START INVESTIGATION',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: caseData.themeColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor:
                                caseData.themeColor.withValues(alpha: 0.4),
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
    );
  }
}

// ─── Case Card ───────────────────────────────────────────────────────────────

class _CaseCard extends StatelessWidget {
  final CaseData caseData;
  final bool isUnlocked;
  final bool isSolved;
  final bool isActive;
  final int cluesFound;
  final bool hasProgress;
  final VoidCallback onTap;

  const _CaseCard({
    required this.caseData,
    required this.isUnlocked,
    required this.isSolved,
    required this.isActive,
    required this.cluesFound,
    required this.hasProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSolved
        ? AppColors.success.withValues(alpha: 0.45)
        : isActive
            ? AppColors.primary.withValues(alpha: 0.5)
            : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Row(
          children: [
            // Case number badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: isUnlocked
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          caseData.difficulty.color,
                          caseData.difficulty.color.withValues(alpha: 0.55),
                        ],
                      )
                    : null,
                color: isUnlocked ? null : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        caseData.caseNumber.toString().padLeft(2, '0'),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.lock,
                        color: AppColors.textTertiary,
                        size: 22,
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caseData.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caseData.subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Difficulty stars
                      ...List.generate(
                        caseData.difficulty.stars,
                        (i) => Icon(
                          Icons.star,
                          size: 11,
                          color: isUnlocked
                              ? caseData.difficulty.color
                              : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Progress label
                      if (isUnlocked && hasProgress && !isSolved)
                        _ProgressLabel(
                          cluesFound: cluesFound,
                          totalClues: caseData.totalClues,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Status badge
            _StatusBadge(isUnlocked: isUnlocked, isSolved: isSolved),
          ],
        ),
      ),
    );
  }
}

class _ProgressLabel extends StatelessWidget {
  final int cluesFound;
  final int totalClues;

  const _ProgressLabel({required this.cluesFound, required this.totalClues});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.bookmark, color: AppColors.clue, size: 11),
        const SizedBox(width: 3),
        Text(
          '$cluesFound/$totalClues clues',
          style: GoogleFonts.roboto(
            fontSize: 11,
            color: AppColors.clue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isUnlocked;
  final bool isSolved;

  const _StatusBadge({required this.isUnlocked, required this.isSolved});

  @override
  Widget build(BuildContext context) {
    if (isSolved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 12),
            const SizedBox(width: 4),
            Text(
              'Solved',
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      );
    }

    if (!isUnlocked) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.lock_outline, color: AppColors.textTertiary, size: 18),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        'Open',
        style: GoogleFonts.roboto(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
