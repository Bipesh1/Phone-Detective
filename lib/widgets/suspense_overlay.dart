// Phone Detective - Suspense Event Overlay Widget

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/suspense_event.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class SuspenseOverlay extends StatefulWidget {
  final SuspenseEvent event;
  final VoidCallback onDismiss;

  const SuspenseOverlay({
    super.key,
    required this.event,
    required this.onDismiss,
  });

  @override
  State<SuspenseOverlay> createState() => _SuspenseOverlayState();
}

class _SuspenseOverlayState extends State<SuspenseOverlay>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _typewriterController;
  String _displayedMessage = '';
  bool _showDismiss = false;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _typewriterController = AnimationController(
      duration: Duration(
        milliseconds: widget.event.message.length * 30 + 500,
      ),
      vsync: this,
    );

    HapticService.heavyTap();
    _fadeController.forward();

    // Start typewriter after fade in
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _startTypewriter();
    });
  }

  void _startTypewriter() {
    final message = widget.event.message;
    _typewriterController.addListener(() {
      if (!mounted) return;
      final charCount = (_typewriterController.value * message.length).round();
      setState(() {
        _displayedMessage = message.substring(0, charCount);
      });
    });

    _typewriterController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _showDismiss = true);
        HapticService.lightTap();
        // Auto-dismiss after 5 seconds
        _autoDismissTimer = Timer(const Duration(seconds: 5), () {
          if (mounted) _dismiss();
        });
      }
    });

    _typewriterController.forward();
  }

  void _dismiss() {
    _autoDismissTimer?.cancel();
    _fadeController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _fadeController.dispose();
    _pulseController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  IconData _getIconData() {
    switch (widget.event.iconName) {
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'phone':
        return Icons.phone_callback;
      case 'message':
        return Icons.sms;
      case 'eye':
        return Icons.visibility;
      case 'lock':
        return Icons.lock;
      case 'alert':
        return Icons.crisis_alert;
      case 'person':
        return Icons.person_off;
      case 'location':
        return Icons.location_on;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  Color _getEventColor() {
    switch (widget.event.type) {
      case SuspenseType.warning:
        return const Color(0xFFFF3B30);
      case SuspenseType.glitch:
        return const Color(0xFF00FF41);
      case SuspenseType.incoming:
        return const Color(0xFF007AFF);
      case SuspenseType.notification:
        return const Color(0xFFFF9500);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventColor = _getEventColor();

    return FadeTransition(
      opacity: _fadeController,
      child: GestureDetector(
        onTap: _showDismiss ? _dismiss : null,
        child: Container(
          color: Colors.black.withValues(alpha: 0.85),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pulsing icon
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = 1.0 + (_pulseController.value * 0.15);
                        final opacity = 0.5 + (_pulseController.value * 0.5);
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: eventColor.withValues(alpha: 0.15),
                              boxShadow: [
                                BoxShadow(
                                  color: eventColor.withValues(
                                      alpha: opacity * 0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              _getIconData(),
                              color: eventColor,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      widget.event.title,
                      style: GoogleFonts.robotoMono(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: eventColor,
                        letterSpacing: 3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Typewriter message
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: eventColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        _displayedMessage.isEmpty ? ' ' : _displayedMessage,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          height: 1.7,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Dismiss button
                    AnimatedOpacity(
                      opacity: _showDismiss ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        'TAP TO DISMISS',
                        style: GoogleFonts.robotoMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
