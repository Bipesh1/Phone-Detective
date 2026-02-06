// Phone Detective - Email App Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/email.dart';
import '../models/clue.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

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
          : ListView.builder(
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
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email.subject,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'From: ${email.senderName} <${email.senderEmail}>',
              style: GoogleFonts.roboto(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  email.body,
                  style: GoogleFonts.roboto(
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
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
