// Phone Detective - Contact Card Widget

import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../utils/constants.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final bool isSuspect;
  final String? subtitle;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onTap,
    this.isSuspect = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: contact.avatarColor,
            child: Text(
              contact.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isSuspect)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: const Icon(
                  Icons.priority_high,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        contact.fullName,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : contact.phoneNumber != null
          ? Text(
              contact.phoneNumber!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
    );
  }
}

class ContactAvatar extends StatelessWidget {
  final Contact contact;
  final double radius;
  final bool showSuspectBadge;

  const ContactAvatar({
    super.key,
    required this.contact,
    this.radius = 24,
    this.showSuspectBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: contact.avatarColor,
          child: Text(
            contact.initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: radius * 0.75,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (showSuspectBadge)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: Icon(
                Icons.priority_high,
                color: Colors.white,
                size: radius * 0.4,
              ),
            ),
          ),
      ],
    );
  }
}
