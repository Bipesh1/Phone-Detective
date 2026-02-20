// Phone Detective - Note Detail Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/clue.dart';
import '../models/note.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';
import '../widgets/password_unlock_widget.dart';
import '../widgets/data_restore_widget.dart';

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
              Container(
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
                child: SelectableText(
                  note.content,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Clue button
            if (!isClue)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _toggleClue(context, note, isClue, gameState),
                  icon: Icon(Icons.bookmark_add, color: Colors.black87),
                  label: Text(
                    'Mark as Clue',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.clue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
      gameState.removeClue(noteId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from clues'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      final contentSnippet = note.content.length > 60
          ? '${note.content.substring(0, 60)}...'
          : note.content;
      final clue = Clue(
        id: noteId,
        type: ClueType.note,
        sourceId: noteId,
        preview: '${note.title}: $contentSnippet',
        foundAt: DateTime.now(),
      );
      gameState.addClue(clue);
      HapticService.heavyTap();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.bookmark, color: AppColors.clue),
              const SizedBox(width: 8),
              const Text('Added to Detective Journal'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
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
