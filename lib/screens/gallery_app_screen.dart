// Phone Detective - Gallery App Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/photo_grid_item.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../widgets/investigation_nav_bar.dart';
import '../widgets/tutorial_banner.dart';

class GalleryAppScreen extends StatefulWidget {
  const GalleryAppScreen({super.key});

  @override
  State<GalleryAppScreen> createState() => _GalleryAppScreenState();
}

class _GalleryAppScreenState extends State<GalleryAppScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final photos = gameState.currentCase.photos;
    final visiblePhotos = photos.where((p) => !p.isHidden).toList();
    final hiddenPhotos = photos.where((p) => p.isHidden).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const InvestigationNavBar(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Gallery',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'All (${visiblePhotos.length})'),
            const Tab(text: 'Screenshots'),
            Tab(text: 'Hidden (${hiddenPhotos.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          TutorialBanner(stepMessages: {
            14: 'Tap the flight booking screenshot.\nThis was taken by Lena hours before her phone was found.',
          }),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
          // All Photos
          _PhotoGrid(photos: visiblePhotos, gameState: gameState),
          // Screenshots
          _PhotoGrid(
            photos: visiblePhotos
                .where(
                  (p) => p.title?.toLowerCase().contains('screenshot') ?? false,
                )
                .toList(),
            gameState: gameState,
            emptyMessage: 'No screenshots',
          ),
          // Hidden
          _HiddenPhotosSection(photos: hiddenPhotos, gameState: gameState),
        ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  final List<dynamic> photos;
  final GameStateProvider gameState;
  final String? emptyMessage;

  const _PhotoGrid({
    required this.photos,
    required this.gameState,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage ?? 'No photos',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1.0,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        final isClue = gameState.isClueMarked(photo.id);

        return PhotoGridItem(
          photoId: photo.id,
          index: index,
          isMarkedAsClue: isClue,
          heroTag: 'photo_${photo.id}',
          title: photo.title ?? photo.description,
          description: photo.description,
          dateTaken: photo.displayDate,
          hasHotspots: photo.hotspots.isNotEmpty,
          onTap: () {
            HapticService.lightTap();
            if (photo.id == 'p1') gameState.advanceTutorialIfOnStep(14);
            Navigator.pushNamed(
              context,
              AppRoutes.photoViewer,
              arguments: {'photoId': photo.id, 'photoIndex': index},
            );
          },
        );
      },
    );
  }
}

class _HiddenPhotosSection extends StatefulWidget {
  final List<dynamic> photos;
  final GameStateProvider gameState;

  const _HiddenPhotosSection({required this.photos, required this.gameState});

  @override
  State<_HiddenPhotosSection> createState() => _HiddenPhotosSectionState();
}

class _HiddenPhotosSectionState extends State<_HiddenPhotosSection> {
  bool _isUnlocked = false;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'No hidden photos',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (!_isUnlocked) {
      // Collect valid passwords from hidden photos that have passwords,
      // or from locked notes in the case
      final validPasswords = <String>{};
      // Fallback: accept common case passwords or let the gameState handle it
      final gameState = Provider.of<GameStateProvider>(context, listen: false);
      // Check locked notes for password values as valid hidden album passwords
      for (final note in gameState.currentCase.notes) {
        if (note.isLocked && note.password != null) {
          validPasswords.add(note.password!.toLowerCase());
        }
      }
      // Check locked messages for passwords
      for (final conv in gameState.currentCase.conversations) {
        for (final msg in conv.messages) {
          if (msg.isLocked && msg.password != null) {
            validPasswords.add(msg.password!.toLowerCase());
          }
        }
      }
      // If no passwords found in case data, the hidden album has no valid password
      // (case authors should set passwords in their data)

      return _LockedView(
        onUnlock: (password) {
          final input = password.toLowerCase().trim();
          // Accept if input matches any case password, or if no passwords configured (dev mode)
          if (input.isNotEmpty &&
              (validPasswords.isEmpty || validPasswords.contains(input))) {
            setState(() => _isUnlocked = true);
            HapticService.heavyTap();
          } else {
            HapticService.vibrate();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Incorrect password — look for clues in the evidence'),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
      );
    }

    return _PhotoGrid(photos: widget.photos, gameState: widget.gameState);
  }
}

class _LockedView extends StatefulWidget {
  final Function(String) onUnlock;

  const _LockedView({required this.onUnlock});

  @override
  State<_LockedView> createState() => _LockedViewState();
}

class _LockedViewState extends State<_LockedView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock, size: 48, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Text(
              'Hidden Album',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter password to view',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              obscureText: true,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.textPrimary,
                fontSize: 18,
                letterSpacing: 4,
              ),
              decoration: InputDecoration(
                hintText: '••••••',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                  letterSpacing: 4,
                ),
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              onSubmitted: widget.onUnlock,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => widget.onUnlock(_controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Unlock',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hint: Check the notes or contacts\nfor password clues',
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: AppColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
