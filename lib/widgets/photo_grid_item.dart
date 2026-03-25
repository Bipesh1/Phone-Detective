// Phone Detective - Photo Grid Item Widget
// Text-based evidence card for gallery view

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
  final String? description;
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
    this.description,
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
              : Border.all(color: Colors.white10, width: 0.5),
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
            // Text-based photo content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo icon
                  Icon(
                    _getPhotoIcon(),
                    color: _getAccentColor(index).withValues(alpha: 0.7),
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  // Title / Caption
                  if (title != null)
                    Text(
                      title!,
                      style: GoogleFonts.roboto(
                        color: AppColors.textPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Spacer(),
                  // Date
                  if (dateTaken != null)
                    Text(
                      dateTaken!,
                      style: GoogleFonts.robotoMono(
                        color: AppColors.textTertiary,
                        fontSize: 8,
                      ),
                      maxLines: 1,
                    ),
                ],
              ),
            ),
            // Hotspot indicator (top-left)
            if (hasHotspots)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            // Clue badge (top-right)
            if (isMarkedAsClue)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.clue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Colors.black87,
                    size: 10,
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

  IconData _getPhotoIcon() {
    final t = (title ?? '').toLowerCase();
    if (t.contains('screenshot')) return Icons.screenshot;
    if (t.contains('selfie')) return Icons.face;
    if (t.contains('map') || t.contains('location')) return Icons.map;
    if (t.contains('receipt') || t.contains('booking')) return Icons.receipt_long;
    if (t.contains('document') || t.contains('contract')) return Icons.description;
    return Icons.photo_camera;
  }

  Color _getAccentColor(int index) {
    const colors = [
      Color(0xFF5C6BC0),
      Color(0xFF26A69A),
      Color(0xFFEF5350),
      Color(0xFFAB47BC),
      Color(0xFF42A5F5),
    ];
    return colors[index % colors.length];
  }
}
