// message_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MessageType { info, warning, critical }

class SiteMessage 
{
  final String id;
  final MessageType type;
  final String content;
  final DateTime expiresAt;

  SiteMessage
  (
    {
      required this.id,
      required this.type,
      required this.content,
      required this.expiresAt,
    }
  );
}

// Add to providers file
final messageProvider = StateNotifierProvider<MessageNotifier, List<SiteMessage>>
(
  (ref) => MessageNotifier(),
);

class MessageNotifier extends StateNotifier<List<SiteMessage>> 
{
  MessageNotifier() : super([]);

  void addMessage(SiteMessage message) 
  {
    state = [...state, message];
  }

  void removeMessage(String id) 
  {
    state = state.where((msg) => msg.id != id).toList();
  }

  void clearExpired() 
  {
    state = state.where((msg) => msg.expiresAt.isAfter(DateTime.now())).toList();
  }
}