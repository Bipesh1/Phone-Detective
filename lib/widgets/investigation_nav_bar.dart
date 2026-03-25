// Phone Detective - Investigation Nav Bar
// Persistent bottom navigation shown in all phone app screens during investigation.
// Also listens for suspense events and shows them globally.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/suspense_overlay.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class InvestigationNavBar extends StatefulWidget {
  const InvestigationNavBar({super.key});

  @override
  State<InvestigationNavBar> createState() => _InvestigationNavBarState();
}

class _InvestigationNavBarState extends State<InvestigationNavBar> {
  bool _showingSuspense = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for pending suspense events after each rebuild
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkSuspenseEvent();
    });
  }

  void _checkSuspenseEvent() {
    if (_showingSuspense) return;
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    final event = gameState.pendingSuspenseEvent;
    if (event == null) return;

    _showingSuspense = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: SuspenseOverlay(
          event: event,
          onDismiss: () {
            gameState.dismissSuspenseEvent();
            Navigator.of(ctx).pop();
          },
        ),
      ),
    ).then((_) {
      _showingSuspense = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, _) {
        final clueCount = gameState.currentClues.length;
        final suspectCount = gameState.currentSuspects.length;

        // Trigger suspense check on every rebuild
        if (gameState.pendingSuspenseEvent != null && !_showingSuspense) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _checkSuspenseEvent();
          });
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            border: Border(
              top: BorderSide(color: AppColors.surfaceDark, width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  // Back to phone home
                  _NavButton(
                    icon: Icons.phone_android,
                    label: 'Phone',
                    onTap: () {
                      HapticService.lightTap();
                      Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name == AppRoutes.phoneHome ||
                            route.isFirst,
                      );
                    },
                  ),

                  const SizedBox(width: 8),

                  // Clue count / Journal access
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticService.lightTap();
                        Navigator.pushNamed(
                          context,
                          AppRoutes.detectiveJournal,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: clueCount > 0
                              ? AppColors.clue.withValues(alpha: 0.12)
                              : AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: clueCount > 0
                                ? AppColors.clue.withValues(alpha: 0.4)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark,
                              color: clueCount > 0
                                  ? AppColors.clue
                                  : AppColors.textTertiary,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              clueCount > 0
                                  ? '$clueCount clue${clueCount != 1 ? 's' : ''}'
                                  : 'No clues yet',
                              style: GoogleFonts.roboto(
                                color: clueCount > 0
                                    ? AppColors.clue
                                    : AppColors.textTertiary,
                                fontSize: 12,
                                fontWeight: clueCount > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            if (suspectCount > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 12,
                                color: AppColors.textTertiary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.person_search,
                                color: AppColors.danger,
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '$suspectCount',
                                style: GoogleFonts.roboto(
                                  color: AppColors.danger,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Journal button
                  _NavButton(
                    icon: Icons.menu_book,
                    label: 'Journal',
                    onTap: () {
                      HapticService.mediumTap();
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detectiveJournal,
                      );
                    },
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: c.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: c, size: 18),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.roboto(
                color: c,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
