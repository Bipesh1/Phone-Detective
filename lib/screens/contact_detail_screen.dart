// Phone Detective - Contact Detail Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/animated_button.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../models/clue.dart';

class ContactDetailScreen extends StatelessWidget {
  final String contactId;

  const ContactDetailScreen({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final contact = gameState.currentCase.getContact(contactId);
    final isSuspect = gameState.isSuspect(contactId);

    if (contact == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text(
            'Contact not found',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    // Get related clues
    final relatedClues = gameState.currentClues.where((c) {
      // Check if clue is from this contact's conversation
      return c.sourceId.contains(contactId) ||
          c.preview.contains(contact.fullName);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            backgroundColor: AppColors.backgroundSecondary,
            expandedHeight: 260,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      contact.avatarColor.withValues(alpha: 0.3),
                      AppColors.backgroundSecondary,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: contact.avatarColor,
                            child: Text(
                              contact.initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isSuspect)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.backgroundSecondary,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.priority_high,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        contact.fullName,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (contact.relationship != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            contact.relationship!,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconActionButton(
                        icon: Icons.message,
                        label: 'Message',
                        onTap: () {
                          HapticService.lightTap();
                          Navigator.pushNamed(
                            context,
                            AppRoutes.conversation,
                            arguments: {'contactId': contactId},
                          );
                        },
                      ),
                      IconActionButton(
                        icon: Icons.email,
                        label: 'Email',
                        onTap: () {
                          HapticService.lightTap();
                          Navigator.pushNamed(context, AppRoutes.email);
                        },
                      ),
                      IconActionButton(
                        icon:
                            isSuspect ? Icons.person_remove : Icons.person_add,
                        label: isSuspect ? 'Remove' : 'Suspect',
                        color: isSuspect ? AppColors.danger : AppColors.warning,
                        onTap: () {
                          HapticService.mediumTap();
                          gameState.toggleSuspect(contactId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isSuspect
                                    ? 'Removed from suspects'
                                    : 'Marked as suspect',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Contact info
                  _InfoSection(
                    title: 'Contact Info',
                    children: [
                      if (contact.phoneNumber != null)
                        _InfoRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: contact.phoneNumber!,
                        ),
                      if (contact.email != null)
                        _InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: contact.email!,
                        ),
                      if (contact.birthday != null)
                        _InfoRow(
                          icon: Icons.cake,
                          label: 'Birthday',
                          value: _formatDate(contact.birthday!),
                        ),
                    ],
                  ),
                  if (contact.notes != null) ...[
                    const SizedBox(height: 24),
                    _InfoSection(
                      title: 'Notes',
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            contact.notes!,
                            style: GoogleFonts.roboto(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Related clues
                  if (relatedClues.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _InfoSection(
                      title: 'Related Clues (${relatedClues.length})',
                      children: relatedClues
                          .map(
                            (clue) => ListTile(
                              leading: Text(
                                clue.type.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                              title: Text(
                                clue.preview,
                                style: GoogleFonts.roboto(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(
                                Icons.bookmark,
                                color: AppColors.clue,
                                size: 18,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      // Expects YYYY-MM-DD
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: GoogleFonts.roboto(color: AppColors.textSecondary, fontSize: 12),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.roboto(color: AppColors.textPrimary, fontSize: 16),
      ),
    );
  }
}
