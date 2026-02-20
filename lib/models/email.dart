// Phone Detective - Email Model

class Email {
  final String id;
  final String senderId;
  final String senderEmail;
  final String senderName;
  final String subject;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final bool isStarred;
  final EmailFolder folder;
  final List<EmailAttachment> attachments;
  final bool isLocked;
  final String? password;
  final String? passwordHint;
  final bool isCorrupted;
  final String? corruptedContent;

  const Email({
    required this.id,
    required this.senderId,
    required this.senderEmail,
    required this.senderName,
    required this.subject,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.isStarred = false,
    this.folder = EmailFolder.inbox,
    this.attachments = const [],
    this.isLocked = false,
    this.password,
    this.passwordHint,
    this.isCorrupted = false,
    this.corruptedContent,
  });

  String get preview {
    final cleanBody = body.replaceAll('\n', ' ').trim();
    if (cleanBody.length <= 80) return cleanBody;
    return '${cleanBody.substring(0, 80)}...';
  }

  String get displayDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final emailDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (emailDate == today) {
      final hour = timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    }

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[timestamp.month - 1]} ${timestamp.day}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'senderName': senderName,
      'subject': subject,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isStarred': isStarred,
      'folder': folder.name,
      'attachments': attachments.map((a) => a.toJson()).toList(),
      'isLocked': isLocked,
      'password': password,
      'passwordHint': passwordHint,
      'isCorrupted': isCorrupted,
      'corruptedContent': corruptedContent,
    };
  }

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      id: (json['id'] as String?) ?? 'unknown',
      senderId:
          (json['senderId'] as String?) ?? (json['sender_id'] as String?) ?? '',
      senderEmail: (json['senderEmail'] as String?) ??
          (json['sender_email'] as String?) ??
          '',
      senderName: (json['senderName'] as String?) ??
          (json['sender_name'] as String?) ??
          'Unknown',
      subject: (json['subject'] as String?) ?? '(No Subject)',
      body: (json['body'] as String?) ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      isRead: json['isRead'] as bool? ?? json['is_read'] as bool? ?? false,
      isStarred:
          json['isStarred'] as bool? ?? json['is_starred'] as bool? ?? false,
      folder: EmailFolder.values.firstWhere(
        (e) => e.name == json['folder'],
        orElse: () => EmailFolder.inbox,
      ),
      attachments: (json['attachments'] as List?)
              ?.map((a) => EmailAttachment.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      isLocked:
          json['isLocked'] as bool? ?? json['is_locked'] as bool? ?? false,
      password: json['password'] as String?,
      passwordHint:
          json['passwordHint'] as String? ?? json['password_hint'] as String?,
      isCorrupted: json['isCorrupted'] as bool? ??
          json['is_corrupted'] as bool? ??
          false,
      corruptedContent: json['corruptedContent'] as String? ??
          json['corrupted_content'] as String?,
    );
  }
}

enum EmailFolder { inbox, sent, trash, drafts }

class EmailAttachment {
  final String id;
  final String name;
  final String type; // pdf, image, etc.
  final int sizeBytes;

  const EmailAttachment({
    required this.id,
    required this.name,
    required this.type,
    required this.sizeBytes,
  });

  String get displaySize {
    if (sizeBytes < 1024) {
      return '${sizeBytes}B';
    }
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)}KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'type': type, 'sizeBytes': sizeBytes};
  }

  factory EmailAttachment.fromJson(Map<String, dynamic> json) {
    return EmailAttachment(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      sizeBytes: json['sizeBytes'] as int,
    );
  }
}
