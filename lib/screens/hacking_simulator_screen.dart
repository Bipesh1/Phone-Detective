// Phone Detective - Hacking Simulator Screen
// Displays a "hacking" animation sequence before entering the suspect's phone.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class HackingSimulatorScreen extends StatefulWidget {
  final String targetName; // e.g., "Ryan Miller's iPhone"

  const HackingSimulatorScreen({
    super.key,
    required this.targetName,
  });

  @override
  State<HackingSimulatorScreen> createState() => _HackingSimulatorScreenState();
}

class _HackingSimulatorScreenState extends State<HackingSimulatorScreen> {
  final List<String> _logLines = [];
  final ScrollController _scrollController = ScrollController();
  double _progress = 0.0;
  String _statusMessage = 'INITIALIZING...';
  bool _accessGranted = false;

  final List<String> _sequence = [
    'CONNECTING TO CLOUD...',
    'ESTABLISHING SECURE TUNNEL (PORT 443)...',
    'HANDSHAKE SUCCESSFUL.',
    'BYPASSING BIOMETRIC SECURITY...',
    'INJECTING PAYLOAD...',
    'DECRYPTING FILESYSTEM...',
    'MOUNTING VOLUMES...',
    'ACCESSING MESSAGES DB...',
    'ACCESSING CALL LOGS...',
    'ACCESSING PHOTO GALLERY...',
  ];

  @override
  void initState() {
    super.initState();
    _startHackingSequence();
  }

  Future<void> _startHackingSequence() async {
    // Initial delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate connection steps
    for (int i = 0; i < _sequence.length; i++) {
      if (!mounted) return;

      // Variable speed typing effect
      await Future.delayed(Duration(milliseconds: 150 + (i * 20)));

      _addLog('> ${_sequence[i]}');
      HapticService.lightTap();

      setState(() {
        _progress = (i + 1) / _sequence.length;
      });
    }

    // Final processing
    if (!mounted) return;
    _addLog('> TARGET: ${widget.targetName.toUpperCase()}');
    await Future.delayed(const Duration(milliseconds: 600));

    _addLog('> BYPASS COMPLETE.');
    setState(() {
      _statusMessage = 'ACCESS GRANTED';
      _accessGranted = true;
    });
    HapticService.heavyTap();

    // Flash success and navigate
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.phoneHome);
  }

  void _addLog(String line) {
    setState(() {
      _logLines.add(line);
    });
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.success),
                  color: AppColors.success.withValues(alpha: 0.1),
                ),
                child: Text(
                  'REMOTE_ACCESS_TOOL_V4.2',
                  style: GoogleFonts.robotoMono(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Terminal Output
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      left: BorderSide(
                        color: AppColors.success.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 16),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _logLines.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          _logLines[index],
                          style: GoogleFonts.firaCode(
                            color: AppColors.success,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Progress Bar
              if (!_accessGranted) ...[
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: GoogleFonts.robotoMono(
                    color: AppColors.success,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppColors.success.withValues(alpha: 0.2),
                  color: AppColors.success,
                  minHeight: 4,
                ),
              ],

              // Access Granted Block
              if (_accessGranted)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      _statusMessage,
                      style: GoogleFonts.robotoMono(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
