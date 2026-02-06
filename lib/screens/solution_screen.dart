// Phone Detective - Solution Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class SolutionScreen extends StatefulWidget {
  const SolutionScreen({super.key});

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  String? _selectedSuspectId;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final solution = gameState.currentCase.solution;

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
            const SizedBox(height: 32),
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
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedSuspectId == null || _isSubmitting
                    ? null
                    : () => _submitAnswer(gameState, solution),
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
                        'SUBMIT ANSWER',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    await Future.delayed(const Duration(seconds: 1));

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
      setState(() => _isSubmitting = false);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.backgroundSecondary,
            title: Text(
              'Not Quite...',
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
            ),
            content: Text(
              selectedOption.feedback,
              style: GoogleFonts.roboto(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }
    }
  }
}
