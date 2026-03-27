// Phone Detective - Phone Home Screen (Main Gameplay Hub)
// Full-screen redesign: no PhoneFrame wrapper, clean grid, proper nav.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/app_icon.dart';
import '../widgets/tutorial_overlay.dart';
import '../widgets/suspense_overlay.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../models/contact.dart';
import '../models/case_data.dart';

class PhoneHomeScreen extends StatefulWidget {
  const PhoneHomeScreen({super.key});

  @override
  State<PhoneHomeScreen> createState() => _PhoneHomeScreenState();
}

class _PhoneHomeScreenState extends State<PhoneHomeScreen> {
  final GlobalKey _messagesKey = GlobalKey(debugLabel: 'messagesKey');
  final GlobalKey _galleryKey = GlobalKey(debugLabel: 'galleryKey');
  final GlobalKey _contactsKey = GlobalKey(debugLabel: 'contactsKey');
  final GlobalKey _emailKey = GlobalKey(debugLabel: 'emailKey');
  final GlobalKey _notesKey = GlobalKey(debugLabel: 'notesKey');
  final GlobalKey _callLogKey = GlobalKey(debugLabel: 'callLogKey');
  final GlobalKey _hintsKey = GlobalKey(debugLabel: 'hintsKey');
  final GlobalKey _journalKey = GlobalKey(debugLabel: 'journalKey');
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Provider has its own guard — safe to call every time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<GameStateProvider>(context, listen: false)
            .startTimedEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          _PhoneContent(
            messagesKey: _messagesKey,
            galleryKey: _galleryKey,
            contactsKey: _contactsKey,
            emailKey: _emailKey,
            notesKey: _notesKey,
            callLogKey: _callLogKey,
            hintsKey: _hintsKey,
            journalKey: _journalKey,
          ),
          Positioned.fill(child: _buildTutorialOverlay(context)),
          Positioned.fill(child: _buildSuspenseOverlay(context)),
        ],
      ),
    );
  }

  Widget _buildTutorialOverlay(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        if (!gameState.isTutorialActive) return const SizedBox.shrink();

        // Only show home overlay for steps that belong to the home screen.
        // Steps 3-4 (inside messages) and 10 (journal solve) are sub-screen.
        const homeSteps = {1, 2, 5, 6, 7, 8, 9, 10};
        if (!homeSteps.contains(gameState.tutorialStep)) {
          return const SizedBox.shrink();
        }

        String message = '';
        GlobalKey? target;
        VoidCallback onContinue = gameState.nextTutorialStep;
        bool isLast = false;
        bool requireAction = false;

        final caseData = gameState.currentCase;
        final clueCount = gameState.currentClues.length;

        // Find the phone owner contact dynamically
        Contact? ownerContact;
        try {
          ownerContact = caseData.contacts.firstWhere(
            (c) =>
                (c.relationship?.toLowerCase().contains('owner') ?? false) ||
                c.id == 'owner' ||
                c.id == 'me',
          );
        } catch (_) {
          ownerContact = caseData.contacts.isNotEmpty ? caseData.contacts.first : null;
        }
        final ownerName = ownerContact?.firstName ?? 'the victim';

        switch (gameState.tutorialStep) {
          // ── Step 1: Scene-setter (dynamic from case data) ────────────────
          case 1:
            message =
                'CASE ${caseData.caseNumber.toString().padLeft(2, '0')} — "${caseData.title}"\n\n'
                '${caseData.objective}\n\n'
                'You have full access to $ownerName\'s phone.\n'
                'Start by reading the Messages.';
            target = null;
            break;

          // ── Step 2: Open Messages (action-gated) ─────────────────────────
          case 2:
            message =
                'Open Messages ↑\n\n'
                'Start by reading $ownerName\'s conversations. '
                'Something in one of them doesn\'t add up.';
            target = _messagesKey;
            requireAction = true;
            break;

          // ── Step 5: Open Contacts (action-gated) ─────────────────────────
          case 5:
            message =
                '${clueCount > 0 ? '$clueCount clue${clueCount == 1 ? '' : 's'} found.\n\n' : ''}'
                'Now open Contacts ↑\n\n'
                'Review who $ownerName knew. Pay attention to '
                'relationships — someone nearby had a reason to be there.';
            target = _contactsKey;
            requireAction = true;
            break;

          // ── Step 6: Open Call Log (action-gated) ─────────────────────────
          case 6:
            message =
                'Now check Call Log ↑\n\n'
                'Review who called $ownerName and when. '
                'Calls made close to the time of death are key.';
            target = _callLogKey;
            requireAction = true;
            break;

          // ── Step 7: Open Notes (action-gated) ────────────────────────────
          case 7:
            message =
                'Now open Notes ↑\n\n'
                '$ownerName kept private entries. '
                'One may be locked — the unlock code is somewhere on this phone.';
            target = _notesKey;
            requireAction = true;
            break;

          // ── Step 8: Open Email (action-gated) ────────────────────────────
          case 8:
            message =
                'Now check Email ↑\n\n'
                'Apps send automated alerts when something goes wrong. '
                'A timestamp in an email could change everything.';
            target = _emailKey;
            requireAction = true;
            break;

          // ── Step 9: Open Gallery (action-gated) ──────────────────────────
          case 9:
            message =
                'Open Gallery ↑\n\n'
                'The most recent photo may not have been taken by $ownerName. '
                'Check the timestamp and location carefully.';
            target = _galleryKey;
            requireAction = true;
            break;

          // ── Step 10: Open Journal — final step ───────────────────────────
          case 10:
            message =
                '${clueCount > 0 ? '$clueCount clue${clueCount == 1 ? '' : 's'} found.\n\n' : ''}'
                'Open your Detective Journal ↑\n\n'
                'Review your evidence, mark a suspect, and tap SOLVE CASE '
                'when you know what really happened.';
            target = _journalKey;
            requireAction = true;
            isLast = true;
            break;
        }

        return TutorialOverlay(
          key: ValueKey('tutorial_${gameState.tutorialStep}'),
          message: message,
          onContinue: onContinue,
          targetKey: target,
          isLastStep: isLast,
          requireAction: requireAction,
        );
      },
    );
  }

  Widget _buildSuspenseOverlay(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        final event = gameState.pendingSuspenseEvent;
        if (event == null) return const SizedBox.shrink();

        return SuspenseOverlay(
          key: ValueKey('suspense_${event.id}'),
          event: event,
          onDismiss: () => gameState.dismissSuspenseEvent(),
        );
      },
    );
  }
}

// ─── Main Phone Content ──────────────────────────────────────────────────────

class _PhoneContent extends StatelessWidget {
  final GlobalKey messagesKey;
  final GlobalKey galleryKey;
  final GlobalKey contactsKey;
  final GlobalKey emailKey;
  final GlobalKey notesKey;
  final GlobalKey callLogKey;
  final GlobalKey hintsKey;
  final GlobalKey journalKey;

  const _PhoneContent({
    required this.messagesKey,
    required this.galleryKey,
    required this.contactsKey,
    required this.emailKey,
    required this.notesKey,
    required this.callLogKey,
    required this.hintsKey,
    required this.journalKey,
  });

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;

    // Notification badges
    int messagesBadge = 0;
    int emailBadge = 0;
    for (final conv in gameState.currentCase.conversations) {
      messagesBadge += conv.unreadCount;
    }
    for (final email in gameState.currentCase.emails) {
      if (!email.isRead) emailBadge++;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gameState.currentCase.themeColor.withValues(alpha: 0.18),
            const Color(0xFF080810),
          ],
        ),
      ),
      child: Column(
        children: [
          // ── Status Bar ──
          _StatusBar(topPad: topPad),

          // ── Case Header ──
          _CaseHeader(
            gameState: gameState,
            onExitTap: () => _confirmExit(context),
          ),

          // ── Objective Reminder ──
          _ObjectiveBar(objective: gameState.currentCase.objective),

          const SizedBox(height: 4),

          // ── App Grid ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width < 360 ? 12 : 20,
              ),
              child: _AppGrid(
                gameState: gameState,
                messagesKey: messagesKey,
                galleryKey: galleryKey,
                contactsKey: contactsKey,
                emailKey: emailKey,
                notesKey: notesKey,
                callLogKey: callLogKey,
                hintsKey: hintsKey,
                journalKey: journalKey,
                messagesBadge: messagesBadge,
                emailBadge: emailBadge,
              ),
            ),
          ),

          // ── Bottom Action Dock ──
          _ActionDock(
            journalKey: journalKey,
            clueCount: gameState.currentClues.length,
            suspectCount: gameState.currentSuspects.length,
            onExit: () => _confirmExit(context),
          ),
        ],
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    HapticService.lightTap();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Exit Investigation?',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Your progress is saved. You can continue this case later from Case Select.',
          style: GoogleFonts.roboto(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Keep Investigating',
              style: GoogleFonts.roboto(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              HapticService.mediumTap();
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
            },
            child: Text(
              'Exit',
              style: GoogleFonts.roboto(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status Bar ──────────────────────────────────────────────────────────────

class _StatusBar extends StatelessWidget {
  final double topPad;
  const _StatusBar({required this.topPad});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';

    return Container(
      padding: EdgeInsets.only(
        top: topPad + 4,
        left: 20,
        right: 20,
        bottom: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$hour:$minute $period',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.signal_cellular_4_bar,
                color: AppColors.textPrimary,
                size: 14,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, color: AppColors.textPrimary, size: 14),
              const SizedBox(width: 6),
              _BatteryWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class _BatteryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 10,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textPrimary, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.80,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 2,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(1),
              bottomRight: Radius.circular(1),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Case Header ─────────────────────────────────────────────────────────────

class _CaseHeader extends StatelessWidget {
  final GameStateProvider gameState;
  final VoidCallback onExitTap;

  const _CaseHeader({required this.gameState, required this.onExitTap});

  @override
  Widget build(BuildContext context) {
    final caseData = gameState.currentCase;
    final clueCount = gameState.currentClues.length;
    final totalClues = caseData.totalClues;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Case info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CASE ${caseData.caseNumber.toString().padLeft(2, '0')}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: caseData.themeColor,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  caseData.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Clue progress pill
          if (totalClues > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.clue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.clue.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark, color: AppColors.clue, size: 13),
                  const SizedBox(width: 4),
                  Text(
                    '$clueCount/$totalClues',
                    style: GoogleFonts.robotoMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.clue,
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

// ─── Objective Bar ──────────────────────────────────────────────────────────

class _ObjectiveBar extends StatefulWidget {
  final String objective;
  const _ObjectiveBar({required this.objective});

  @override
  State<_ObjectiveBar> createState() => _ObjectiveBarState();
}

class _ObjectiveBarState extends State<_ObjectiveBar> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.objective.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(Icons.flag_rounded, color: AppColors.primary, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.objective,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: _expanded ? 10 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textTertiary,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── App Grid ────────────────────────────────────────────────────────────────

class _AppGrid extends StatelessWidget {
  final GameStateProvider gameState;
  final GlobalKey messagesKey;
  final GlobalKey galleryKey;
  final GlobalKey contactsKey;
  final GlobalKey emailKey;
  final GlobalKey notesKey;
  final GlobalKey callLogKey;
  final GlobalKey hintsKey;
  final GlobalKey journalKey;
  final int messagesBadge;
  final int emailBadge;

  const _AppGrid({
    required this.gameState,
    required this.messagesKey,
    required this.galleryKey,
    required this.contactsKey,
    required this.emailKey,
    required this.notesKey,
    required this.callLogKey,
    required this.hintsKey,
    required this.journalKey,
    required this.messagesBadge,
    required this.emailBadge,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Responsive icon size
    final iconSize = (size.width - 40) / 4 - 18.0;
    final clampedIconSize = iconSize.clamp(52.0, 70.0);

    // 8 investigation apps in 2 rows of 4
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: size.height < 700 ? 16 : 28,
      crossAxisSpacing: 10,
      childAspectRatio: clampedIconSize / (clampedIconSize + 22),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        // Row 1: Messages, Gallery, Contacts, Email
        AppIcon(
          tutorialKey: messagesKey,
          icon: Icons.chat_bubble,
          label: 'Messages',
          backgroundColor: AppColors.appIconColors[0],
          badgeCount: messagesBadge,
          onTap: () => _nav(context, AppRoutes.messages),
        ),
        AppIcon(
          tutorialKey: galleryKey,
          icon: Icons.photo_library,
          label: 'Gallery',
          backgroundColor: AppColors.appIconColors[1],
          onTap: () => _nav(context, AppRoutes.gallery),
        ),
        AppIcon(
          tutorialKey: contactsKey,
          icon: Icons.contacts,
          label: 'Contacts',
          backgroundColor: AppColors.appIconColors[2],
          onTap: () => _nav(context, AppRoutes.contacts),
        ),
        AppIcon(
          tutorialKey: emailKey,
          icon: Icons.mail,
          label: 'Email',
          backgroundColor: AppColors.appIconColors[3],
          badgeCount: emailBadge,
          onTap: () => _nav(context, AppRoutes.email),
        ),

        // Row 2: Notes, Recents, Hints, Journal
        AppIcon(
          tutorialKey: notesKey,
          icon: Icons.sticky_note_2,
          label: 'Notes',
          backgroundColor: AppColors.appIconColors[4],
          onTap: () => _nav(context, AppRoutes.notes),
        ),
        AppIcon(
          tutorialKey: callLogKey,
          icon: Icons.call,
          label: 'Recents',
          backgroundColor: AppColors.appIconColors[5],
          onTap: () => _nav(context, AppRoutes.callLog),
        ),
        AppIcon(
          tutorialKey: hintsKey,
          icon: Icons.lightbulb_outline,
          label: 'Hints',
          backgroundColor: const Color(0xFF5E5CE6),
          onTap: () => _showHintsDialog(context),
        ),
        AppIcon(
          tutorialKey: journalKey,
          icon: Icons.menu_book,
          label: 'Journal',
          backgroundColor: AppColors.appIconColors[7],
          badgeCount: gameState.currentClues.length,
          onTap: () => _nav(context, AppRoutes.detectiveJournal),
        ),
      ],
    );
  }

  void _nav(BuildContext context, String route) {
    HapticService.lightTap();
    final gs = Provider.of<GameStateProvider>(context, listen: false);

    // Tutorial: auto-advance when the correct highlighted app is opened
    if (route == AppRoutes.messages) gs.advanceTutorialIfOnStep(2);
    if (route == AppRoutes.contacts) gs.advanceTutorialIfOnStep(5);
    if (route == AppRoutes.callLog) gs.advanceTutorialIfOnStep(6);
    if (route == AppRoutes.notes) gs.advanceTutorialIfOnStep(7);
    if (route == AppRoutes.email) gs.advanceTutorialIfOnStep(8);
    if (route == AppRoutes.gallery) gs.advanceTutorialIfOnStep(9);
    if (route == AppRoutes.detectiveJournal) {
      if (gs.isTutorialActive && gs.tutorialStep == 10) gs.nextTutorialStep();
    }

    // onOpen suspense events — fire when player opens a specific app
    const routeToApp = {
      AppRoutes.messages: 'messages',
      AppRoutes.gallery: 'gallery',
      AppRoutes.contacts: 'contacts',
      AppRoutes.email: 'email',
      AppRoutes.notes: 'notes',
      AppRoutes.callLog: 'call_log',
      AppRoutes.detectiveJournal: 'journal',
    };
    final appName = routeToApp[route];
    if (appName != null) gs.triggerOnOpenSuspenseEvent(appName);

    Navigator.pushNamed(context, route);
  }

  void _showHintsDialog(BuildContext context) {
    HapticService.mediumTap();
    final difficulty = gameState.currentCase.difficulty;

    // Very hard: no hints allowed
    if (difficulty == CaseDifficulty.veryHard) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No hints available on Very Hard difficulty.',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: AppColors.surfaceDark,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final allHints = gameState.currentCase.hints;
    // Hard: cap at 1 hint
    final hints = difficulty == CaseDifficulty.hard && allHints.isNotEmpty
        ? allHints.sublist(0, 1)
        : allHints;

    final revealedCount = gameState.revealedHints['_general'] ?? 0;

    showDialog(
      context: context,
      builder: (ctx) => _ProgressiveHintsDialog(
        hints: hints,
        initialRevealed: revealedCount,
        onReveal: (count) {
          gameState.revealedHints['_general'] = count;
        },
      ),
    );
  }
}

// ─── Action Dock ─────────────────────────────────────────────────────────────

class _ActionDock extends StatelessWidget {
  final GlobalKey journalKey;
  final int clueCount;
  final int suspectCount;
  final VoidCallback onExit;

  const _ActionDock({
    required this.journalKey,
    required this.clueCount,
    required this.suspectCount,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Exit button
          _DockItem(
            icon: Icons.exit_to_app,
            label: 'Exit',
            color: AppColors.textTertiary,
            onTap: onExit,
          ),

          // Separator
          Container(width: 1, height: 32, color: Colors.white12),

          // Journal with clue badge
          _DockItem(
            icon: Icons.menu_book,
            label: 'Journal',
            color: AppColors.primary,
            badge: clueCount > 0 ? clueCount : null,
            onTap: () {
              HapticService.lightTap();
              final gs = Provider.of<GameStateProvider>(context, listen: false);
              if (gs.isTutorialActive && gs.tutorialStep == 10) gs.endTutorial();
              Navigator.pushNamed(context, AppRoutes.detectiveJournal);
            },
          ),

          // Separator
          Container(width: 1, height: 32, color: Colors.white12),

          // Solve Case
          _DockItem(
            icon: Icons.gavel,
            label: 'Solve',
            color: suspectCount > 0 ? AppColors.success : AppColors.textTertiary,
            onTap: () {
              HapticService.mediumTap();
              if (suspectCount == 0 && clueCount < 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Explore the phone apps and collect more clues first.',
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                    backgroundColor: AppColors.surfaceDark,
                    duration: const Duration(seconds: 2),
                  ),
                );
                return;
              }
              Navigator.pushNamed(context, AppRoutes.detectiveJournal);
            },
          ),
        ],
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int? badge;

  const _DockItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null && badge! > 0)
            Positioned(
              right: 6,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.clue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.backgroundSecondary,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  badge! > 99 ? '99+' : '$badge',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Progressive Hints Dialog ────────────────────────────────────────────────

class _ProgressiveHintsDialog extends StatefulWidget {
  final List<String> hints;
  final int initialRevealed;
  final ValueChanged<int> onReveal;

  const _ProgressiveHintsDialog({
    required this.hints,
    required this.initialRevealed,
    required this.onReveal,
  });

  @override
  State<_ProgressiveHintsDialog> createState() => _ProgressiveHintsDialogState();
}

class _ProgressiveHintsDialogState extends State<_ProgressiveHintsDialog> {
  late int _revealed;

  @override
  void initState() {
    super.initState();
    // Show at least 1 hint on first open
    _revealed = widget.initialRevealed.clamp(1, widget.hints.length);
  }

  void _revealNext() {
    if (_revealed < widget.hints.length) {
      setState(() => _revealed++);
      widget.onReveal(_revealed);
      HapticService.lightTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMore = _revealed < widget.hints.length;

    return AlertDialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.amber, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Investigation Hints',
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            '$_revealed/${widget.hints.length}',
            style: GoogleFonts.robotoMono(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.hints.isEmpty
            ? Text(
                'No hints available for this case. Trust your instincts.',
                style: GoogleFonts.roboto(color: AppColors.textSecondary),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _revealed,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: GoogleFonts.robotoMono(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.hints[i],
                                style: GoogleFonts.roboto(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (hasMore) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _revealNext,
                        icon: const Icon(Icons.visibility, size: 16),
                        label: Text(
                          'Reveal Next Hint',
                          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.amber,
                          side: BorderSide(color: Colors.amber.withValues(alpha: 0.4)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: GoogleFonts.roboto(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
