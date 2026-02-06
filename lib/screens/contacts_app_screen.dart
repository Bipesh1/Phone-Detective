// Phone Detective - Contacts App Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/contact_card.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

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
