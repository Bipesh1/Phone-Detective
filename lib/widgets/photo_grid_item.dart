// Phone Detective - Photo Grid Item Widget

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PhotoGridItem extends StatelessWidget {
  final String photoId;
  final int index;
  final bool isMarkedAsClue;
  final VoidCallback onTap;
  final String? heroTag;

  const PhotoGridItem({
    super.key,
    required this.photoId,
    required this.index,
    this.isMarkedAsClue = false,
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final widget = GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: isMarkedAsClue
              ? Border.all(color: AppColors.clue, width: 2)
              : null,
          boxShadow: isMarkedAsClue
              ? [
                  BoxShadow(
                    color: AppColors.clue.withValues(alpha: 0.3),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Placeholder gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getPlaceholderColor(index),
                    _getPlaceholderColor(index).withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 32,
                ),
              ),
            ),
            // Clue badge
            if (isMarkedAsClue)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.clue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Colors.black87,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: widget);
    }
    return widget;
  }

  Color _getPlaceholderColor(int index) {
    final colors = [
      const Color(0xFF3A3A3C),
      const Color(0xFF2C2C2E),
      const Color(0xFF48484A),
      const Color(0xFF636366),
      const Color(0xFF1C1C1E),
    ];
    return colors[index % colors.length];
  }
}
