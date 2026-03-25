// Phone Detective - Solution Screen (Enhanced with Deduction Checklist)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../widgets/step_hint_button.dart';

class SolutionScreen extends StatefulWidget {
  const SolutionScreen({super.key});

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedSuspectId;
  bool _isSubmitting = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final solution = gameState.currentCase.solution;
    final deductions = solution.deductionChecklist;
    final redHerringCount = gameState.redHerringCount;
    final allDeductionsVerified = gameState.allDeductionsVerified;
    final canSubmit = _selectedSuspectId != null &&
        !_isSubmitting &&
        (deductions.isEmpty || allDeductionsVerified);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Solve the Case',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who is responsible?',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the guilty party based on your investigation.',
              style: GoogleFonts.roboto(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            // Suspect options
            ...solution.options.map((option) {
              final contact = gameState.currentCase.getContact(
                option.contactId,
              );
              final isSelected = _selectedSuspectId == option.contactId;
              return GestureDetector(
                onTap: () {
                  HapticService.lightTap();
                  setState(() => _selectedSuspectId = option.contactId);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            contact?.avatarColor ?? AppColors.primary,
                        child: Text(
                          contact?.initials ?? '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option.label,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ),
              );
            }),

            // Deduction Checklist
            if (deductions.isNotEmpty) ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Icon(Icons.fact_check, color: AppColors.clue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'DEDUCTION CHECKLIST',
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.clue,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${gameState.verifiedDeductionCount}/${deductions.length}',
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      color: allDeductionsVerified
                          ? AppColors.success
                          : AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Verify each deduction to unlock your accusation.',
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 16),
              // Confidence progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: deductions.isEmpty
                      ? 1.0
                      : gameState.verifiedDeductionCount / deductions.length,
                  backgroundColor: AppColors.surfaceDark,
                  color: allDeductionsVerified
                      ? AppColors.success
                      : AppColors.clue,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 16),
              ...deductions.map((deduction) {
                final isVerified = gameState.isDeductionVerified(deduction.id);
                return GestureDetector(
                  onTap: () {
                    HapticService.lightTap();
                    gameState.toggleDeduction(deduction.id);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isVerified
                          ? AppColors.success.withValues(alpha: 0.08)
                          : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isVerified
                            ? AppColors.success.withValues(alpha: 0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isVerified
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isVerified
                              ? AppColors.success
                              : AppColors.textTertiary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            deduction.statement,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: isVerified
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              height: 1.4,
                              decoration: isVerified
                                  ? TextDecoration.none
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            // Red Herring Warning
            if (redHerringCount > 0) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.warning, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Possible Red Herrings',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warning,
                            ),
                          ),
                          Text(
                            'You may have marked $redHerringCount misleading clue${redHerringCount > 1 ? 's' : ''} — review your evidence carefully.',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Step hints for final accusation
            Builder(
              builder: (context) {
                final solutionHint =
                    gameState.currentCase.getStepHintForNode('solution');
                if (solutionHint == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: StepHintButton(stepHint: solutionHint),
                );
              },
            ),
            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final glowOpacity =
                      canSubmit ? 0.3 + (_pulseController.value * 0.3) : 0.0;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: canSubmit
                          ? [
                              BoxShadow(
                                color: AppColors.success
                                    .withValues(alpha: glowOpacity),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: child,
                  );
                },
                child: ElevatedButton(
                  onPressed: canSubmit
                      ? () => _submitAnswer(gameState, solution)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    disabledBackgroundColor: AppColors.surfaceDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          deductions.isNotEmpty && !allDeductionsVerified
                              ? 'VERIFY DEDUCTIONS FIRST'
                              : 'SUBMIT ACCUSATION',
                          style: GoogleFonts.robotoMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAnswer(GameStateProvider gameState, dynamic solution) async {
    setState(() => _isSubmitting = true);
    HapticService.heavyTap();

    // Dramatic delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final selectedOption = solution.options.firstWhere(
      (o) => o.contactId == _selectedSuspectId,
    );
    final isCorrect = selectedOption.isCorrect;

    if (isCorrect) {
      await gameState.solveCase();
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.caseComplete,
          arguments: {'isCorrect': true, 'timeTaken': gameState.timePlayed},
        );
      }
    } else {
      if (mounted) {
        // Navigate to case complete with isCorrect: false to show the real culprit
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.caseComplete,
          arguments: {
            'isCorrect': false,
            'timeTaken': gameState.timePlayed,
          },
        );
      }
    }
  }
}
