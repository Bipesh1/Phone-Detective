// Phone Detective - Notes App Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/note_card.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../widgets/clue_hint_banner.dart';
import '../widgets/investigation_nav_bar.dart';
import '../widgets/tutorial_banner.dart';

class NotesAppScreen extends StatelessWidget {
  const NotesAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final notes = gameState.currentCase.notes;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const InvestigationNavBar(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notes',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.textTertiary),
            onPressed: () {
              HapticService.lightTap();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cannot create notes - this is evidence'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? _EmptyState()
          : Column(
              children: [
                TutorialBanner(stepMessages: {
                  7: 'Open the pink note: "Draft Post - DO NOT PUBLISH YET"\nLena wrote something she didn\'t want anyone to see.',
                  9: 'Now open the yellow note: "Packing List"\nShe packed for a long trip — look at what she chose to leave behind.',
                }),
                ClueHintBanner(clueCount: gameState.currentClues.length, context: InvestigationContext.notes),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isClue = gameState.isClueMarked(note.id);
                      final isUnlocked =
                          !note.isLocked || gameState.isItemUnlocked(note.id);

                      return NoteCard(
                        note: note,
                        isMarkedAsClue: isClue,
                        isUnlocked: isUnlocked,
                        onTap: () {
                          HapticService.lightTap();
                          if (note.id == 'nt1') {
                            gameState.advanceTutorialIfOnStep(7);
                          } else if (note.id == 'nt2') {
                            gameState.advanceTutorialIfOnStep(9);
                          }
                          Navigator.pushNamed(
                            context,
                            AppRoutes.noteDetail,
                            arguments: {'noteId': note.id},
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_outlined, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'No notes',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
