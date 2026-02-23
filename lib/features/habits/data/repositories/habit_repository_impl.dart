import 'package:streak_up/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:streak_up/features/habits/data/models/habit_model.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_with_stats.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';

/// [HabitRepository] arayüzünün SQLite implementasyonu
///
/// Veri kaynağı olarak [HabitLocalDatasource] kullanır.
/// Model ↔ Entity dönüşümlerini bu katman gerçekleştirir.
/// Domain katmanı bu sınıfı doğrudan bilmez — arayüz üzerinden erişir.
class HabitRepositoryImpl implements HabitRepository {
  /// [datasource] — Yerel SQLite veri kaynağı
  const HabitRepositoryImpl(this._datasource);

  final HabitLocalDatasource _datasource;

  // ==========================================================================
  // HABIT CRUD
  // ==========================================================================

  @override
  Future<List<Habit>> getAll() async {
    final models = await _datasource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Habit>> getActive() async {
    final models = await _datasource.getActive();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Habit> getById(int id) async {
    final model = await _datasource.getById(id);
    return model.toEntity();
  }

  @override
  Future<Habit> create(Habit habit) async {
    final model = HabitModel.fromEntity(habit);
    final created = await _datasource.insert(model);
    return created.toEntity();
  }

  @override
  Future<Habit> update(Habit habit) async {
    final model = HabitModel.fromEntity(habit);
    final updated = await _datasource.update(model);
    return updated.toEntity();
  }

  @override
  Future<void> delete(int id) => _datasource.delete(id);

  @override
  Future<void> archive(int id) => _datasource.archive(id);

  // ==========================================================================
  // COMPLETION İŞLEMLERİ
  // ==========================================================================

  @override
  Future<void> toggleCompletion(int habitId, DateTime date) {
    return _datasource.toggleCompletion(habitId, _toDateStr(date));
  }

  @override
  Future<bool> isCompleted(int habitId, DateTime date) {
    return _datasource.isCompleted(habitId, _toDateStr(date));
  }

  @override
  Future<List<DateTime>> getCompletedDates(
    int habitId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final dateStrings = await _datasource.getCompletedDates(
      habitId,
      from: from != null ? _toDateStr(from) : null,
      to: to != null ? _toDateStr(to) : null,
    );

    return dateStrings.map(DateTime.parse).toList();
  }

  // ==========================================================================
  // İSTATİSTİK İŞLEMLERİ
  // ==========================================================================

  @override
  Future<HabitWithStats> getHabitWithStats(int habitId) async {
    final model = await _datasource.getById(habitId);
    final habit = model.toEntity();

    return _buildHabitWithStats(habit, model.createdAt);
  }

  @override
  Future<List<HabitWithStats>> getAllWithStats() async {
    final models = await _datasource.getActive();
    final results = <HabitWithStats>[];

    for (final model in models) {
      final habit = model.toEntity();
      final stats = await _buildHabitWithStats(
        habit,
        model.createdAt,
      );
      results.add(stats);
    }

    return results;
  }

  // ==========================================================================
  // YARDIMCI METODLAR
  // ==========================================================================

  /// Alışkanlık + istatistikleri birleştirir
  Future<HabitWithStats> _buildHabitWithStats(
    Habit habit,
    String createdAtStr,
  ) async {
    final habitId = habit.id;
    if (habitId == null) {
      throw StateError('Habit ID null olamaz — istatistik hesaplanamaz');
    }

    // Paralel hesaplama için tüm future'ları başlat
    final currentStreakFuture = _datasource.calculateCurrentStreak(
      habitId,
    );
    final longestStreakFuture = _datasource.calculateLongestStreak(
      habitId,
    );
    final completionRateFuture = _datasource.calculateCompletionRate(
      habitId,
      createdAtStr,
    );
    final todayCompletedFuture = _datasource.isCompleted(
      habitId,
      _toDateStr(DateTime.now()),
    );
    final completedDatesFuture = _datasource.getCompletedDates(
      habitId,
    );

    // Sonuçları topla
    final results = await Future.wait([
      currentStreakFuture,
      longestStreakFuture,
      completionRateFuture,
      todayCompletedFuture,
      completedDatesFuture,
    ]);

    final completedDateStrings = results[4] as List<String>;

    return HabitWithStats(
      habit: habit,
      currentStreak: results[0] as int,
      longestStreak: results[1] as int,
      completionRate: results[2] as double,
      todayCompleted: results[3] as bool,
      completedDates: completedDateStrings
          .map(DateTime.parse)
          .toList(),
    );
  }

  /// DateTime'ı ISO 8601 date-only string'e çevirir
  String _toDateStr(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }
}
