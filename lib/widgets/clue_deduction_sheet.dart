// Phone Detective - Clue Deduction Sheet
// Shown when a player long-presses an item during investigation.
// Key clues show a "detective instinct" confirmation popup.
// Non-clue items get a subtle "nothing unusual here" snackbar.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class ClueDeductionSheet {
  /// Show the "something caught your eye" discovery sheet for a confirmed key clue.
  /// [preview] is the item's short text summary.
  /// [onConfirm] is called when the player taps "Add to Evidence".
  static void show({
    required BuildContext context,
    required String preview,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Detective eye icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.clue.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search, color: AppColors.clue, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              'SOMETHING CAUGHT YOUR EYE',
              style: GoogleFonts.robotoMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.clue,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            // Item preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                preview,
                style: GoogleFonts.roboto(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your detective instincts are tingling.\nThis could be significant to the case.',
              style: GoogleFonts.roboto(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: AppColors.textTertiary.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Keep Looking',
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onConfirm();
                    },
                    icon: const Icon(Icons.bookmark_add, size: 18),
                    label: Text(
                      'Add to Evidence',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.clue,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show a subtle snackbar when the player investigates a non-clue item.
  static void showNothing(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.search, color: AppColors.textTertiary, size: 18),
            const SizedBox(width: 8),
            const Text('Nothing unusual here. Keep investigating.'),
          ],
        ),
        backgroundColor: AppColors.backgroundSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
