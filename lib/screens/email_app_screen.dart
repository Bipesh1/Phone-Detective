// Phone Detective - Email App Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/email.dart';
import '../models/clue.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';
import '../widgets/clue_hint_banner.dart';
import '../widgets/password_unlock_widget.dart';
import '../widgets/data_restore_widget.dart';

class EmailAppScreen extends StatefulWidget {
  const EmailAppScreen({super.key});

  @override
  State<EmailAppScreen> createState() => _EmailAppScreenState();
}

class _EmailAppScreenState extends State<EmailAppScreen> {
  EmailFolder _currentFolder = EmailFolder.inbox;

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final allEmails = gameState.currentCase.emails;
    final emails = allEmails.where((e) => e.folder == _currentFolder).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: PopupMenuButton<EmailFolder>(
          onSelected: (folder) => setState(() => _currentFolder = folder),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentFolder.name[0].toUpperCase() +
                    _currentFolder.name.substring(1),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ],
          ),
          itemBuilder: (context) => EmailFolder.values.map((folder) {
            return PopupMenuItem(
              value: folder,
              child: Text(
                folder.name[0].toUpperCase() + folder.name.substring(1),
              ),
            );
          }).toList(),
        ),
      ),
      body: emails.isEmpty
          ? Center(
              child: Text(
                'No emails',
                style: GoogleFonts.poppins(color: AppColors.textSecondary),
              ),
            )
          : Column(
              children: [
                ClueHintBanner(clueCount: gameState.currentClues.length),
                Expanded(
                  child: ListView.builder(
                    itemCount: emails.length,
                    itemBuilder: (context, index) {
                      final email = emails[index];
                      final isClue = gameState.isClueMarked(email.id);
                      return _EmailTile(
                        email: email,
                        isClue: isClue,
                        gameState: gameState,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _EmailTile extends StatelessWidget {
  final Email email;
  final bool isClue;
  final GameStateProvider gameState;

  const _EmailTile({
    required this.email,
    required this.isClue,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _showDetail(context),
      onLongPress: () => _toggleClue(context),
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.2),
        child: Text(
          email.senderName[0].toUpperCase(),
          style: TextStyle(color: AppColors.primary),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              email.senderName,
              style: GoogleFonts.roboto(
                color: AppColors.textPrimary,
                fontWeight: email.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ),
          if (isClue) Icon(Icons.bookmark, color: AppColors.clue, size: 16),
          Text(
            email.displayDate,
            style: GoogleFonts.roboto(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            email.subject,
            style: GoogleFonts.roboto(color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            email.preview,
            style: GoogleFonts.roboto(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final currentlyClue = gameState.isClueMarked(email.id);
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Subject
                Text(
                  email.subject,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                // From
                Text(
                  'From: ${email.senderName} <${email.senderEmail}>',
                  style: GoogleFonts.roboto(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                // Timestamp
                Text(
                  _formatTimestamp(email.timestamp),
                  style: GoogleFonts.roboto(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                // Clue button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (currentlyClue) {
                        gameState.removeClue(email.id);
                      } else {
                        gameState.addClue(
                          Clue(
                            id: email.id,
                            type: ClueType.email,
                            sourceId: email.id,
                            preview: '${email.senderName}: ${email.subject}',
                            foundAt: DateTime.now(),
                          ),
                        );
                        HapticService.heavyTap();
                      }
                      setSheetState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            currentlyClue
                                ? 'Removed from clues'
                                : 'Added to Detective Journal',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: Icon(
                      currentlyClue ? Icons.bookmark : Icons.bookmark_add,
                      color: currentlyClue
                          ? AppColors.clue
                          : AppColors.textSecondary,
                      size: 18,
                    ),
                    label: Text(
                      currentlyClue ? 'Marked as Clue' : 'Mark as Clue',
                      style: GoogleFonts.roboto(
                        color: currentlyClue
                            ? AppColors.clue
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: currentlyClue
                            ? AppColors.clue.withValues(alpha: 0.5)
                            : AppColors.textTertiary.withValues(alpha: 0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: AppColors.textTertiary.withValues(alpha: 0.2)),
                const SizedBox(height: 8),
                // Body
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildEmailContent(email, gameState),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:$minute $period';
  }

  Widget _buildEmailContent(Email email, GameStateProvider gameState) {
    if (email.isLocked && !gameState.isItemUnlocked(email.id)) {
      return PasswordUnlockWidget(
        correctPassword: email.password ?? '',
        hint: email.passwordHint,
        onUnlock: () => gameState.unlockItem(email.id),
      );
    } else if (email.isCorrupted && !gameState.isItemRestored(email.id)) {
      return DataRestoreWidget(
        corruptedContent: email.corruptedContent,
        onRestore: () => gameState.restoreItem(email.id),
      );
    }

    return Text(
      email.body,
      style: GoogleFonts.roboto(
        color: AppColors.textPrimary,
        height: 1.6,
      ),
    );
  }

  void _toggleClue(BuildContext context) {
    HapticService.mediumTap();
    if (isClue) {
      gameState.removeClue(email.id);
    } else {
      gameState.addClue(
        Clue(
          id: email.id,
          type: ClueType.email,
          sourceId: email.id,
          preview: email.subject,
          foundAt: DateTime.now(),
        ),
      );
      HapticService.heavyTap();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isClue ? 'Removed from clues' : 'Added to Detective Journal',
        ),
      ),
    );
  }
}
