import 'dart:convert';

import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/enums/habit_frequency.dart';

/// Alışkanlık veri modeli — SQLite ile uyumlu serileştirme
///
/// Domain katmanındaki [Habit] entity'sinin veri katmanı karşılığıdır.
/// SQLite `Map<String, dynamic>` formatına dönüşüm sağlar.
/// Factory constructor'lar ile Entity - Model dönüşümü yapılır.
class HabitModel {
  /// Tüm alanlarla model oluşturur
  const HabitModel({
    this.id,
    required this.name,
    this.description,
    this.icon = '✅',
    this.color = 0xFF4CAF50,
    this.frequency = 'daily',
    this.targetDays,
    this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = 0,
  });

  /// SQLite Map'ten model oluşturur
  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      icon: (map['icon'] as String?) ?? '✅',
      color: (map['color'] as int?) ?? 0xFF4CAF50,
      frequency: (map['frequency'] as String?) ?? 'daily',
      targetDays: map['target_days'] as String?,
      reminderTime: map['reminder_time'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      isArchived: (map['is_archived'] as int?) ?? 0,
    );
  }

  /// Domain entity'den model oluşturur
  factory HabitModel.fromEntity(Habit entity) {
    return HabitModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      icon: entity.icon,
      color: entity.color,
      frequency: entity.frequency.name,
      targetDays: entity.targetDays != null
          ? jsonEncode(entity.targetDays)
          : null,
      reminderTime: entity.reminderTime,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      isArchived: entity.isArchived ? 1 : 0,
    );
  }

  final int? id;
  final String name;
  final String? description;
  final String icon;
  final int color;
  final String frequency;
  final String? targetDays;
  final String? reminderTime;
  final String createdAt;
  final String updatedAt;
  final int isArchived;

  /// SQLite Map'e dönüştürür (INSERT/UPDATE için)
  ///
  /// [id] dahil edilmez — AUTOINCREMENT tarafından atanır.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'frequency': frequency,
      'target_days': targetDays,
      'reminder_time': reminderTime,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_archived': isArchived,
    };
  }

  /// Domain entity'ye dönüştürür
  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      description: description,
      icon: icon,
      color: color,
      frequency: HabitFrequency.fromString(frequency),
      targetDays: _parseTargetDays(targetDays),
      reminderTime: reminderTime,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      isArchived: isArchived == 1,
    );
  }

  /// JSON string'den hedef gün listesine dönüştürür
  ///
  /// Örn: "[1,2,3,4,5]" → [1, 2, 3, 4, 5]
  static List<int>? _parseTargetDays(String? json) {
    if (json == null || json.isEmpty) return null;

    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded.cast<int>();
  }
}
