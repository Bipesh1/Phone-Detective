// Phone Detective - Note Card Widget

import 'package:flutter/material.dart';
import '../models/note.dart';
import '../utils/constants.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final bool isMarkedAsClue;
  final bool isUnlocked;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.isMarkedAsClue = false,
    this.isUnlocked = true,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = note.isLocked && !isUnlocked;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isLocked
              ? AppColors.surfaceDark
              : Color(note.color.colorValue),
          borderRadius: BorderRadius.circular(12),
          border: isMarkedAsClue
              ? Border.all(color: AppColors.clue, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
            if (isMarkedAsClue)
              BoxShadow(
                color: AppColors.clue.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isLocked ? '🔒 Locked Note' : note.title,
                      style: TextStyle(
                        color: isLocked
                            ? AppColors.textSecondary
                            : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isMarkedAsClue)
                    Icon(Icons.bookmark, color: AppColors.clue, size: 18),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isLocked
                    ? 'This note requires a password to view'
                    : note.preview,
                style: TextStyle(
                  color: isLocked ? AppColors.textTertiary : Colors.black54,
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                note.displayDate,
                style: TextStyle(
                  color: isLocked ? AppColors.textTertiary : Colors.black45,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
