enum MessageSender { system, user }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<String>? suggestions;

  ChatMessage({
    required this.text,
    required this.sender,
    DateTime? timestamp,
    this.suggestions,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isSystem => sender == MessageSender.system;
  bool get isUser => sender == MessageSender.user;
  bool get hasSuggestions => suggestions != null && suggestions!.isNotEmpty;

  ChatMessage copyWith({
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    List<String>? suggestions,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
