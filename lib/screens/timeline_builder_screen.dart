// Phone Detective - Evidence Timeline Builder Screen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/timeline_event.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class TimelineBuilderScreen extends StatefulWidget {
  const TimelineBuilderScreen({super.key});

  @override
  State<TimelineBuilderScreen> createState() => _TimelineBuilderScreenState();
}

class _TimelineBuilderScreenState extends State<TimelineBuilderScreen>
    with SingleTickerProviderStateMixin {
  late List<TimelineEvent> _playerOrder;
  bool _isChecking = false;
  bool? _isCorrect;
  late AnimationController _resultController;
  Set<int> _correctPositions = {};

  @override
  void initState() {
    super.initState();
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    final events = [...gameState.currentCase.evidenceTimeline];
    events.shuffle();
    _playerOrder = events;
  }

  @override
  void dispose() {
    _resultController.dispose();
    super.dispose();
  }

  void _checkOrder() async {
    setState(() => _isChecking = true);
    HapticService.mediumTap();

    // Capture before async gap
    final gameState = Provider.of<GameStateProvider>(context, listen: false);

    await Future.delayed(const Duration(milliseconds: 800));

    final correct = <int>{};
    bool allCorrect = true;
    for (int i = 0; i < _playerOrder.length; i++) {
      if (_playerOrder[i].correctOrder == i + 1) {
        correct.add(i);
      } else {
        allCorrect = false;
      }
    }

    setState(() {
      _correctPositions = correct;
      _isCorrect = allCorrect;
      _isChecking = false;
    });

    if (allCorrect) {
      HapticService.heavyTap();
      _resultController.forward();
      gameState.completeTimeline();
    } else {
      HapticService.lightTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final themeColor = gameState.currentCase.themeColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSecondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Evidence Timeline',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Instructions header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.08),
              border: Border(
                bottom: BorderSide(
                  color: themeColor.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.timeline, color: themeColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'RECONSTRUCT THE EVENTS',
                      style: GoogleFonts.robotoMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: themeColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Drag and reorder events into the correct chronological order.',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Timeline items
          Expanded(
            child: _playerOrder.isEmpty
                ? Center(
                    child: Text(
                      'No timeline events for this case.',
                      style: GoogleFonts.roboto(color: AppColors.textSecondary),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _playerOrder.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = _playerOrder.removeAt(oldIndex);
                        _playerOrder.insert(newIndex, item);
                        _isCorrect = null;
                        _correctPositions = {};
                      });
                    },
                    itemBuilder: (context, index) {
                      final event = _playerOrder[index];
                      final isCorrectPos = _correctPositions.contains(index);
                      final isWrongPos = _isCorrect == false &&
                          !_correctPositions.contains(index) &&
                          _correctPositions.isNotEmpty;

                      return _TimelineCard(
                        key: ValueKey(event.id),
                        event: event,
                        index: index,
                        isCorrect: isCorrectPos,
                        isWrong: isWrongPos,
                        themeColor: themeColor,
                      );
                    },
                  ),
          ),
          // Check button
          Container(
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
            child: Column(
              children: [
                if (_isCorrect == true)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Timeline reconstructed correctly!',
                          style: GoogleFonts.poppins(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_isCorrect == false)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      '${_correctPositions.length}/${_playerOrder.length} events in correct position. Keep trying!',
                      style: GoogleFonts.roboto(
                        color: AppColors.warning,
                        fontSize: 13,
                      ),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_isChecking || _isCorrect == true)
                        ? null
                        : _checkOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isCorrect == true ? AppColors.success : themeColor,
                      disabledBackgroundColor: AppColors.surfaceDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isChecking
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isCorrect == true
                                ? '✓ COMPLETE'
                                : 'VERIFY TIMELINE',
                            style: GoogleFonts.robotoMono(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
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

class _TimelineCard extends StatelessWidget {
  final TimelineEvent event;
  final int index;
  final bool isCorrect;
  final bool isWrong;
  final Color themeColor;

  const _TimelineCard({
    super.key,
    required this.event,
    required this.index,
    required this.isCorrect,
    required this.isWrong,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isCorrect
        ? AppColors.success
        : isWrong
            ? AppColors.danger
            : Colors.transparent;
    final bgColor = isCorrect
        ? AppColors.success.withValues(alpha: 0.08)
        : isWrong
            ? AppColors.danger.withValues(alpha: 0.08)
            : AppColors.backgroundSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isCorrect || isWrong ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          // Position number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCorrect
                  ? AppColors.success.withValues(alpha: 0.2)
                  : themeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: isCorrect
                  ? const Icon(Icons.check, color: AppColors.success, size: 18)
                  : Text(
                      '${index + 1}',
                      style: GoogleFonts.robotoMono(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: themeColor,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          // Event text
          Expanded(
            child: Text(
              event.eventText,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Drag handle
          Icon(Icons.drag_handle, color: AppColors.textTertiary, size: 20),
        ],
      ),
    );
  }
}
