// Phone Detective - Photo Viewer Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/clue.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

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

class _PhotoViewerScreenState extends State<PhotoViewerScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  bool _showOverlay = true;
  bool _showMetadata = false;
  final TransformationController _transformController =
      TransformationController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.photoIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformController.dispose();
    _pulseController.dispose();
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
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() => _showOverlay = !_showOverlay);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo PageView
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _transformController.value = Matrix4.identity();
              },
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return Hero(
                  tag: 'photo_${photo.id}',
                  child: InteractiveViewer(
                    transformationController: _transformController,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: _PhotoPlaceholder(
                      index: index,
                      hotspots: photo.hotspots,
                      pulseAnimation: _pulseAnimation,
                      onHotspotTap: (hotspot) =>
                          _showHotspotDetail(hotspot, gameState),
                    ),
                  ),
                );
              },
            ),
            // Top overlay
            if (_showOverlay)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_currentIndex + 1} of ${photos.length}',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          if (currentPhoto?.title != null)
                            Text(
                              currentPhoto!.title!,
                              style: GoogleFonts.roboto(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      // Hotspot count badge
                      currentPhoto != null && currentPhoto.hotspots.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.search,
                                      color: Colors.white, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${currentPhoto.hotspots.length}',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            // Bottom overlay
            if (_showOverlay && currentPhoto != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: 24,
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(
                            icon: Icons.info_outline,
                            label: 'Info',
                            onTap: () {
                              setState(() => _showMetadata = !_showMetadata);
                            },
                          ),
                          _ActionButton(
                            icon: gameState.isClueMarked(currentPhoto.id)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            label: gameState.isClueMarked(currentPhoto.id)
                                ? 'Clue'
                                : 'Save',
                            color: gameState.isClueMarked(currentPhoto.id)
                                ? AppColors.clue
                                : null,
                            onTap: () => _toggleClue(currentPhoto, gameState),
                          ),
                          _ActionButton(
                            icon: Icons.search,
                            label: 'Inspect',
                            onTap: () {
                              HapticService.lightTap();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    currentPhoto.hotspots.isEmpty
                                        ? 'No hidden details found'
                                        : '${currentPhoto.hotspots.length} discoverable area${currentPhoto.hotspots.length > 1 ? 's' : ''} — tap the pulsing circles',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      if (_showMetadata) ...[
                        const SizedBox(height: 20),
                        _MetadataSection(photo: currentPhoto),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleClue(dynamic photo, GameStateProvider gameState) {
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
        preview: photo.title ?? 'Photo ${_currentIndex + 1}',
        foundAt: DateTime.now(),
      );
      gameState.addClue(clue);
      HapticService.heavyTap();
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
    }
  }

  void _showHotspotDetail(dynamic hotspot, GameStateProvider gameState) {
    HapticService.mediumTap();
    final isClue = gameState.isClueMarked(hotspot.id);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.search, color: AppColors.clue),
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

class _PhotoPlaceholder extends StatelessWidget {
  final int index;
  final List<dynamic> hotspots;
  final Function(dynamic) onHotspotTap;
  final Animation<double> pulseAnimation;

  const _PhotoPlaceholder({
    required this.index,
    required this.hotspots,
    required this.onHotspotTap,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF2C3E50),
      const Color(0xFF34495E),
      const Color(0xFF1A252F),
      const Color(0xFF243447),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors[index % colors.length],
                colors[(index + 1) % colors.length],
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image,
              size: 100,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        // Pulsing Hotspots
        ...hotspots.map(
          (hotspot) => Positioned(
            left: hotspot.x * MediaQuery.of(context).size.width - 22,
            top: hotspot.y * MediaQuery.of(context).size.height - 22,
            child: GestureDetector(
              onTap: () => onHotspotTap(hotspot),
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.clue
                            .withValues(alpha: pulseAnimation.value),
                        width: 2.5,
                      ),
                      color: AppColors.clue
                          .withValues(alpha: pulseAnimation.value * 0.25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.clue
                              .withValues(alpha: pulseAnimation.value * 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.search, color: AppColors.clue, size: 20),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color ?? Colors.white, size: 26),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.roboto(
              color: color ?? Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetadataSection extends StatelessWidget {
  final dynamic photo;

  const _MetadataSection({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetadataRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: photo.displayDate,
          ),
          if (photo.location != null)
            _MetadataRow(
              icon: Icons.location_on,
              label: 'Location',
              value: photo.location!,
            ),
          if (photo.title != null)
            _MetadataRow(
              icon: Icons.label,
              label: 'Title',
              value: photo.title!,
            ),
          if (photo.description != null)
            _MetadataRow(
              icon: Icons.notes,
              label: 'Description',
              value: photo.description!,
            ),
          if (photo.hotspots.isNotEmpty)
            _MetadataRow(
              icon: Icons.search,
              label: 'Discoverable',
              value:
                  '${photo.hotspots.length} area${photo.hotspots.length > 1 ? 's' : ''} to inspect',
            ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 16),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: GoogleFonts.roboto(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
