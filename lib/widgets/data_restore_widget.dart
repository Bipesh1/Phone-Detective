import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class DataRestoreWidget extends StatefulWidget {
  final String? corruptedContent;
  final VoidCallback onRestore;

  const DataRestoreWidget({
    super.key,
    this.corruptedContent,
    required this.onRestore,
  });

  @override
  State<DataRestoreWidget> createState() => _DataRestoreWidgetState();
}

class _DataRestoreWidgetState extends State<DataRestoreWidget> {
  bool _isRestoring = false;
  double _progress = 0.0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _mockRestore() {
    HapticService.lightTap();
    setState(() {
      _isRestoring = true;
      _progress = 0.0;
    });

    // Simulate 3 seconds progress
    const totalSteps = 60;
    const duration = Duration(milliseconds: 50);
    int step = 0;

    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        step++;
        _progress = step / totalSteps;
      });

      if (step % 5 == 0) {
        HapticService.lightTap(); // Tick feedback
      }

      if (step >= totalSteps) {
        timer.cancel();
        HapticService.heavyTap();
        widget.onRestore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isRestoring) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.system_security_update_good,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'RESTORING DATA...',
              style: GoogleFonts.robotoMono(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: AppColors.surfaceLight,
              color: AppColors.primary,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Text(
              '${(_progress * 100).toInt()}%',
              style: GoogleFonts.robotoMono(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.danger),
              const SizedBox(width: 12),
              Text(
                'DATA CORRUPTED',
                style: GoogleFonts.robotoMono(
                  color: AppColors.danger,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.corruptedContent != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              child: Text(
                widget.corruptedContent!,
                style: GoogleFonts.vt323(
                  color: AppColors.danger,
                  fontSize: 18,
                ),
              ),
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _mockRestore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger.withValues(alpha: 0.2),
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'ATTEMPT RESTORE',
              style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
