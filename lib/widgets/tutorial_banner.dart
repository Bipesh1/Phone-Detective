// Phone Detective - Tutorial In-Screen Banner
// Shows contextual tutorial guidance inside investigation screens.
// stepMessages maps each tutorial step number to its instruction text.
// Each step can be independently dismissed.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/case_data.dart';

class TutorialBanner extends StatefulWidget {
  /// Maps tutorial step numbers to the instruction text shown on that step.
  final Map<int, String> stepMessages;

  const TutorialBanner({super.key, required this.stepMessages});

  @override
  State<TutorialBanner> createState() => _TutorialBannerState();
}

class _TutorialBannerState extends State<TutorialBanner> {
  final Set<int> _dismissedSteps = {};

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    if (!gameState.isTutorialActive) return const SizedBox.shrink();

    // Only show tutorial banners for tutorial-difficulty cases
    if (gameState.currentCase.difficulty != CaseDifficulty.tutorial) {
      return const SizedBox.shrink();
    }

    final step = gameState.tutorialStep;
    final message = widget.stepMessages[step];
    if (message == null) return const SizedBox.shrink();
    if (_dismissedSteps.contains(step)) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF007AFF).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF007AFF).withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.manage_search, color: Color(0xFF007AFF), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DETECTIVE GUIDE',
                  style: GoogleFonts.oswald(
                    color: const Color(0xFF007AFF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _dismissedSteps.add(step)),
            child: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.close, color: Colors.white38, size: 15),
            ),
          ),
        ],
      ),
    );
  }
}
