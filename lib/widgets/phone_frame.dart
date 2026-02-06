// Phone Detective - Phone Frame Widget

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;
  final bool showStatusBar;
  final bool showHomeIndicator;

  const PhoneFrame({
    super.key,
    required this.child,
    this.showStatusBar = true,
    this.showHomeIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(PhoneFrameDimensions.bezelRadius),
        border: Border.all(color: AppColors.surfaceDark, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          PhoneFrameDimensions.bezelRadius - 3,
        ),
        child: Column(
          children: [
            if (showStatusBar) const _StatusBar(),
            Expanded(child: child),
            if (showHomeIndicator) const _HomeIndicator(),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PhoneFrameDimensions.statusBarHeight,
      color: AppColors.background,
      child: Stack(
        children: [
          // Notch
          Center(
            child: Container(
              width: PhoneFrameDimensions.notchWidth,
              height: PhoneFrameDimensions.notchHeight,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          // Time
          Positioned(
            left: 20,
            top: 12,
            child: Text(
              _formatTime(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Status icons
          Positioned(
            right: 20,
            top: 12,
            child: Row(
              children: [
                const Icon(
                  Icons.signal_cellular_4_bar,
                  color: AppColors.textPrimary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.wifi, color: AppColors.textPrimary, size: 16),
                const SizedBox(width: 4),
                _BatteryIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime() {
    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _BatteryIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 10,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textPrimary, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.87,
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
          height: 4,
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

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PhoneFrameDimensions.homeIndicatorHeight,
      color: AppColors.background,
      child: Center(
        child: Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.textSecondary,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
      ),
    );
  }
}
