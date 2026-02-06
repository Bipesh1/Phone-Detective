// Phone Detective - Detective Journal Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/clue_tag.dart';
import '../widgets/contact_card.dart';
import '../widgets/journal_entry.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../models/clue.dart';

class DetectiveJournalScreen extends StatefulWidget {
  const DetectiveJournalScreen({super.key});

  @override
  State<DetectiveJournalScreen> createState() => _DetectiveJournalScreenState();
}

class _DetectiveJournalScreenState extends State<DetectiveJournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSecondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detective Journal',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.clue,
          labelColor: AppColors.clue,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Clues (${gameState.currentClues.length})'),
            Tab(text: 'Suspects (${gameState.currentSuspects.length})'),
            const Tab(text: 'Timeline'),
            const Tab(text: 'Notes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CluesTab(gameState: gameState),
          _SuspectsTab(gameState: gameState),
          _TimelineTab(gameState: gameState),
          _NotesTab(gameState: gameState),
        ],
      ),
      bottomNavigationBar: _SolveButton(gameState: gameState),
    );
  }
}

class _CluesTab extends StatelessWidget {
  final GameStateProvider gameState;
  const _CluesTab({required this.gameState});

  @override
  Widget build(BuildContext context) {
    if (gameState.currentClues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No clues marked yet',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Long-press items to mark as clues',
              style: GoogleFonts.roboto(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: gameState.currentClues.length,
      itemBuilder: (context, index) => ClueTag(
        clue: gameState.currentClues[index],
        showRemove: true,
        onRemove: () => gameState.removeClue(gameState.currentClues[index].id),
      ),
    );
  }
}

class _SuspectsTab extends StatelessWidget {
  final GameStateProvider gameState;
  const _SuspectsTab({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final suspects = gameState.currentSuspects
        .map((id) => gameState.currentCase.getContact(id))
        .where((c) => c != null)
        .toList();
    if (suspects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'No suspects marked',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: suspects.length,
      itemBuilder: (context, index) {
        final contact = suspects[index]!;
        return ContactCard(
          contact: contact,
          isSuspect: true,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.contactDetail,
            arguments: {'contactId': contact.id},
          ),
        );
      },
    );
  }
}

class _TimelineTab extends StatelessWidget {
  final GameStateProvider gameState;
  const _TimelineTab({required this.gameState});

  @override
  Widget build(BuildContext context) {
    // Build timeline from all clues sorted by time
    final clues = [...gameState.currentClues]
      ..sort((a, b) => a.foundAt.compareTo(b.foundAt));
    if (clues.isEmpty) {
      return Center(
        child: Text(
          'Investigate to build timeline',
          style: GoogleFonts.poppins(color: AppColors.textSecondary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clues.length,
      itemBuilder: (context, index) {
        final clue = clues[index];
        return JournalEntry(
          time:
              '${clue.foundAt.hour}:${clue.foundAt.minute.toString().padLeft(2, '0')}',
          title: clue.type.label,
          description: clue.preview,
          icon: clue.type.icon,
          isFirst: index == 0,
          isLast: index == clues.length - 1,
        );
      },
    );
  }
}

class _NotesTab extends StatefulWidget {
  final GameStateProvider gameState;
  const _NotesTab({required this.gameState});

  @override
  State<_NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<_NotesTab> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.gameState.playerNotes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Investigation Notes',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: GoogleFonts.roboto(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Write your theories and observations...',
                hintStyle: GoogleFonts.roboto(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => widget.gameState.updatePlayerNotes(value),
            ),
          ),
        ],
      ),
    );
  }
}

class _SolveButton extends StatelessWidget {
  final GameStateProvider gameState;
  const _SolveButton({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(top: BorderSide(color: AppColors.surfaceDark)),
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticService.mediumTap();
          Navigator.pushNamed(context, AppRoutes.solution);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gavel, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'SOLVE CASE',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
