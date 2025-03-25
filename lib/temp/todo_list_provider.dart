import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
// Define a model for a to-do item
class Todo 
{
  final String id;
  final String description;
  bool completed;

  Todo
  (
    {
    required this.id,
    required this.description,
    this.completed = false,
    }
  );
}

// Define a StateNotifier to manage the list of to-dos
class TodoListNotifier extends StateNotifier<List<Todo>> 
{
  TodoListNotifier() : super([]);

  // Add a new to-do
  void addTodo(String description) 
  {
    state = 
    [
      ...state,
      Todo
      (
        id: DateTime.now().toString(),
        description: description,
      ),
    ];
  }

  // Toggle the completed status of a to-do
  void toggleTodo(String id) 
  {
    state = state.map
    (
      (todo) 
      {
        logger.d('inside of state.map, todo.id = ${todo.id}');
        if (todo.id == id) 
        {
          return Todo
          (
            id: todo.id,
            description: todo.description,
            completed: !todo.completed,
          );
        }
        return todo;
      }
    ).toList();
  }

  // Remove a to-do
  void removeTodo(String id) 
  {
    state = state.where((todo) => todo.id != id).toList();
  }
}

// Create a provider for the to-do list
final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>
(
  (ref) 
  {
    return TodoListNotifier();
  }
);