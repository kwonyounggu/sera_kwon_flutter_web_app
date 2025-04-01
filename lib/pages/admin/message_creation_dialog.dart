
import 'package:drkwon/pages/admin/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageCreationDialog extends ConsumerWidget 
{
  const MessageCreationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final TextEditingController controller = TextEditingController();
    MessageType selectedType = MessageType.info;

    return AlertDialog
    (
      title: const Text('New Site Announcement'),
      content: Column
      (
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<MessageType>(
            value: selectedType,
            items: MessageType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) => selectedType = value!,
          ),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Message'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(messageProvider.notifier).addMessage(
              SiteMessage(
                id: DateTime.now().toString(),
                type: selectedType,
                content: controller.text,
                expiresAt: DateTime.now().add(const Duration(days: 1)),
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('Post'),
        ),
      ],
    );
  }
}