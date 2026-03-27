// Phone Detective - Revelation Overlay
// Full-screen flash shown when all key clues are collected.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class RevelationOverlay {
  /// Show the "CASE CRACKED" flash when all key clues are found.
  static void show({
    required BuildContext context,
    required String lastCluePreview,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(scale: Tween(begin: 1.1, end: 1.0).animate(anim), child: child),
      ),
      pageBuilder: (ctx, _, __) => _RevelationDialog(lastCluePreview: lastCluePreview),
    );
  }
}

class _RevelationDialog extends StatefulWidget {
  final String lastCluePreview;
  const _RevelationDialog({required this.lastCluePreview});

  @override
  State<_RevelationDialog> createState() => _RevelationDialogState();
}

class _RevelationDialogState extends State<_RevelationDialog>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _contentController;
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    HapticService.heavyTap();

    // Show action buttons after 2.5s
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _showActions = true);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: FadeTransition(
          opacity: _contentController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Flash icon
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) => Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.clue.withValues(
                        alpha: 0.1 + _pulseController.value * 0.15,
                      ),
                      border: Border.all(
                        color: AppColors.clue.withValues(
                          alpha: 0.4 + _pulseController.value * 0.4,
                        ),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.clue.withValues(
                            alpha: 0.2 + _pulseController.value * 0.3,
                          ),
                          blurRadius: 24 + _pulseController.value * 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.search,
                      color: AppColors.clue,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Headline
                Text(
                  'CASE CRACKED',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.clue,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'You found all the evidence.',
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Last clue preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.clue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.clue.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FINAL CLUE',
                        style: GoogleFonts.robotoMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.clue,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.lastCluePreview,
                        style: GoogleFonts.roboto(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Action buttons — appear after delay
                if (_showActions) ...[
                  AnimatedOpacity(
                    opacity: _showActions ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              HapticService.mediumTap();
                              Navigator.of(context).pop(); // dismiss overlay
                              Navigator.pushNamed(
                                context,
                                AppRoutes.detectiveJournal,
                              );
                            },
                            icon: const Icon(Icons.menu_book, color: Colors.black87),
                            label: Text(
                              'Go to Journal',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.clue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Keep Investigating',
                            style: GoogleFonts.roboto(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Text(
                    'Analysing evidence...',
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
