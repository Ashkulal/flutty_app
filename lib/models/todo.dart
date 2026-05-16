import 'package:flutter/material.dart';

enum TodoPriority { low, medium, high }

class Todo {
  final String id;
  final String name;
  final bool isCompleted;
  final String category;
  final TodoPriority priority;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.category = 'General',
    this.priority = TodoPriority.medium,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      isCompleted: json['is_completed'] ?? false,
      category: json['category'] ?? 'General',
      priority: _parsePriority(json['priority']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'is_completed': isCompleted,
      'category': category,
      'priority': priority.name,
    };
  }

  static TodoPriority _parsePriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return TodoPriority.high;
      case 'low':
        return TodoPriority.low;
      default:
        return TodoPriority.medium;
    }
  }

  Color get priorityColor {
    switch (priority) {
      case TodoPriority.high:
        return Colors.redAccent;
      case TodoPriority.medium:
        return Colors.orangeAccent;
      case TodoPriority.low:
        return Colors.blueAccent;
    }
  }

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.work_outlined;
      case 'personal':
        return Icons.person_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'health':
        return Icons.favorite_border;
      default:
        return Icons.list_alt;
    }
  }
}
