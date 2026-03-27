// Phone Detective - Deduction Unlock Overlay
// Shown when all clues linked to a deduction item have been collected.
// Less dramatic than RevelationOverlay — a quiet "you connected the dots" moment.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class DeductionUnlockOverlay {
  static void show({
    required BuildContext context,
    required String statement,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (ctx) => _DeductionDialog(statement: statement),
    );
  }
}

class _DeductionDialog extends StatefulWidget {
  final String statement;

  const _DeductionDialog({required this.statement});

  @override
  State<_DeductionDialog> createState() => _DeductionDialogState();
}

class _DeductionDialogState extends State<_DeductionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  Timer? _autoClose;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    // Auto-dismiss after 5 seconds
    _autoClose = Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _autoClose?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.clue.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.clue.withValues(alpha: 0.15),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.psychology, color: AppColors.clue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'DEDUCTION UNLOCKED',
                    style: GoogleFonts.robotoMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.clue,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Divider
              Divider(color: AppColors.clue.withValues(alpha: 0.2), height: 1),
              const SizedBox(height: 16),
              // Statement
              Text(
                widget.statement,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Got it button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.clue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.clue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Got it',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.clue,
                    ),
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
