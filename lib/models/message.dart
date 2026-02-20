// Phone Detective - Message Model

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final String? imageUrl;
  final bool isDeleted;
  final bool isRead;
  final bool isLocked;
  final String? password;
  final String? passwordHint;
  final bool isCorrupted;
  final String? corruptedContent;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.imageUrl,
    this.isDeleted = false,
    this.isRead = true,
    this.isLocked = false,
    this.password,
    this.passwordHint,
    this.isCorrupted = false,
    this.corruptedContent,
  });

  bool get isFromOwner => senderId == 'owner' || senderId == 'me';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'imageUrl': imageUrl,
      'isDeleted': isDeleted,
      'isRead': isRead,
      'isLocked': isLocked,
      'password': password,
      'passwordHint': passwordHint,
      'isCorrupted': isCorrupted,
      'corruptedContent': corruptedContent,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: (json['id'] as String?) ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: (json['conversationId'] as String?) ??
          (json['conversation_id'] as String?) ??
          '',
      senderId: (json['senderId'] as String?) ??
          (json['sender_id'] as String?) ??
          'unknown',
      content: (json['content'] as String?) ??
          (json['text'] as String?) ??
          '', // Handle 'text' fallback
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      isDeleted:
          json['isDeleted'] as bool? ?? json['is_deleted'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? json['is_read'] as bool? ?? true,
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

enum MessageType { text, image, link, deleted }

class Conversation {
  final String id;
  final String contactId;
  final List<Message> messages;

  const Conversation({
    required this.id,
    required this.contactId,
    required this.messages,
  });

  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;

  int get unreadCount =>
      messages.where((m) => !m.isRead && !m.isFromOwner).length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: (json['id'] as String?) ?? 'unknown',
      contactId: (json['contactId'] as String?) ?? '',
      messages: (json['messages'] as List?)
              ?.map((m) => Message.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
