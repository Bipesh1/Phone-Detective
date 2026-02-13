import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class VoicemailPlayer extends StatefulWidget {
  final String transcription;
  final Duration duration;

  const VoicemailPlayer({
    super.key,
    required this.transcription,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<VoicemailPlayer> createState() => _VoicemailPlayerState();
}

class _VoicemailPlayerState extends State<VoicemailPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;
  bool _isCompleted = false;
  String _displayedText = '';
  Timer? _textTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isPlaying = false;
          _isCompleted = true;
          _displayedText = widget.transcription; // Ensure full text is shown
        });
        _textTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    HapticService.lightTap();
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      if (_isCompleted) {
        // Replay
        _controller.reset();
        _isCompleted = false;
        _displayedText = '';
        _startTypewriter();
      } else if (_controller.value == 0) {
        _startTypewriter();
      }
      _controller.forward();
    } else {
      _controller.stop();
      _textTimer?.cancel();
    }
  }

  void _startTypewriter() {
    _textTimer?.cancel();
    // Calculate character delay based on duration and text length
    // final totalChars = widget.transcription.length;
    // final stepDuration = widget.duration.inMilliseconds ~/ (totalChars + 1);

    // We sync text reveal with the controller essentially
    // But to be safe, let's just use a periodic timer that checks controller value
    _textTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isPlaying && !_isCompleted) return;

      final progress = _controller.value;
      final charCount = (widget.transcription.length * progress).round();

      setState(() {
        _displayedText = widget.transcription.substring(0, charCount);
      });

      if (progress >= 1.0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _togglePlay,
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: AppColors.primary,
                  size: 48,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voicemail',
                      style: GoogleFonts.roboto(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _controller.value,
                      backgroundColor: AppColors.surfaceLight,
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatDuration(widget.duration * (1 - _controller.value)),
                style: GoogleFonts.robotoMono(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (_displayedText.isNotEmpty || _isCompleted) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _displayedText,
                style: GoogleFonts.robotoMono(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(1, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
