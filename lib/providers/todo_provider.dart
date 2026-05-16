import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Todo> _todos = [];
  bool _isLoading = true;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  TodoProvider() {
    _initStream();
  }

  void _initStream() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .listen((data) {
      _todos = data.map((json) => Todo.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint('Stream Error: $error');
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addTodo(String name, {String category = 'General', TodoPriority priority = TodoPriority.medium}) async {
    try {
      final user = _supabase.auth.currentUser;
      await _supabase.from('todos').insert({
        'name': name,
        'category': category,
        'priority': priority.name,
        'is_completed': false,
        'user_id': user?.id,
      });
    } catch (e) {
      debugPrint('Add Error: $e');
      rethrow;
    }
  }

  Future<void> toggleTodo(Todo todo) async {
    try {
      await _supabase
          .from('todos')
          .update({'is_completed': !todo.isCompleted})
          .match({'id': todo.id});
      notifyListeners(); // Fallback if stream is slow
    } catch (e) {
      debugPrint('Toggle Error: $e');
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _supabase.from('todos').delete().match({'id': id});
    } catch (e) {
      debugPrint('Delete Error: $e');
      rethrow;
    }
  }

  Future<void> updateTodo(String id, String newName, String newCategory, TodoPriority newPriority) async {
    try {
      await _supabase.from('todos').update({
        'name': newName,
        'category': newCategory,
        'priority': newPriority.name,
      }).match({'id': id});
      notifyListeners(); // Fallback if stream is slow
    } catch (e) {
      debugPrint('Update Error: $e');
      rethrow;
    }
  }
}
