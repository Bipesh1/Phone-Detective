// Phone Detective - Photo Viewer Screen
// Text-based evidence viewer: shows photo descriptions as forensic evidence cards

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/clue.dart';
import '../models/photo.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';
import '../widgets/investigation_nav_bar.dart';

class PhotoViewerScreen extends StatefulWidget {
  final String photoId;
  final int photoIndex;

  const PhotoViewerScreen({
    super.key,
    required this.photoId,
    required this.photoIndex,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.photoIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final photos =
        gameState.currentCase.photos.where((p) => !p.isHidden).toList();
    final currentPhoto = photos.isNotEmpty && _currentIndex < photos.length
        ? photos[_currentIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSecondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Evidence Photo',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_currentIndex + 1} of ${photos.length}',
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        actions: [
          if (currentPhoto != null)
            IconButton(
              icon: Icon(
                gameState.isClueMarked(currentPhoto.id)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: gameState.isClueMarked(currentPhoto.id)
                    ? AppColors.clue
                    : AppColors.textSecondary,
              ),
              onPressed: () => _toggleClue(currentPhoto, gameState),
            ),
        ],
      ),
      bottomNavigationBar: const InvestigationNavBar(),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return _PhotoEvidenceCard(
            photo: photo,
            gameState: gameState,
            onToggleClue: () => _toggleClue(photo, gameState),
            onHotspotTap: (hotspot) => _showHotspotDetail(hotspot, gameState),
          );
        },
      ),
    );
  }

  void _toggleClue(Photo photo, GameStateProvider gameState) {
    HapticService.mediumTap();

    if (gameState.isClueMarked(photo.id)) {
      gameState.removeClue(photo.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from clues'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      final clue = Clue(
        id: photo.id,
        type: ClueType.photo,
        sourceId: photo.id,
        preview: photo.title ?? photo.description ?? 'Photo ${_currentIndex + 1}',
        foundAt: DateTime.now(),
      );
      gameState.addClue(clue);
      HapticService.heavyTap();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.bookmark, color: AppColors.clue),
              const SizedBox(width: 8),
              const Text('Added to Detective Journal'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showHotspotDetail(PhotoHotspot hotspot, GameStateProvider gameState) {
    HapticService.mediumTap();
    final isClue = gameState.isClueMarked(hotspot.id);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.search, color: AppColors.clue),
            const SizedBox(width: 8),
            Text(
              'Discovery!',
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotspot.description,
              style: GoogleFonts.roboto(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (isClue) {
                    gameState.removeClue(hotspot.id);
                  } else {
                    final clue = Clue(
                      id: hotspot.id,
                      type: ClueType.photo,
                      sourceId: hotspot.id,
                      preview: hotspot.description.length > 80
                          ? '${hotspot.description.substring(0, 80)}...'
                          : hotspot.description,
                      foundAt: DateTime.now(),
                    );
                    gameState.addClue(clue);
                    HapticService.heavyTap();
                  }
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isClue
                            ? 'Removed from clues'
                            : 'Added to Detective Journal',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  isClue ? Icons.bookmark_remove : Icons.bookmark_add,
                  color: isClue ? Colors.white : Colors.black87,
                ),
                label: Text(
                  isClue ? 'Remove from Clues' : 'Mark as Clue',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: isClue ? Colors.white : Colors.black87,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isClue ? AppColors.danger : AppColors.clue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: GoogleFonts.roboto(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Evidence Card ──────────────────────────────────────────────────────────

class _PhotoEvidenceCard extends StatelessWidget {
  final Photo photo;
  final GameStateProvider gameState;
  final VoidCallback onToggleClue;
  final Function(PhotoHotspot) onHotspotTap;

  const _PhotoEvidenceCard({
    required this.photo,
    required this.gameState,
    required this.onToggleClue,
    required this.onHotspotTap,
  });

  @override
  Widget build(BuildContext context) {
    final isClue = gameState.isClueMarked(photo.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo description card (main content)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: isClue
                  ? Border.all(color: AppColors.clue.withValues(alpha: 0.5), width: 1.5)
                  : Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getAccentColor().withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getPhotoIcon(),
                        color: _getAccentColor(),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (photo.title != null)
                            Text(
                              photo.title!,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Text(
                            photo.displayDate,
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isClue)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.clue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bookmark, color: AppColors.clue, size: 12),
                            const SizedBox(width: 3),
                            Text(
                              'CLUE',
                              style: GoogleFonts.robotoMono(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.clue,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                if (photo.description != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      photo.description!,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.65,
                      ),
                    ),
                  ),
                ],

                if (photo.location != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.textTertiary, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        photo.location!,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Hotspots section
          if (photo.hotspots.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.search, color: AppColors.primary, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'INSPECT THIS PHOTO',
                        style: GoogleFonts.robotoMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${photo.hotspots.length} detail${photo.hotspots.length > 1 ? "s" : ""}',
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...photo.hotspots.map((hotspot) {
                    final isHotspotClue = gameState.isClueMarked(hotspot.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        onTap: () => onHotspotTap(hotspot),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isHotspotClue
                                ? AppColors.clue.withValues(alpha: 0.1)
                                : AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(10),
                            border: isHotspotClue
                                ? Border.all(color: AppColors.clue.withValues(alpha: 0.3))
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isHotspotClue ? Icons.bookmark : Icons.touch_app,
                                color: isHotspotClue ? AppColors.clue : AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  isHotspotClue
                                      ? hotspot.description
                                      : 'Tap to examine detail',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    color: isHotspotClue
                                        ? AppColors.textSecondary
                                        : AppColors.primary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: AppColors.textTertiary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Mark as clue button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onToggleClue,
              icon: Icon(
                isClue ? Icons.bookmark_remove : Icons.bookmark_add,
                size: 18,
              ),
              label: Text(
                isClue ? 'Remove from Clues' : 'Mark Photo as Clue',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isClue ? AppColors.danger : AppColors.clue,
                side: BorderSide(
                  color: isClue
                      ? AppColors.danger.withValues(alpha: 0.5)
                      : AppColors.clue.withValues(alpha: 0.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPhotoIcon() {
    final t = (photo.title ?? '').toLowerCase();
    if (t.contains('screenshot')) return Icons.screenshot;
    if (t.contains('selfie')) return Icons.face;
    if (t.contains('map') || t.contains('location')) return Icons.map;
    if (t.contains('receipt') || t.contains('booking')) return Icons.receipt_long;
    if (t.contains('document') || t.contains('contract')) return Icons.description;
    return Icons.photo_camera;
  }

  Color _getAccentColor() {
    final t = (photo.title ?? '').toLowerCase();
    if (t.contains('screenshot') || t.contains('booking')) return const Color(0xFF42A5F5);
    if (t.contains('selfie')) return const Color(0xFFAB47BC);
    return const Color(0xFF5C6BC0);
  }
}
