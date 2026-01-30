enum MessageSender { system, user }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.sender, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  bool get isSystem => sender == MessageSender.system;
  bool get isUser => sender == MessageSender.user;

  ChatMessage copyWith({
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
