// Phone Detective - App Icon Widget

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class AppIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;
  final int? badgeCount;
  final bool isLocked;

  const AppIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onTap,
    this.badgeCount,
    this.isLocked = false,
  });

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.buttonTap,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticService.lightTap();
    _controller.forward().then((_) {
      _controller.reverse();
    });

    Future.delayed(AppDurations.buttonTap, () {
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // App icon container
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.backgroundColor,
                        HSLColor.fromColor(widget.backgroundColor)
                            .withLightness(
                              (HSLColor.fromColor(
                                        widget.backgroundColor,
                                      ).lightness -
                                      0.15)
                                  .clamp(0.0, 1.0),
                            )
                            .toColor(),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: widget.backgroundColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: widget.isLocked
                      ? const Icon(Icons.lock, color: Colors.white54, size: 28)
                      : Icon(widget.icon, color: Colors.white, size: 28),
                ),
                // Badge
                if (widget.badgeCount != null && widget.badgeCount! > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        widget.badgeCount! > 99
                            ? '99+'
                            : widget.badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.isLocked
                    ? AppColors.textTertiary
                    : AppColors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
