// Phone Detective - Conversation Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/clue.dart';
import '../widgets/message_bubble.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../widgets/clue_hint_banner.dart';
import '../widgets/password_unlock_widget.dart';
import '../widgets/data_restore_widget.dart';

class ConversationScreen extends StatefulWidget {
  final String contactId;

  const ConversationScreen({super.key, required this.contactId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final contact = gameState.currentCase.getContact(widget.contactId);
    final messages = gameState.currentCase.getMessagesForContact(
      widget.contactId,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSecondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {
            HapticService.lightTap();
            Navigator.pushNamed(
              context,
              AppRoutes.contactDetail,
              arguments: {'contactId': widget.contactId},
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: contact?.avatarColor ?? AppColors.primary,
                child: Text(
                  contact?.initials ?? '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                contact?.fullName ?? 'Unknown',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.primary),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.contactDetail,
                arguments: {'contactId': widget.contactId},
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ClueHintBanner(clueCount: gameState.currentClues.length),
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msgIndex = messages.length - 1 - index;
                final message = messages[msgIndex];
                final isClue = gameState.isClueMarked(message.id);

                // Determine if we should show sender name
                // Show when it's the first message or sender changed from previous
                final bool showSenderName;
                if (msgIndex == 0) {
                  showSenderName = true;
                } else {
                  final prevMessage = messages[msgIndex - 1];
                  showSenderName = prevMessage.senderId != message.senderId;
                }

                // Determine if we should show a date separator
                // Show when date changes from the previous message
                Widget? dateSeparator;
                if (msgIndex == 0) {
                  dateSeparator = _buildDateSeparator(message.timestamp);
                } else {
                  final prevMessage = messages[msgIndex - 1];
                  if (!_isSameDay(prevMessage.timestamp, message.timestamp)) {
                    dateSeparator = _buildDateSeparator(message.timestamp);
                  }
                }

                return Column(
                  children: [
                    if (dateSeparator != null) dateSeparator,
                    if (message.isLocked &&
                        !gameState.isItemUnlocked(message.id))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: PasswordUnlockWidget(
                          correctPassword: message.password ?? '',
                          hint: message.passwordHint,
                          onUnlock: () => gameState.unlockItem(message.id),
                        ),
                      )
                    else if (message.isCorrupted &&
                        !gameState.isItemRestored(message.id))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: DataRestoreWidget(
                          corruptedContent: message.corruptedContent,
                          onRestore: () => gameState.restoreItem(message.id),
                        ),
                      )
                    else
                      MessageBubble(
                        message: message,
                        isMarkedAsClue: isClue,
                        contactName: contact?.firstName ?? contact?.fullName,
                        showSenderName: showSenderName,
                        onLongPress: () => _showClueDialog(
                          context,
                          message,
                          isClue,
                          gameState,
                          message.isFromOwner
                              ? 'You'
                              : contact?.firstName ?? 'Unknown',
                        ),
                        onImageTap: message.imageUrl != null
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.photoViewer,
                                  arguments: {
                                    'photoId': message.imageUrl,
                                    'photoIndex': 0,
                                  },
                                );
                              }
                            : null,
                      ),
                  ],
                );
              },
            ),
          ),
          // Bottom input bar (disabled)
          _DisabledInputBar(),
        ],
      ),
    );
  }

  void _showClueDialog(
    BuildContext context,
    dynamic message,
    bool isClue,
    GameStateProvider gameState,
    String senderName,
  ) {
    HapticService.mediumTap();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Message preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.content.length > 100
                    ? '${message.content.substring(0, 100)}...'
                    : message.content,
                style: GoogleFonts.roboto(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Actions
            if (isClue)
              _ActionButton(
                icon: Icons.bookmark_remove,
                label: 'Remove from Clues',
                color: AppColors.danger,
                onTap: () {
                  gameState.removeClue(message.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removed from clues'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              )
            else
              _ActionButton(
                icon: Icons.bookmark_add,
                label: 'Mark as Clue',
                color: AppColors.clue,
                onTap: () {
                  final clue = Clue(
                    id: message.id,
                    type: ClueType.message,
                    sourceId: message.id,
                    preview:
                        '$senderName: ${message.content.length > 80 ? '${message.content.substring(0, 80)}...' : message.content}',
                    foundAt: DateTime.now(),
                  );
                  gameState.addClue(clue);
                  HapticService.heavyTap();
                  Navigator.pop(context);
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
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateSeparator(DateTime date) {
    const months = [
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
    final label = '${months[date.month - 1]} ${date.day}, ${date.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.surfaceLight, height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.surfaceLight, height: 1)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisabledInputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(top: BorderSide(color: AppColors.surfaceDark)),
      ),
      child: Row(
        children: [
          Icon(Icons.camera_alt, color: AppColors.textTertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'This is evidence, you cannot reply',
                style: GoogleFonts.roboto(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.mic, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
