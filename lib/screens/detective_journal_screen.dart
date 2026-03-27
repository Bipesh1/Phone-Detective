// Phone Detective - Detective Journal Screen
// Central hub for reviewing evidence, suspects, timeline, and solving the case.

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
import '../widgets/tutorial_banner.dart';

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
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final clueCount = gameState.currentClues.length;
    final suspectCount = gameState.currentSuspects.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detective Journal',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              gameState.currentCase.title,
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        actions: [
          // Quick mini-stats
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (clueCount > 0)
                  _StatPill(
                    icon: Icons.bookmark,
                    value: '$clueCount',
                    color: AppColors.clue,
                  ),
                if (suspectCount > 0) ...[
                  const SizedBox(width: 6),
                  _StatPill(
                    icon: Icons.person_search,
                    value: '$suspectCount',
                    color: AppColors.danger,
                  ),
                ],
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.clue,
          labelColor: AppColors.clue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorWeight: 2,
          labelStyle: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.roboto(fontSize: 12),
          tabs: [
            Tab(text: 'Clues${clueCount > 0 ? " ($clueCount)" : ""}'),
            Tab(text: 'Suspects${suspectCount > 0 ? " ($suspectCount)" : ""}'),
            const Tab(text: 'Timeline'),
            const Tab(text: 'Connections'),
            const Tab(text: 'Notes'),
          ],
        ),
      ),
      body: Column(
        children: [
          TutorialBanner(stepMessages: {
            11: 'Review your clues in the Evidence tab.\n'
                'Head to Suspects to mark who you think did it, then tap MAKE YOUR ACCUSATION.',
          }),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _CluesTab(gameState: gameState),
                _SuspectsTab(gameState: gameState),
                _TimelineTab(gameState: gameState),
                _ConnectionsTab(gameState: gameState),
                _NotesTab(gameState: gameState),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _SolveBar(gameState: gameState),
    );
  }
}

// ─── Stat Pill ───────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _StatPill({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 3),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Clues Tab ───────────────────────────────────────────────────────────────

class _CluesTab extends StatelessWidget {
  final GameStateProvider gameState;
  const _CluesTab({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TabDescription(
          'Everything you\'ve marked as evidence. Long-press any message, email, note, call, or photo to add it here.',
        ),
        if (gameState.currentClues.isEmpty)
          Expanded(
            child: _EmptyState(
              icon: Icons.bookmark_border,
              title: 'No evidence yet',
              subtitle: 'Long-press messages, emails, notes, or calls to mark as clues.',
              action: _EmptyAction(
                label: 'Start Investigating',
                icon: Icons.phone_android,
                onTap: () => Navigator.pop(context),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: gameState.currentClues.length,
              itemBuilder: (context, index) => ClueTag(
                clue: gameState.currentClues[index],
                showRemove: true,
                onRemove: () =>
                    gameState.removeClue(gameState.currentClues[index].id),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Suspects Tab ────────────────────────────────────────────────────────────

class _SuspectsTab extends StatelessWidget {
  final GameStateProvider gameState;
  const _SuspectsTab({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final suspects = gameState.currentSuspects
        .map((id) => gameState.currentCase.getContact(id))
        .where((c) => c != null)
        .toList();

    return Column(
      children: [
        _TabDescription(
          'Contacts you\'ve flagged as suspects. Go to Contacts and long-press a name to add someone here.',
        ),
        if (suspects.isEmpty)
          Expanded(
            child: _EmptyState(
              icon: Icons.person_search,
              title: 'No suspects marked',
              subtitle:
                  'Visit Contacts and long-press a contact to mark them as a suspect.',
              action: _EmptyAction(
                label: 'Open Contacts',
                icon: Icons.contacts,
                onTap: () => Navigator.pushNamed(context, AppRoutes.contacts),
              ),
            ),
          )
        else ...[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.warning, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Narrow down your suspects using the clues you've collected before making your accusation.",
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
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
          ),
        ),
        ],
      ],
    );
  }
}

// ─── Timeline Tab ────────────────────────────────────────────────────────────

class _TimelineTab extends StatelessWidget {
  final GameStateProvider gameState;
  const _TimelineTab({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final clues = [...gameState.currentClues]
      ..sort((a, b) => a.foundAt.compareTo(b.foundAt));

    return Column(
      children: [
        _TabDescription(
          'Clues in the order you discovered them. Use "Reconstruct the Timeline" to arrange events by when they happened in the case.',
        ),
        // Timeline Builder mini-game button
        if (!gameState.timelineCompleted)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: InkWell(
              onTap: () {
                HapticService.lightTap();
                Navigator.pushNamed(context, AppRoutes.timelineBuilder);
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE91E63).withValues(alpha: 0.2),
                      const Color(0xFFE91E63).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE91E63).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.timeline,
                        color: Color(0xFFE91E63),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reconstruct the Timeline',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Arrange events in chronological order',
                            style: GoogleFonts.roboto(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFE91E63),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Timeline reconstructed!',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),

        // Discovery timeline (clues in order found)
        Expanded(
          child: clues.isEmpty
              ? _EmptyState(
                  icon: Icons.history_toggle_off,
                  title: 'Nothing in timeline yet',
                  subtitle: 'Events will appear here as you collect clues.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                ),
        ),
      ],
    );
  }
}

// ─── Connections Tab ─────────────────────────────────────────────────────────

class _ConnectionsTab extends StatelessWidget {
  final GameStateProvider gameState;
  const _ConnectionsTab({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final clues = gameState.currentClues;

    if (clues.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabDescription(
            'All your evidence grouped by type — messages, emails, calls, notes, photos. Use this to spot patterns and build your case.',
          ),
          const Expanded(
            child: _EmptyState(
              icon: Icons.dashboard_customize_outlined,
              title: 'Evidence board is empty',
              subtitle:
                  'Hold messages, emails, notes, calls, or photos to mark them as evidence. They\'ll appear here.',
            ),
          ),
        ],
      );
    }

    // Group clues by type
    final grouped = <ClueType, List<Clue>>{};
    for (final clue in clues) {
      grouped.putIfAbsent(clue.type, () => []).add(clue);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.dashboard_customize_outlined,
                  color: AppColors.clue, size: 16),
              const SizedBox(width: 8),
              Text(
                'EVIDENCE BOARD',
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.clue,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Text(
                '${clues.length} piece${clues.length == 1 ? '' : 's'} collected',
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Evidence you\'ve marked during your investigation.',
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 20),

          // Evidence grouped by type
          ...grouped.entries.map((entry) {
            final type = entry.key;
            final typeClues = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section label
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        type.icon,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        type.label.toUpperCase(),
                        style: GoogleFonts.robotoMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Clue cards
                ...typeClues.map(
                  (clue) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.clue.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.clue.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.clue.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              clue.type.icon,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            clue.preview,
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.bookmark,
                          color: AppColors.clue,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            );
          }),

          // Footer hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.textTertiary,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Trust your instincts. When you have enough to make a case, go to the Clues tab and tap MAKE YOUR ACCUSATION.',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Notes Tab ───────────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note, color: AppColors.textTertiary, size: 18),
              const SizedBox(width: 8),
              Text(
                'YOUR INVESTIGATION NOTES',
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Your private scratchpad. Write theories, note inconsistencies, track who said what. Saved automatically.',
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: GoogleFonts.roboto(
                color: AppColors.textPrimary,
                fontSize: 15,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText:
                    'Write your theories...\n\nWho had motive? Who had opportunity?\nWhat doesn\'t add up?',
                hintStyle: GoogleFonts.roboto(
                  color: AppColors.textTertiary,
                  height: 1.7,
                ),
                filled: true,
                fillColor: AppColors.surfaceDark,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
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

// ─── Solve Bar ───────────────────────────────────────────────────────────────

class _SolveBar extends StatelessWidget {
  final GameStateProvider gameState;
  const _SolveBar({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final clueCount = gameState.currentClues.length;
    final isReady = clueCount >= 3;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border(top: BorderSide(color: AppColors.surfaceDark)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress summary
            if (!isReady)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textTertiary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Collect at least 3 clues before solving. Found: $clueCount clue${clueCount != 1 ? 's' : ''}.',
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Solve button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticService.mediumTap();
                  if (!isReady) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Keep investigating — you need at least 3 clues.',
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                        backgroundColor: AppColors.surfaceDark,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  Navigator.pushNamed(context, AppRoutes.solution);
                },
                icon: const Icon(Icons.gavel, color: Colors.white),
                label: Text(
                  isReady ? 'MAKE YOUR ACCUSATION' : 'NOT ENOUGH EVIDENCE',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isReady ? AppColors.success : AppColors.surfaceDark,
                  disabledBackgroundColor: AppColors.surfaceDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: isReady
                        ? BorderSide.none
                        : BorderSide(color: AppColors.textTertiary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab Description ─────────────────────────────────────────────────────────

class _TabDescription extends StatelessWidget {
  final String text;
  const _TabDescription(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          color: AppColors.textTertiary,
          height: 1.4,
        ),
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final _EmptyAction? action;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: AppColors.textTertiary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: action!.onTap,
                icon: Icon(action!.icon, size: 16),
                label: Text(action!.label),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _EmptyAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
