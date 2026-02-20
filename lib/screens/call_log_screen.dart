// Phone Detective - Call Log Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/call_record.dart';
import '../models/clue.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import '../widgets/clue_hint_banner.dart';
import '../widgets/voicemail_player.dart';

class CallLogScreen extends StatelessWidget {
  const CallLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final calls = gameState.currentCase.callLog;

    // Group by date
    final groupedCalls = <String, List<CallRecord>>{};
    for (final call in calls) {
      final key = call.displayDate;
      groupedCalls.putIfAbsent(key, () => []).add(call);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recents',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: calls.isEmpty
          ? _EmptyState()
          : Column(
              children: [
                ClueHintBanner(clueCount: gameState.currentClues.length),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: groupedCalls.length,
                    itemBuilder: (context, index) {
                      final date = groupedCalls.keys.elementAt(index);
                      final dateCalls = groupedCalls[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Text(
                              date,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          ...dateCalls.map(
                            (call) =>
                                _CallTile(call: call, gameState: gameState),
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
          Icon(Icons.phone_missed, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'No recent calls',
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

class _CallTile extends StatelessWidget {
  final CallRecord call;
  final GameStateProvider gameState;

  const _CallTile({required this.call, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final contact = gameState.currentCase.getContact(call.contactId);
    final isClue = gameState.isClueMarked(call.id);

    return GestureDetector(
      onLongPress: () => _showClueDialog(context, call, isClue),
      child: ListTile(
        onTap: () {
          HapticService.lightTap();
          // Voicemail entries open the detail sheet directly
          if (call.type == CallType.voicemail || call.transcription != null) {
            _showClueDialog(context, call, isClue);
          } else if (contact != null) {
            Navigator.pushNamed(
              context,
              AppRoutes.contactDetail,
              arguments: {'contactId': call.contactId},
            );
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Color(call.type.colorValue).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(call.type.icon, style: const TextStyle(fontSize: 18)),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                contact?.fullName ?? call.phoneNumber,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: call.type == CallType.missed
                      ? AppColors.danger
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (isClue)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.bookmark, color: AppColors.clue, size: 16),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  call.type.name.toUpperCase(),
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Color(call.type.colorValue),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (call.displayDuration.isNotEmpty) ...[
                  Text(
                    ' • ${call.displayDuration}',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
            // Voicemail tag
            if (call.type == CallType.voicemail || call.transcription != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5856D6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF5856D6).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.mic, size: 12, color: const Color(0xFF5856D6)),
                      const SizedBox(width: 4),
                      Text(
                        'Voicemail • Tap to play',
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF5856D6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (call.note != null && call.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  call.note!,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        trailing: Text(
          call.displayTime,
          style: GoogleFonts.roboto(
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  void _showClueDialog(BuildContext context, CallRecord call, bool isClue) {
    final contact = gameState.currentCase.getContact(call.contactId);
    HapticService.mediumTap();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${call.type.name.toUpperCase()} call ${call.type == CallType.outgoing ? 'to' : 'from'}',
                style: GoogleFonts.roboto(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                contact?.fullName ?? call.phoneNumber,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${call.displayTime} • ${call.displayDuration.isNotEmpty ? call.displayDuration : 'No answer'}',
                style: GoogleFonts.roboto(color: AppColors.textTertiary),
              ),
              if (call.transcription != null) ...[
                const SizedBox(height: 24),
                VoicemailPlayer(
                  transcription: call.transcription!,
                  duration: call.duration,
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isClue) {
                      gameState.removeClue(call.id);
                    } else {
                      final clue = Clue(
                        id: call.id,
                        type: ClueType.call,
                        sourceId: call.id,
                        preview:
                            '${call.type.name} call - ${contact?.fullName ?? call.phoneNumber}${call.transcription != null ? ' (Voicemail)' : ''}',
                        foundAt: DateTime.now(),
                      );
                      gameState.addClue(clue);
                      HapticService.heavyTap();
                    }
                    Navigator.pop(context);
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
