// Phone Detective - Note Card Widget

import 'package:flutter/material.dart';
import '../models/note.dart';
import '../utils/constants.dart';

class NoteCard extends StatefulWidget {
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
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool get isLocked => widget.note.isLocked && !widget.isUnlocked;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (isLocked) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isLocked && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!isLocked && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final borderColor = isLocked
              ? Color.lerp(
                  AppColors.danger.withValues(alpha: 0.2),
                  AppColors.danger.withValues(alpha: 0.6),
                  _pulseAnimation.value,
                )!
              : widget.isMarkedAsClue
                  ? AppColors.clue
                  : Colors.transparent;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isLocked
                  ? AppColors.surfaceDark
                  : Color(widget.note.color.colorValue),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: isLocked || widget.isMarkedAsClue ? 2 : 0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
                if (widget.isMarkedAsClue)
                  BoxShadow(
                    color: AppColors.clue.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                if (isLocked)
                  BoxShadow(
                    color: AppColors.danger
                        .withValues(alpha: _pulseAnimation.value * 0.2),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isLocked)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child:
                          Icon(Icons.lock, color: AppColors.danger, size: 18),
                    ),
                  Expanded(
                    child: Text(
                      isLocked ? 'Encrypted Note' : widget.note.title,
                      style: TextStyle(
                        color:
                            isLocked ? AppColors.textSecondary : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.isMarkedAsClue)
                    Icon(Icons.bookmark, color: AppColors.clue, size: 18),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isLocked
                    ? 'Password required to decrypt this file'
                    : widget.note.preview,
                style: TextStyle(
                  color: isLocked ? AppColors.textTertiary : Colors.black54,
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isLocked && widget.note.passwordHint != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline,
                        size: 13, color: AppColors.clue.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.note.passwordHint!,
                        style: TextStyle(
                          color: AppColors.clue.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Text(
                widget.note.displayDate,
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
