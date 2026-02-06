// Phone Detective - Message Bubble Widget

import 'package:flutter/material.dart';
import '../models/message.dart';
import '../utils/constants.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMarkedAsClue;
  final VoidCallback? onLongPress;
  final VoidCallback? onImageTap;
  final String? contactName;

  const MessageBubble({
    super.key,
    required this.message,
    this.isMarkedAsClue = false,
    this.onLongPress,
    this.onImageTap,
    this.contactName,
  });

  @override
  Widget build(BuildContext context) {
    final isFromOwner = message.isFromOwner;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: isFromOwner
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!isFromOwner) const SizedBox(width: 8),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: isFromOwner
                      ? AppColors.messageBubbleSent
                      : AppColors.messageBubbleReceived,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isFromOwner ? 18 : 4),
                    bottomRight: Radius.circular(isFromOwner ? 4 : 18),
                  ),
                  border: isMarkedAsClue
                      ? Border.all(color: AppColors.clue, width: 2)
                      : null,
                  boxShadow: isMarkedAsClue
                      ? [
                          BoxShadow(
                            color: AppColors.clue.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _buildContent(),
                ),
              ),
            ),
            if (isFromOwner) const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (message.isDeleted) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          '[Message deleted]',
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.5),
            fontSize: 15,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    if (message.type == MessageType.image) {
      return GestureDetector(
        onTap: onImageTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder image
            Container(
              width: 200,
              height: 150,
              color: AppColors.surfaceDark,
              child: const Center(
                child: Icon(
                  Icons.image,
                  color: AppColors.textSecondary,
                  size: 48,
                ),
              ),
            ),
            if (message.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  message.content,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              decoration: message.type == MessageType.link
                  ? TextDecoration.underline
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  color: message.isFromOwner
                      ? Colors.white70
                      : AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              if (isMarkedAsClue) ...[
                const SizedBox(width: 6),
                Icon(Icons.bookmark, color: AppColors.clue, size: 12),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
