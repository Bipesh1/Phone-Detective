// Phone Detective - Note Detail Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/clue.dart';
import '../models/note.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';
import '../widgets/clue_deduction_sheet.dart';
import '../widgets/password_unlock_widget.dart';
import '../widgets/data_restore_widget.dart';
import '../widgets/tutorial_banner.dart';

class NoteDetailScreen extends StatelessWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final note = gameState.currentCase.notes.firstWhere(
      (n) => n.id == noteId,
      orElse: () => Note(
        id: '',
        title: 'Not Found',
        content: 'Note not found',
        createdAt: DateTime.now(),
      ),
    );
    final isClue = gameState.isClueMarked(noteId);

    return Scaffold(
      backgroundColor: Color(note.color.colorValue).withValues(alpha: 0.15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isClue ? Icons.bookmark : Icons.bookmark_border,
              color: isClue ? AppColors.clue : AppColors.textSecondary,
            ),
            onPressed: () => _toggleClue(context, note, isClue, gameState),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textTertiary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (noteId == 'nt1')
              TutorialBanner(stepMessages: {
                8: 'Hold this draft post to investigate it.\nLena scheduled it to go live after her flight — this is her farewell message.',
              })
            else if (noteId == 'nt2')
              TutorialBanner(stepMessages: {
                10: 'Hold this packing list to investigate it.\nRead the very last item carefully.',
              }),
            const SizedBox(height: 8),
            // Title
            Text(
              note.title,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Date
            Text(
              'Last edited: ${_formatDate(note.modifiedAt ?? note.createdAt)}',
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            // Content
            // Content
            if (note.isLocked && !gameState.isItemUnlocked(noteId))
              PasswordUnlockWidget(
                correctPassword: note.password ?? '',
                hint: note.passwordHint,
                stepHint: gameState.currentCase.getStepHintForNode(noteId),
                onUnlock: () {
                  gameState.unlockItem(noteId);
                },
              )
            else if (note.isCorrupted && !gameState.isItemRestored(noteId))
              DataRestoreWidget(
                corruptedContent: note.corruptedContent,
                onRestore: () => gameState.restoreItem(noteId),
              )
            else
              GestureDetector(
                onLongPress: () =>
                    _toggleClue(context, note, isClue, gameState),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(note.color.colorValue),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        note.content,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 13,
                            color: Colors.black38,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Hold to investigate',
                            style: GoogleFonts.roboto(
                              fontSize: 11,
                              color: Colors.black38,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleClue(
    BuildContext context,
    Note note,
    bool isClue,
    GameStateProvider gameState,
  ) {
    HapticService.mediumTap();

    if (isClue) {
      // Always allow removal
      gameState.removeClue(noteId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from evidence'),
          duration: Duration(seconds: 1),
        ),
      );
    } else if (!gameState.isKeyClue(noteId)) {
      ClueDeductionSheet.showNothing(context);
    } else {
      final contentSnippet = note.content.length > 60
          ? '${note.content.substring(0, 60)}...'
          : note.content;
      final preview = '${note.title}: $contentSnippet';
      ClueDeductionSheet.show(
        context: context,
        preview: preview,
        onConfirm: () {
          gameState.addClue(Clue(
            id: noteId,
            type: ClueType.note,
            sourceId: noteId,
            preview: preview,
            foundAt: DateTime.now(),
          ));
          if (noteId == 'nt1') gameState.advanceTutorialIfOnStep(8);
          if (noteId == 'nt2') gameState.advanceTutorialIfOnStep(10);
          HapticService.heavyTap();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.bookmark, color: AppColors.clue),
                  const SizedBox(width: 8),
                  const Text('Added to Evidence Board'),
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      );
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
