// Phone Detective - Journal Entry Widget

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class JournalEntry extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final String icon;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  const JournalEntry({
    super.key,
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  // Time
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Line and dot
            SizedBox(
              width: 30,
              child: Column(
                children: [
                  // Line above
                  if (!isFirst)
                    Container(
                      width: 2,
                      height: 8,
                      color: AppColors.surfaceLight,
                    ),
                  // Dot
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 3,
                      ),
                    ),
                  ),
                  // Line below
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: AppColors.surfaceLight),
                    ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (onTap != null)
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textTertiary,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
