// Phone Detective - Phone Home Screen (Main Gameplay Hub)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/phone_frame.dart';
import '../widgets/app_icon.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class PhoneHomeScreen extends StatelessWidget {
  const PhoneHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PhoneFrame(child: _PhoneContent()),
        ),
      ),
    );
  }
}

class _PhoneContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);

    // Calculate badges
    int messagesBadge = 0;
    int emailBadge = 0;

    for (final conv in gameState.currentCase.conversations) {
      messagesBadge += conv.unreadCount;
    }
    for (final email in gameState.currentCase.emails) {
      if (!email.isRead) emailBadge++;
    }

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Wallpaper/background gradient
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gameState.currentCase.themeColor.withValues(alpha: 0.15),
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Case info header
                  _CaseHeader(caseData: gameState.currentCase),
                  const SizedBox(height: 40),
                  // App grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.68,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Row 1
                          AppIcon(
                            icon: Icons.chat_bubble,
                            label: 'Messages',
                            backgroundColor: AppColors.appIconColors[0],
                            badgeCount: messagesBadge,
                            onTap: () =>
                                _navigateTo(context, AppRoutes.messages),
                          ),
                          AppIcon(
                            icon: Icons.photo_library,
                            label: 'Gallery',
                            backgroundColor: AppColors.appIconColors[1],
                            onTap: () =>
                                _navigateTo(context, AppRoutes.gallery),
                          ),
                          AppIcon(
                            icon: Icons.person,
                            label: 'Contacts',
                            backgroundColor: AppColors.appIconColors[2],
                            onTap: () =>
                                _navigateTo(context, AppRoutes.contacts),
                          ),
                          AppIcon(
                            icon: Icons.email,
                            label: 'Email',
                            backgroundColor: AppColors.appIconColors[3],
                            badgeCount: emailBadge,
                            onTap: () => _navigateTo(context, AppRoutes.email),
                          ),
                          // Row 2
                          AppIcon(
                            icon: Icons.note,
                            label: 'Notes',
                            backgroundColor: AppColors.appIconColors[4],
                            onTap: () => _navigateTo(context, AppRoutes.notes),
                          ),
                          AppIcon(
                            icon: Icons.phone,
                            label: 'Recents',
                            backgroundColor: AppColors.appIconColors[5],
                            onTap: () =>
                                _navigateTo(context, AppRoutes.callLog),
                          ),
                          AppIcon(
                            icon: Icons.settings,
                            label: 'Settings',
                            backgroundColor: AppColors.appIconColors[6],
                            onTap: () =>
                                _navigateTo(context, AppRoutes.settings),
                          ),
                          AppIcon(
                            icon: Icons.search,
                            label: 'Journal',
                            backgroundColor: AppColors.appIconColors[7],
                            onTap: () => _navigateTo(
                              context,
                              AppRoutes.detectiveJournal,
                            ),
                          ),
                          // Row 3 - Placeholder apps
                          _PlaceholderAppIcon(
                            icon: Icons.calendar_today,
                            label: 'Calendar',
                          ),
                          _PlaceholderAppIcon(icon: Icons.map, label: 'Maps'),
                          _PlaceholderAppIcon(
                            icon: Icons.cloud,
                            label: 'Weather',
                          ),
                          _PlaceholderAppIcon(
                            icon: Icons.camera_alt,
                            label: 'Camera',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom dock
          _BottomDock(),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    HapticService.lightTap();
    Navigator.pushNamed(context, route);
  }
}

class _CaseHeader extends StatelessWidget {
  final dynamic caseData;

  const _CaseHeader({required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'CASE ${caseData.caseNumber}',
          style: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          caseData.title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PlaceholderAppIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PlaceholderAppIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.lightTap();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Not available in this case',
              style: GoogleFonts.roboto(color: AppColors.textPrimary),
            ),
            backgroundColor: AppColors.surfaceDark,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.textTertiary, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BottomDock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _DockIcon(
            icon: Icons.chat_bubble,
            onTap: () => Navigator.pushNamed(context, AppRoutes.messages),
          ),
          _DockIcon(
            icon: Icons.email,
            onTap: () => Navigator.pushNamed(context, AppRoutes.email),
          ),
          _DockIcon(
            icon: Icons.search,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.detectiveJournal),
          ),
          _DockIcon(
            icon: Icons.arrow_back,
            onTap: () {
              HapticService.lightTap();
              Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
            },
          ),
        ],
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DockIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.lightTap();
        onTap();
      },
      child: Icon(icon, color: AppColors.textPrimary, size: 24),
    );
  }
}
