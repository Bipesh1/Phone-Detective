// Phone Detective - Contacts App Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/contact_card.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../widgets/investigation_nav_bar.dart';
import '../widgets/tutorial_banner.dart';
import '../widgets/app_intro_banner.dart';

class ContactsAppScreen extends StatefulWidget {
  const ContactsAppScreen({super.key});

  @override
  State<ContactsAppScreen> createState() => _ContactsAppScreenState();
}

class _ContactsAppScreenState extends State<ContactsAppScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final allContacts = gameState.currentCase.contacts;

    // Filter and sort contacts
    final filteredContacts = allContacts.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    filteredContacts.sort((a, b) => a.lastName.compareTo(b.lastName));

    // Group by first letter
    final groupedContacts = <String, List<dynamic>>{};
    for (final contact in filteredContacts) {
      final letter = contact.lastName.isNotEmpty
          ? contact.lastName[0].toUpperCase()
          : '#';
      groupedContacts.putIfAbsent(letter, () => []).add(contact);
    }

    final sortedKeys = groupedContacts.keys.toList()..sort();

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
          'Contacts',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          TutorialBanner(stepMessages: {
            5: 'Tap each contact to view their profile and messages.\n'
                'Pay attention to relationships — someone had a reason to be there.',
          }),
          const AppIntroBanner(
            appId: 'contacts',
            emoji: '👥',
            appName: 'Contacts',
            color: Color(0xFFFF9F0A),
            description:
                'Everyone in this phone\'s address book. Their relationship to the victim and their profile notes can point you toward who had a reason.',
            howTo:
                'Tap a contact to view their full profile. Hold a contact\'s name to mark them as a suspect in your journal.',
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: GoogleFonts.roboto(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search contacts',
                hintStyle: GoogleFonts.roboto(color: AppColors.textTertiary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                ),
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          // Contact list
          Expanded(
            child: filteredContacts.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      final letter = sortedKeys[index];
                      final contacts = groupedContacts[letter]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Text(
                              letter,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          // Contacts in section
                          ...contacts.map(
                            (contact) => ContactCard(
                              contact: contact,
                              isSuspect: gameState.isSuspect(contact.id),
                              onTap: () {
                                HapticService.lightTap();
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.contactDetail,
                                  arguments: {'contactId': contact.id},
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'No contacts found',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
