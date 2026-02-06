// Phone Detective - Settings App Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class SettingsAppScreen extends StatelessWidget {
  const SettingsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          // Account Section
          _SettingsSection(
            title: 'ACCOUNT',
            children: [
              _SettingsTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: 'Phone Owner',
                subtitle: 'Evidence device',
              ),
            ],
          ),
          // Phone Section
          _SettingsSection(
            title: 'PHONE',
            children: [
              _SettingsTile(
                icon: Icons.storage,
                title: 'Storage',
                subtitle: '12.3 GB used of 64 GB',
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'iPhone 13 Pro • iOS 16.2',
              ),
            ],
          ),
          // Game Section
          _SettingsSection(
            title: 'GAME',
            children: [
              _SettingsTile(
                icon: Icons.refresh,
                title: 'Reset Current Case',
                subtitle: 'Clear all clues and progress',
                onTap: () => _showResetDialog(context, gameState, false),
              ),
              _SettingsTile(
                icon: Icons.delete_forever,
                title: 'Reset All Progress',
                subtitle: 'Start completely fresh',
                textColor: AppColors.danger,
                onTap: () => _showResetDialog(context, gameState, true),
              ),
            ],
          ),
          // About Section
          _SettingsSection(
            title: 'ABOUT',
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'How to Play',
                onTap: () => _showHowToPlay(context),
              ),
              _SettingsTile(
                icon: Icons.code,
                title: 'Version',
                subtitle: '1.0.0',
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showResetDialog(
    BuildContext context,
    GameStateProvider gameState,
    bool resetAll,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          resetAll ? 'Reset All Progress?' : 'Reset Current Case?',
          style: GoogleFonts.poppins(color: AppColors.textPrimary),
        ),
        content: Text(
          resetAll
              ? 'This will erase all save data.'
              : 'This will clear clues and suspects for this case.',
          style: GoogleFonts.roboto(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (resetAll) {
                gameState.resetAllProgress();
                Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
              } else {
                gameState.resetCurrentCase();
                Navigator.pop(context);
              }
              HapticService.heavyTap();
            },
            child: Text('Reset', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'How to Play',
          style: GoogleFonts.poppins(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Text(
            '1. Explore the phone apps\n2. Long-press items to mark as clues\n3. Check the Detective Journal\n4. Mark suspects in Contacts\n5. Solve the case when ready',
            style: GoogleFonts.roboto(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: AppColors.textTertiary,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? textColor;

  const _SettingsTile({
    this.icon,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading:
          leading ??
          (icon != null
              ? Icon(icon, color: textColor ?? AppColors.textSecondary)
              : null),
      title: Text(
        title,
        style: GoogleFonts.roboto(color: textColor ?? AppColors.textPrimary),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.roboto(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            )
          : null,
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: AppColors.textTertiary)
          : null,
    );
  }
}
