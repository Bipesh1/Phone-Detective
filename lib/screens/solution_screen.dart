// Phone Detective - Accusation Screen
// Player names their suspect from all contacts, picks a motive, then locks in.
// No multiple-choice list — they must identify the culprit themselves.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/contact.dart';
import '../models/case_data.dart';
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
  String? _selectedMotiveId;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final caseData = gameState.currentCase;
    final contacts = caseData.contacts;
    final motiveOptions = caseData.solution.motiveOptions;

    final canSubmit = _selectedSuspectId != null &&
        !_isSubmitting &&
        (motiveOptions.isEmpty || _selectedMotiveId != null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CASE ${caseData.caseNumber.toString().padLeft(2, '0')}',
          style: GoogleFonts.robotoMono(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: caseData.themeColor,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.danger.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.gavel,
                      color: AppColors.danger,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'MAKE YOUR ACCUSATION',
                    style: GoogleFonts.robotoMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.danger,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Trust your investigation. This cannot be undone.',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Suspect Section ──
            _SectionHeader(
              label: 'WHO IS RESPONSIBLE?',
              description: 'Select the person you believe committed this crime.',
            ),
            const SizedBox(height: 14),

            ...contacts.map(
              (contact) => _SuspectOption(
                contact: contact,
                isSelected: _selectedSuspectId == contact.id,
                isSuspected: gameState.isSuspect(contact.id),
                onTap: () {
                  HapticService.lightTap();
                  setState(() => _selectedSuspectId = contact.id);
                },
              ),
            ),

            // ── Motive Section ──
            if (motiveOptions.isNotEmpty) ...[
              const SizedBox(height: 32),
              _SectionHeader(
                label: 'WHAT DROVE THEM?',
                description:
                    'Based on the evidence, what was their motive?',
              ),
              const SizedBox(height: 14),
              ...motiveOptions.map(
                (motive) => _MotiveOption(
                  motive: motive,
                  isSelected: _selectedMotiveId == motive.id,
                  onTap: () {
                    HapticService.lightTap();
                    setState(() => _selectedMotiveId = motive.id);
                  },
                ),
              ),
            ],

            const SizedBox(height: 40),

            // ── Submit Button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: canSubmit
                    ? () => _showConfirmation(context, gameState)
                    : null,
                icon: const Icon(Icons.gavel, size: 20),
                label: Text(
                  motiveOptions.isNotEmpty && _selectedMotiveId == null
                      ? 'SELECT A MOTIVE FIRST'
                      : _selectedSuspectId == null
                          ? 'SELECT A SUSPECT FIRST'
                          : 'LOCK IN ACCUSATION',
                  style: GoogleFonts.robotoMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSubmit
                      ? AppColors.danger
                      : AppColors.surfaceDark,
                  disabledBackgroundColor: AppColors.surfaceDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            if (canSubmit) ...[
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Once submitted, the case closes permanently.',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context, GameStateProvider gameState) {
    HapticService.mediumTap();
    final contact = gameState.currentCase.getContact(_selectedSuspectId!);
    final name = contact?.fullName ?? _selectedSuspectId!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Final Accusation',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.gavel,
                color: AppColors.danger,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'You are accusing',
              style: GoogleFonts.roboto(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.danger,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'There is no going back. Are you certain?',
              style: GoogleFonts.roboto(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Reconsider',
              style: GoogleFonts.roboto(color: AppColors.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submitAccusation(gameState);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "I'm Certain",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAccusation(GameStateProvider gameState) async {
    setState(() => _isSubmitting = true);
    HapticService.heavyTap();

    await Future.delayed(const Duration(milliseconds: 1500));

    final solution = gameState.currentCase.solution;
    final suspectCorrect = _selectedSuspectId == solution.guiltyContactId;

    bool? motiveCorrect;
    if (_selectedMotiveId != null && solution.motiveOptions.isNotEmpty) {
      final selectedMotive = solution.motiveOptions.firstWhere(
        (m) => m.id == _selectedMotiveId,
        orElse: () => solution.motiveOptions.first,
      );
      motiveCorrect = selectedMotive.isCorrect;
    }

    if (suspectCorrect) {
      await gameState.solveCase();
    }

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.caseComplete,
        arguments: {
          'isCorrect': suspectCorrect,
          'timeTaken': gameState.timePlayed,
          'motiveCorrect': motiveCorrect,
        },
      );
    }
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final String description;

  const _SectionHeader({required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textTertiary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: GoogleFonts.roboto(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── Suspect Option ───────────────────────────────────────────────────────────

class _SuspectOption extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final bool isSuspected;
  final VoidCallback onTap;

  const _SuspectOption({
    required this.contact,
    required this.isSelected,
    required this.isSuspected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.danger.withValues(alpha: 0.1)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.danger
                : Colors.white.withValues(alpha: 0.06),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color:
                  isSelected ? AppColors.danger : AppColors.textTertiary,
              size: 22,
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor: contact.avatarColor,
              child: Text(
                contact.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.fullName,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (contact.relationship != null &&
                      contact.relationship!.isNotEmpty)
                    Text(
                      contact.relationship!,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            if (isSuspected)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'SUSPECT',
                  style: GoogleFonts.robotoMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                    letterSpacing: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Motive Option ────────────────────────────────────────────────────────────

class _MotiveOption extends StatelessWidget {
  final MotiveOption motive;
  final bool isSelected;
  final VoidCallback onTap;

  const _MotiveOption({
    required this.motive,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.06),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color:
                  isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                motive.text,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
