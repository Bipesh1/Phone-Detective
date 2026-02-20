import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/step_hint.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

/// A button that progressively reveals step-by-step hints.
/// Each tap reveals the next hint (from vague to spoiler).
class StepHintButton extends StatelessWidget {
  final StepHint stepHint;

  const StepHintButton({super.key, required this.stepHint});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final revealedCount = gameState.getRevealedHintCount(stepHint.id);
    final totalHints = stepHint.hints.length;
    final allRevealed = revealedCount >= totalHints;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Revealed hints
        if (revealedCount > 0) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.clue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.clue.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.tips_and_updates,
                        size: 16, color: AppColors.clue),
                    const SizedBox(width: 6),
                    Text(
                      'HINTS ($revealedCount/$totalHints)',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.clue,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...List.generate(revealedCount, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < revealedCount - 1 ? 8 : 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.clue.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.robotoMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.clue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            stepHint.hints[index],
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: index == revealedCount - 1
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              height: 1.4,
                              fontWeight: index == revealedCount - 1
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Reveal button
        if (!allRevealed)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                HapticService.lightTap();
                gameState.revealNextHint(stepHint.id, totalHints);
              },
              icon: Icon(
                revealedCount == 0 ? Icons.lightbulb_outline : Icons.lightbulb,
                size: 16,
                color: AppColors.clue,
              ),
              label: Text(
                revealedCount == 0
                    ? 'Need a hint?'
                    : revealedCount == totalHints - 1
                        ? 'Reveal answer (spoiler!)'
                        : 'Next hint (${revealedCount + 1}/$totalHints)',
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: revealedCount == totalHints - 1
                      ? AppColors.danger
                      : AppColors.clue,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: revealedCount == totalHints - 1
                      ? AppColors.danger.withValues(alpha: 0.4)
                      : AppColors.clue.withValues(alpha: 0.3),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          )
        else
          Center(
            child: Text(
              'All hints revealed',
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
