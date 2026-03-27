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
import '../widgets/clue_deduction_sheet.dart';
import '../widgets/password_unlock_widget.dart';
import '../widgets/data_restore_widget.dart';
import '../widgets/investigation_nav_bar.dart';
import '../widgets/tutorial_banner.dart';

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
      bottomNavigationBar: const InvestigationNavBar(),
      body: Column(
        children: [
          TutorialBanner(stepMessages: {
            4: 'Look for messages with unusual timestamps or tone changes.\nLong-press a suspicious message to mark it as a clue.',
            5: 'Evidence saved! Tap ← to return to the phone and keep exploring.',
          }),
          ClueHintBanner(clueCount: gameState.currentClues.length, context: InvestigationContext.conversation),
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
                      _EncryptedMessageBubble(
                        message: message,
                        isFromOwner: message.isFromOwner,
                        onTapUnlock: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => Dialog(
                              backgroundColor: AppColors.backgroundSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              insetPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 24,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.85,
                                ),
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(8),
                                  child: PasswordUnlockWidget(
                                    correctPassword: message.password ?? '',
                                    hint: message.passwordHint,
                                    stepHint: gameState.currentCase
                                        .getStepHintForNode(message.id),
                                    onUnlock: () {
                                      gameState.unlockItem(message.id);
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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

    // Already marked — offer removal
    if (isClue) {
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
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
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
              _ActionButton(
                icon: Icons.bookmark_remove,
                label: 'Remove from Evidence',
                color: AppColors.danger,
                onTap: () {
                  gameState.removeClue(message.id);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removed from evidence'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
      return;
    }

    // Not yet marked — check if this is actually a key clue
    if (!gameState.isKeyClue(message.id)) {
      ClueDeductionSheet.showNothing(context);
      return;
    }

    // Key clue found — show deduction confirmation
    final preview =
        '$senderName: ${message.content.length > 80 ? '${message.content.substring(0, 80)}...' : message.content}';
    final insight = gameState.currentCase.solution.clueInsights[message.id];
    ClueDeductionSheet.show(
      context: context,
      preview: preview,
      insight: insight,
      onConfirm: () {
        gameState.addClue(Clue(
          id: message.id,
          type: ClueType.message,
          sourceId: message.id,
          preview: preview,
          foundAt: DateTime.now(),
        ));
        // Tutorial: marking any key clue in a conversation advances step 4 → 5
        gameState.advanceTutorialIfOnStep(4);
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

class _EncryptedMessageBubble extends StatelessWidget {
  final dynamic message;
  final bool isFromOwner;
  final VoidCallback onTapUnlock;

  const _EncryptedMessageBubble({
    required this.message,
    required this.isFromOwner,
    required this.onTapUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isFromOwner ? 80 : 16,
        right: isFromOwner ? 16 : 80,
        top: 4,
        bottom: 4,
      ),
      child: GestureDetector(
        onTap: onTapUnlock,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isFromOwner
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.surfaceDark,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isFromOwner ? 16 : 4),
              bottomRight: Radius.circular(isFromOwner ? 4 : 16),
            ),
            border: Border.all(
              color: AppColors.danger.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.danger.withValues(alpha: 0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 16, color: AppColors.danger),
                  const SizedBox(width: 6),
                  Text(
                    'ENCRYPTED MESSAGE',
                    style: GoogleFonts.robotoMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.danger,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '████ ███████ ██████',
                style: GoogleFonts.robotoMono(
                  fontSize: 14,
                  color: AppColors.textTertiary.withValues(alpha: 0.3),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.key, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'TAP TO DECRYPT',
                      style: GoogleFonts.robotoMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
