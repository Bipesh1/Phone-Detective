// Phone Detective - Photo Grid Item Widget

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class PhotoGridItem extends StatelessWidget {
  final String photoId;
  final int index;
  final bool isMarkedAsClue;
  final VoidCallback onTap;
  final String? heroTag;
  final String? title;
  final String? dateTaken;
  final bool hasHotspots;

  const PhotoGridItem({
    super.key,
    required this.photoId,
    required this.index,
    this.isMarkedAsClue = false,
    required this.onTap,
    this.heroTag,
    this.title,
    this.dateTaken,
    this.hasHotspots = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8),
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
        clipBehavior: Clip.antiAlias,
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
            // Bottom gradient with title & date
            if (title != null || dateTaken != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (dateTaken != null)
                        Text(
                          dateTaken!,
                          style: GoogleFonts.roboto(
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                        ),
                    ],
                  ),
                ),
              ),
            // Hotspot indicator (top-left)
            if (hasHotspots)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            // Clue badge (top-right)
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
