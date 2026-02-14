import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../services/haptic_service.dart';

class PasswordUnlockWidget extends StatefulWidget {
  final String correctPassword;
  final String? hint;
  final VoidCallback onUnlock;

  const PasswordUnlockWidget({
    super.key,
    required this.correctPassword,
    this.hint,
    required this.onUnlock,
  });

  @override
  State<PasswordUnlockWidget> createState() => _PasswordUnlockWidgetState();
}

class _PasswordUnlockWidgetState extends State<PasswordUnlockWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _isError = false;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _checkPassword() {
    if (_controller.text.trim().toLowerCase() ==
        widget.correctPassword.toLowerCase()) {
      HapticService.heavyTap();
      widget.onUnlock();
    } else {
      HapticService.lightTap();
      setState(() {
        _isError = true;
      });
      _shakeController.forward();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect password'),
          backgroundColor: AppColors.danger,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value * (_isError ? 1 : 0),
              0), // Use sine wave for shake in real impl, simplified here
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Content Locked',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.hint != null)
              Text(
                'Hint: ${widget.hint}',
                style: GoogleFonts.roboto(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (widget.hint != null)
              _buildSmartHintButton(context, widget.hint!),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              style: GoogleFonts.robotoMono(color: AppColors.textPrimary),
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                hintText: 'Enter Password',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: (_) => _checkPassword(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Unlock',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
    } else if (lower.contains('birthday') ||
        lower.contains('birth') ||
        lower.contains('contact') ||
        lower.contains('date')) {
      route = AppRoutes.contacts;
      label = 'View Contacts';
      icon = Icons.perm_contact_calendar;
    }

    if (route == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
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
