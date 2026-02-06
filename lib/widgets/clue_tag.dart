// Phone Detective - Clue Tag Widget

import 'package:flutter/material.dart';
import '../models/clue.dart';
import '../utils/constants.dart';

class ClueTag extends StatelessWidget {
  final Clue clue;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool showRemove;

  const ClueTag({
    super.key,
    required this.clue,
    this.onTap,
    this.onRemove,
    this.showRemove = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.clue.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Type icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.clue.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  clue.type.icon,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      clue.type.label,
                      style: TextStyle(
                        color: AppColors.clue,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      clue.preview,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (clue.playerNote != null &&
                        clue.playerNote!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.note,
                            color: AppColors.textTertiary,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              clue.playerNote!,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
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
                  ],
                ),
              ),
              // Remove button
              if (showRemove && onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textTertiary,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClueHighlightContainer extends StatefulWidget {
  final Widget child;
  final bool isHighlighted;

  const ClueHighlightContainer({
    super.key,
    required this.child,
    this.isHighlighted = false,
  });

  @override
  State<ClueHighlightContainer> createState() => _ClueHighlightContainerState();
}

class _ClueHighlightContainerState extends State<ClueHighlightContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.clueHighlight,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isHighlighted) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ClueHighlightContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isHighlighted && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isHighlighted) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.clue.withValues(alpha: _animation.value),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
