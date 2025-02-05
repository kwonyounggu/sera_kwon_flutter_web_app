import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:drkwon/riverpod_providers/todo_list_provider.dart';

final Logger logger = Logger();

class TodoListScreen extends ConsumerStatefulWidget 
{
  const TodoListScreen({super.key});

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> 
{
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() 
  {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    // Watch the to-do list provider
    final todos = ref.watch(todoListProvider);
    logger.d('length of todos: ${todos.length}');
    return Scaffold
    (
      appBar: AppBar(title: const Text('To-Do List'),),
      body: Column
      (
        children: 
        [
          Padding
          (
            padding: const EdgeInsets.all(8.0),
            child: Row
            (
              children: 
              [
                Expanded
                (
                  child: TextField
                  (
                    controller: _controller,
                    decoration: const InputDecoration
                    (
                      labelText: 'Add a new task',
                    ),
                  ),
                ),
                IconButton
                (
                  icon: const Icon(Icons.add),
                  onPressed: () 
                  {
                    if (_controller.text.isNotEmpty) 
                    {
                      // Add a new to-do
                      ref.read(todoListProvider.notifier).addTodo(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded
          (
            child: ListView.builder
            (
              itemCount: todos.length,
              itemBuilder: (context, index) 
              {
                final todo = todos[index];
                return ListTile
                (
                  title: Text(todo.description),
                  leading: Checkbox
                  (
                    value: todo.completed,
                    onChanged: (value) 
                    {
                      // Toggle the completed status
                      ref.read(todoListProvider.notifier).toggleTodo(todo.id);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () 
                    {
                      // Remove the to-do
                      ref.read(todoListProvider.notifier).removeTodo(todo.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}