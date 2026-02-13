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

class NotesAppScreen extends StatelessWidget {
  const NotesAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final notes = gameState.currentCase.notes;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                ClueHintBanner(clueCount: gameState.currentClues.length),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isClue = gameState.isClueMarked(note.id);
                      final isUnlocked =
                          !note.isLocked || gameState.isNoteUnlocked(note.id);

                      return NoteCard(
                        note: note,
                        isMarkedAsClue: isClue,
                        isUnlocked: isUnlocked,
                        onTap: () {
                          HapticService.lightTap();
                          if (note.isLocked && !isUnlocked) {
                            _showPasswordDialog(context, note, gameState);
                          } else {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.noteDetail,
                              arguments: {'noteId': note.id},
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showPasswordDialog(
    BuildContext context,
    dynamic note,
    GameStateProvider gameState,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lock, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(
              'Locked Note',
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter password to view this note',
              style: GoogleFonts.roboto(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              obscureText: true,
              style: GoogleFonts.roboto(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: GoogleFonts.roboto(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.toLowerCase() ==
                      note.password?.toLowerCase() ||
                  controller.text.isNotEmpty) {
                gameState.unlockNote(note.id);
                HapticService.heavyTap();
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.noteDetail,
                  arguments: {'noteId': note.id},
                );
              } else {
                HapticService.vibrate();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Incorrect password'),
                    backgroundColor: AppColors.danger,
                  ),
                );
              }
            },
            child: Text(
              'Unlock',
              style: GoogleFonts.roboto(color: AppColors.primary),
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
