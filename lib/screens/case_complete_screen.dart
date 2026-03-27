// Phone Detective - Case Complete Screen
// Shown after submitting accusation — reveals outcome, culprit details, and stats.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/case_data.dart';
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
  late AnimationController _iconController;
  late AnimationController _contentController;
  late Animation<double> _iconScale;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _iconController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _contentController.forward();
    });

    HapticService.heavyTap();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final caseData = gameState.currentCase;
    final solution = caseData.solution;
    final culprit = caseData.getContact(solution.guiltyContactId);
    final size = MediaQuery.of(context).size;

    final accentColor = widget.isCorrect ? AppColors.success : AppColors.danger;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accentColor.withValues(alpha: 0.15),
              AppColors.background,
              const Color(0xFF080810),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width < 360 ? 16 : 24,
              vertical: 24,
            ),
            child: Column(
              children: [
                // ── Outcome Icon ──
                ScaleTransition(
                  scale: _iconScale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      widget.isCorrect ? Icons.gavel : Icons.close_rounded,
                      color: accentColor,
                      size: 52,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Headline ──
                SlideTransition(
                  position: _contentSlide,
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: Column(
                      children: [
                        Text(
                          widget.isCorrect ? 'CASE CLOSED!' : 'WRONG SUSPECT',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: size.width < 360 ? 28 : 34,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          caseData.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Detective rank badge
                        _DetectiveRank(
                          isCorrect: widget.isCorrect,
                          cluesFound: gameState.currentClues.length,
                          totalClues: caseData.totalClues,
                          redHerringsMarked: gameState.redHerringCount,
                          timelineCompleted: gameState.timelineCompleted,
                        ),

                        const SizedBox(height: 24),

                        // ── Culprit Reveal ──
                        _CulpritCard(
                          isCorrect: widget.isCorrect,
                          culpritName: culprit?.fullName ?? solution.guiltyContactId,
                          culpritInitials: culprit?.initials ?? '?',
                          culpritColor: culprit?.avatarColor ?? AppColors.danger,
                          motive: solution.motive,
                          method: solution.method,
                        ),

                        const SizedBox(height: 16),

                        // ── Stats Card ──
                        _StatsCard(
                          timeTaken: widget.timeTaken,
                          cluesFound: gameState.currentClues.length,
                          totalClues: caseData.totalClues,
                          suspectsMarked: gameState.currentSuspects.length,
                        ),

                        // ── Resolution ──
                        if (widget.isCorrect &&
                            solution.resolution.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _ResolutionCard(resolution: solution.resolution),
                        ],

                        const SizedBox(height: 32),

                        // ── Rating (easy+ only, not shown for tutorial) ──
                        if (widget.isCorrect &&
                            caseData.difficulty !=
                                CaseDifficulty.tutorial) ...[
                          const SizedBox(height: 16),
                          _RatingPanel(
                            timeTaken: widget.timeTaken,
                            cluesFound: gameState.currentClues.length,
                            totalClues: caseData.totalClues,
                            redHerringsMarked: gameState.redHerringCount,
                            hintsUsed: gameState.hintsUsed,
                            difficulty: caseData.difficulty,
                          ),
                        ],

                        // ── Actions ──
                        _ActionButtons(
                          isCorrect: widget.isCorrect,
                          gameState: gameState,
                          caseNumber: caseData.caseNumber,
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
    );
  }
}

// ─── Detective Rank ──────────────────────────────────────────────────────────

class _DetectiveRank extends StatelessWidget {
  final bool isCorrect;
  final int cluesFound;
  final int totalClues;
  final int redHerringsMarked;
  final bool timelineCompleted;

  const _DetectiveRank({
    required this.isCorrect,
    required this.cluesFound,
    required this.totalClues,
    required this.redHerringsMarked,
    required this.timelineCompleted,
  });

  String get rank {
    if (!isCorrect) return '🔎 STILL LEARNING';
    double score = 0;
    if (totalClues > 0) score += (cluesFound / totalClues) * 40;
    if (redHerringsMarked == 0) score += 30;
    if (timelineCompleted) score += 30;

    if (score >= 90) return '⭐ MASTER DETECTIVE';
    if (score >= 70) return '🔍 SENIOR DETECTIVE';
    if (score >= 50) return '🕵️ DETECTIVE';
    return '📋 ROOKIE DETECTIVE';
  }

  Color get rankColor {
    if (!isCorrect) return AppColors.textSecondary;
    if (rank.contains('MASTER')) return const Color(0xFFFFD700);
    if (rank.contains('SENIOR')) return const Color(0xFFC0C0C0);
    if (rank.contains('DETECTIVE')) return const Color(0xFFCD7F32);
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: rankColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: rankColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        rank,
        style: GoogleFonts.robotoMono(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: rankColor,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// ─── Culprit Reveal Card ─────────────────────────────────────────────────────

class _CulpritCard extends StatelessWidget {
  final bool isCorrect;
  final String culpritName;
  final String culpritInitials;
  final Color culpritColor;
  final String motive;
  final String method;

  const _CulpritCard({
    required this.isCorrect,
    required this.culpritName,
    required this.culpritInitials,
    required this.culpritColor,
    required this.motive,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isCorrect ? AppColors.success : AppColors.danger)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.info_outline,
                color: isCorrect ? AppColors.success : AppColors.danger,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'THE CULPRIT WAS...' : 'THE REAL CULPRIT',
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isCorrect ? AppColors.success : AppColors.danger,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: culpritColor,
                child: Text(
                  culpritInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  culpritName,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (motive.isNotEmpty) ...[
            const SizedBox(height: 16),
            _FactRow(label: 'MOTIVE', value: motive),
          ],
          if (method.isNotEmpty) ...[
            const SizedBox(height: 10),
            _FactRow(label: 'METHOD', value: method),
          ],
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  final String label;
  final String value;

  const _FactRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoMono(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.textTertiary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ─── Stats Card ──────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  final Duration timeTaken;
  final int cluesFound;
  final int totalClues;
  final int suspectsMarked;

  const _StatsCard({
    required this.timeTaken,
    required this.cluesFound,
    required this.totalClues,
    required this.suspectsMarked,
  });

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _StatRow(
            icon: Icons.timer_outlined,
            label: 'Time',
            value: _formatDuration(timeTaken),
          ),
          const Divider(color: Colors.white12, height: 16),
          _StatRow(
            icon: Icons.bookmark,
            label: 'Clues Found',
            value: '$cluesFound / $totalClues',
            valueColor:
                cluesFound == totalClues ? AppColors.success : AppColors.clue,
          ),
          const Divider(color: Colors.white12, height: 16),
          _StatRow(
            icon: Icons.person_search,
            label: 'Suspects Marked',
            value: '$suspectsMarked',
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textTertiary, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.roboto(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── Resolution Card ─────────────────────────────────────────────────────────

class _ResolutionCard extends StatelessWidget {
  final String resolution;
  const _ResolutionCard({required this.resolution});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_stories,
                color: AppColors.primary,
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(
                'CASE RESOLUTION',
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            resolution,
            style: GoogleFonts.roboto(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rating Panel ────────────────────────────────────────────────────────────

class _RatingPanel extends StatelessWidget {
  final Duration timeTaken;
  final int cluesFound;
  final int totalClues;
  final int redHerringsMarked;
  final int hintsUsed;
  final CaseDifficulty difficulty;

  const _RatingPanel({
    required this.timeTaken,
    required this.cluesFound,
    required this.totalClues,
    required this.redHerringsMarked,
    required this.hintsUsed,
    required this.difficulty,
  });

  // Thresholds tighten with difficulty
  double get _clueThreshold {
    if (difficulty == CaseDifficulty.hard ||
        difficulty == CaseDifficulty.veryHard) {
      return 1.0; // all clues required on hard+
    }
    return 0.8; // 80% for easy / medium
  }

  int get _timeLimit {
    switch (difficulty) {
      case CaseDifficulty.veryHard:
        return 10;
      case CaseDifficulty.hard:
        return 15;
      default:
        return 20;
    }
  }

  int get stars {
    int s = 1; // always at least 1 for a correct answer
    final clueRatio = totalClues > 0 ? cluesFound / totalClues : 0.0;
    if (clueRatio >= _clueThreshold && redHerringsMarked == 0) s++;
    if (s >= 2 && hintsUsed == 0 && timeTaken.inMinutes < _timeLimit) s++;
    return s.clamp(1, 3);
  }

  @override
  Widget build(BuildContext context) {
    final s = stars;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            'PERFORMANCE RATING',
            style: GoogleFonts.robotoMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textTertiary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final filled = i < s;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: filled ? const Color(0xFFFFD700) : Colors.white24,
                  size: 40,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            s == 3
                ? 'Perfect — Master Detective'
                : s == 2
                    ? 'Good — Senior Detective'
                    : 'Solved — Rookie Detective',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: s == 3
                  ? const Color(0xFFFFD700)
                  : s == 2
                      ? const Color(0xFFC0C0C0)
                      : AppColors.textSecondary,
            ),
          ),
          if (s < 3) ...[
            const SizedBox(height: 10),
            Divider(color: Colors.white12),
            const SizedBox(height: 8),
            Text(
              _improvementHint(s),
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: AppColors.textTertiary,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  String _improvementHint(int s) {
    if (redHerringsMarked > 0) {
      return 'You marked a red herring. Stay focused on the key evidence next time.';
    }
    if (hintsUsed > 0) {
      return 'You used $hintsUsed hint${hintsUsed != 1 ? 's' : ''}. Try solving without them for a higher rating.';
    }
    if (totalClues > 0 && cluesFound < totalClues) {
      final missed = totalClues - cluesFound;
      if (difficulty == CaseDifficulty.hard ||
          difficulty == CaseDifficulty.veryHard) {
        return 'Hard cases require all $totalClues clues. You missed $missed — search every app.';
      }
      return 'You missed $missed clue${missed != 1 ? 's' : ''}. Search every app thoroughly next time.';
    }
    final limit = _timeLimit;
    return 'Solve in under ${limit}m with no hints to earn 3 stars.';
  }
}

// ─── Action Buttons ──────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final bool isCorrect;
  final GameStateProvider gameState;
  final int caseNumber;

  const _ActionButtons({
    required this.isCorrect,
    required this.gameState,
    required this.caseNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary action
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              HapticService.mediumTap();
              final nextCase = caseNumber + 1;
              if (isCorrect &&
                  nextCase <= 10 &&
                  gameState.isCaseUnlocked(nextCase)) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.caseTransition,
                  arguments: {'nextCaseNumber': nextCase},
                );
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.caseSelect);
              }
            },
            icon: Icon(
              isCorrect ? Icons.arrow_forward : Icons.folder_open,
              color: Colors.white,
            ),
            label: Text(
              isCorrect ? 'NEXT CASE' : 'CHOOSE ANOTHER CASE',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Secondary actions row
        Row(
          children: [
            // Menu
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.mainMenu,
                ),
                icon: const Icon(Icons.home, size: 16),
                label: const Text('Menu'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            if (!isCorrect) ...[
              const SizedBox(width: 12),
              // Retry
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticService.lightTap();
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.phoneHome,
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Try Again'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
