import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/step_hint.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';
import 'step_hint_button.dart';

class PasswordUnlockWidget extends StatefulWidget {
  final String correctPassword;
  final String? hint;
  final VoidCallback onUnlock;
  final StepHint? stepHint;

  const PasswordUnlockWidget({
    super.key,
    required this.correctPassword,
    this.hint,
    required this.onUnlock,
    this.stepHint,
  });

  @override
  State<PasswordUnlockWidget> createState() => _PasswordUnlockWidgetState();
}

class _PasswordUnlockWidgetState extends State<PasswordUnlockWidget>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late AnimationController _successController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _successAnimation;
  bool _isError = false;
  bool _isUnlocked = false;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reset();
        }
      });

    // Pulsing glow for locked icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Success animation
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _checkPassword() {
    if (_isUnlocked) return;

    setState(() => _attempts++);

    if (_controller.text.trim().toLowerCase() ==
        widget.correctPassword.toLowerCase()) {
      HapticService.heavyTap();
      setState(() => _isUnlocked = true);
      _pulseController.stop();
      _successController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) widget.onUnlock();
        });
      });
    } else {
      HapticService.lightTap();
      setState(() {
        _isError = true;
      });
      _shakeController.forward();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect password (Attempt $_attempts)'),
          backgroundColor: AppColors.danger,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnlocked) {
      return ScaleTransition(
        scale: _successAnimation,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_open, size: 56, color: AppColors.success),
              const SizedBox(height: 16),
              Text(
                'ACCESS GRANTED',
                style: GoogleFonts.robotoMono(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Decrypting content...',
                style: GoogleFonts.roboto(
                  color: AppColors.success.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shakeOffset =
            sin(_shakeAnimation.value * pi * 3) * (_isError ? 8 : 0);
        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isError
                    ? AppColors.danger.withValues(alpha: 0.5)
                    : AppColors.primary
                        .withValues(alpha: _pulseAnimation.value * 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isError ? AppColors.danger : AppColors.primary)
                      .withValues(alpha: _pulseAnimation.value * 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, _) {
                return Icon(
                  Icons.lock,
                  size: 48,
                  color: _isError
                      ? AppColors.danger
                      : AppColors.primary
                          .withValues(alpha: 0.5 + _pulseAnimation.value * 0.5),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'ENCRYPTED CONTENT',
              style: GoogleFonts.robotoMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Password required to decrypt',
              style: GoogleFonts.roboto(
                color: AppColors.textTertiary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.hint != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: AppColors.clue, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.hint!,
                        style: GoogleFonts.roboto(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.hint != null)
              _buildSmartHintButton(context, widget.hint!),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: GoogleFonts.robotoMono(color: AppColors.textPrimary),
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                hintText: 'Enter Password',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                prefixIcon: Icon(Icons.key,
                    color: AppColors.textTertiary.withValues(alpha: 0.5),
                    size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: (_) => _checkPassword(),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _checkPassword,
                icon: const Icon(Icons.lock_open, size: 18),
                label: Text(
                  _attempts > 0 ? 'RETRY (ATTEMPT ${_attempts + 1})' : 'UNLOCK',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            // Step hints (progressive reveal)
            if (widget.stepHint != null) ...[
              const SizedBox(height: 16),
              StepHintButton(stepHint: widget.stepHint!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSmartHintButton(BuildContext context, String hint) {
    final lower = hint.toLowerCase();
    String? route;
    String label = '';
    IconData? icon;

    if (lower.contains('photo') ||
        lower.contains('image') ||
        lower.contains('gallery') ||
        lower.contains('screenshot')) {
      route = AppRoutes.gallery;
      label = 'View Photos';
      icon = Icons.photo_library;
    } else if (lower.contains('call') ||
        lower.contains('voicemail') ||
        lower.contains('phone')) {
      route = AppRoutes.callLog;
      label = 'View Calls';
      icon = Icons.phone_callback;
    } else if (lower.contains('email') || lower.contains('inbox')) {
      route = AppRoutes.email;
      label = 'View Emails';
      icon = Icons.email;
    } else if (lower.contains('conversation') ||
        lower.contains('message') ||
        lower.contains('chat') ||
        lower.contains('text')) {
      route = AppRoutes.messages;
      label = 'View Messages';
      icon = Icons.chat_bubble;
    } else if (lower.contains('birthday') ||
        lower.contains('birth') ||
        lower.contains('contact') ||
        lower.contains('origin') ||
        lower.contains('date')) {
      route = AppRoutes.contacts;
      label = 'View Contacts';
      icon = Icons.perm_contact_calendar;
    } else if (lower.contains('note') || lower.contains('meeting')) {
      route = AppRoutes.notes;
      label = 'View Notes';
      icon = Icons.note;
    }

    if (route == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton.icon(
        onPressed: () {
          HapticService.lightTap();
          Navigator.pushNamed(context, route!);
        },
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
