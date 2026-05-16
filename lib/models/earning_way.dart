class EarningWay {
  final String id;
  final String title;
  final String description;
  final String category;
  final double estimatedEarning;
  final String difficulty;
  final int timeRequired;
  final String requirements;
  final bool isActive;
  final DateTime createdAt;

  EarningWay({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.estimatedEarning,
    required this.difficulty,
    required this.timeRequired,
    required this.requirements,
    required this.isActive,
    required this.createdAt,
  });

  factory EarningWay.fromJson(Map<String, dynamic> json) {
    return EarningWay(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      estimatedEarning: (json['estimated_earning'] as num).toDouble(),
      difficulty: json['difficulty'] as String,
      timeRequired: json['time_required'] as int,
      requirements: json['requirements'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'estimated_earning': estimatedEarning,
    'difficulty': difficulty,
    'time_required': timeRequired,
    'requirements': requirements,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
  };
}
