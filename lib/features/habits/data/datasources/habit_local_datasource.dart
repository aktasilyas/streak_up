import 'package:streak_up/features/habits/data/models/habit_completion_model.dart';
import 'package:streak_up/features/habits/data/models/habit_model.dart';
import 'package:streak_up/services/database_service.dart';

/// Alışkanlık yerel veri kaynağı — SQLite işlemleri
///
/// [DatabaseService] üzerinden CRUD operasyonları yapar.
/// Streak hesaplama algoritmaları bu sınıfta bulunur.
class HabitLocalDatasource {
  /// [databaseService] — SQLite wrapper
  const HabitLocalDatasource(this._db);

  final DatabaseService _db;

  // ==========================================================================
  // HABIT CRUD
  // ==========================================================================

  /// Tüm alışkanlıkları getirir
  Future<List<HabitModel>> getAll() async {
    final maps = await _db.query(
      DatabaseService.tableHabits,
      orderBy: '${DatabaseService.colCreatedAt} DESC',
    );
    return maps.map(HabitModel.fromMap).toList();
  }

  /// Sadece aktif (arşivlenmemiş) alışkanlıkları getirir
  Future<List<HabitModel>> getActive() async {
    final maps = await _db.query(
      DatabaseService.tableHabits,
      where: '${DatabaseService.colIsArchived} = ?',
      whereArgs: [0],
      orderBy: '${DatabaseService.colCreatedAt} DESC',
    );
    return maps.map(HabitModel.fromMap).toList();
  }

  /// ID ile tek alışkanlık getirir
  Future<HabitModel> getById(int id) async {
    final maps = await _db.query(
      DatabaseService.tableHabits,
      where: '${DatabaseService.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw StateError('Alışkanlık bulunamadı: id=$id');
    }

    return HabitModel.fromMap(maps.first);
  }

  /// Yeni alışkanlık ekler ve ID'si atanmış modeli döner
  Future<HabitModel> insert(HabitModel model) async {
    final id = await _db.insert(
      DatabaseService.tableHabits,
      model.toMap(),
    );
    return HabitModel.fromMap({...model.toMap(), 'id': id});
  }

  /// Alışkanlığı günceller ve güncel modeli döner
  Future<HabitModel> update(HabitModel model) async {
    await _db.update(
      DatabaseService.tableHabits,
      model.toMap(),
      where: '${DatabaseService.colId} = ?',
      whereArgs: [model.id],
    );
    return model;
  }

  /// Alışkanlığı kalıcı olarak siler (CASCADE ile completions da silinir)
  Future<void> delete(int id) async {
    await _db.delete(
      DatabaseService.tableHabits,
      where: '${DatabaseService.colId} = ?',
      whereArgs: [id],
    );
  }

  /// Alışkanlığı arşivler
  Future<void> archive(int id) async {
    await _db.update(
      DatabaseService.tableHabits,
      {
        DatabaseService.colIsArchived: 1,
        DatabaseService.colUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseService.colId} = ?',
      whereArgs: [id],
    );
  }

  // ==========================================================================
  // COMPLETION İŞLEMLERİ
  // ==========================================================================

  /// Tamamlama durumunu tersine çevirir
  ///
  /// Kayıt varsa siler, yoksa ekler (toggle mantığı).
  Future<void> toggleCompletion(int habitId, String dateStr) async {
    final existing = await _db.query(
      DatabaseService.tableCompletions,
      where: '${DatabaseService.colHabitId} = ? '
          'AND ${DatabaseService.colCompletedAt} = ?',
      whereArgs: [habitId, dateStr],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      // Zaten tamamlanmış — geri al
      await _db.delete(
        DatabaseService.tableCompletions,
        where: '${DatabaseService.colHabitId} = ? '
            'AND ${DatabaseService.colCompletedAt} = ?',
        whereArgs: [habitId, dateStr],
      );
    } else {
      // Tamamlanmamış — tamamla
      final model = HabitCompletionModel(
        habitId: habitId,
        completedAt: dateStr,
      );
      await _db.insert(
        DatabaseService.tableCompletions,
        model.toMap(),
      );
    }
  }

  /// Belirli gün tamamlanmış mı
  Future<bool> isCompleted(int habitId, String dateStr) async {
    final maps = await _db.query(
      DatabaseService.tableCompletions,
      where: '${DatabaseService.colHabitId} = ? '
          'AND ${DatabaseService.colCompletedAt} = ?',
      whereArgs: [habitId, dateStr],
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  /// Tarih aralığındaki tamamlama tarihlerini getirir
  ///
  /// [from] ve [to] ISO 8601 date-only format ("2025-02-23")
  Future<List<String>> getCompletedDates(
    int habitId, {
    String? from,
    String? to,
  }) async {
    final whereParts = [
      '${DatabaseService.colHabitId} = ?',
    ];
    final whereArgs = <Object>[habitId];

    if (from != null) {
      whereParts.add('${DatabaseService.colCompletedAt} >= ?');
      whereArgs.add(from);
    }
    if (to != null) {
      whereParts.add('${DatabaseService.colCompletedAt} <= ?');
      whereArgs.add(to);
    }

    final maps = await _db.query(
      DatabaseService.tableCompletions,
      where: whereParts.join(' AND '),
      whereArgs: whereArgs,
      orderBy: '${DatabaseService.colCompletedAt} ASC',
    );

    return maps
        .map((m) => m[DatabaseService.colCompletedAt] as String)
        .toList();
  }

  // ==========================================================================
  // STREAK HESAPLAMA
  // ==========================================================================

  /// Mevcut streak'i hesaplar (art arda tamamlanan gün sayısı)
  ///
  /// Algoritma:
  /// 1. Bugün tamamlandıysa bugünden geriye say
  /// 2. Bugün tamamlanmadıysa dünden geriye say
  /// 3. Art arda her gün tamamlandıysa streak artır
  /// 4. Boşluk bulunca dur
  Future<int> calculateCurrentStreak(int habitId) async {
    final dates = await getCompletedDates(habitId);
    if (dates.isEmpty) return 0;

    return _calculateStreakFromEnd(dates);
  }

  /// En uzun streak'i hesaplar
  ///
  /// Tüm tamamlama geçmişini tarar ve en uzun ardışık
  /// gün serisini bulur.
  Future<int> calculateLongestStreak(int habitId) async {
    final dates = await getCompletedDates(habitId);
    if (dates.isEmpty) return 0;

    return _calculateLongestStreak(dates);
  }

  /// Tamamlanma oranını hesaplar
  ///
  /// Oluşturulma tarihinden bugüne kadar olan günlerde
  /// tamamlanan gün yüzdesi (0.0 - 1.0)
  Future<double> calculateCompletionRate(
    int habitId,
    String createdAtStr,
  ) async {
    final createdAt = DateTime.parse(createdAtStr);
    final now = DateTime.now();
    final totalDays = now.difference(createdAt).inDays + 1;

    if (totalDays <= 0) return 0.0;

    final dates = await getCompletedDates(habitId);
    return dates.length / totalDays;
  }

  /// Son tarihten geriye doğru streak hesaplar — [dates] sıralı (ASC)
  int _calculateStreakFromEnd(List<String> dates) {
    final today = _todayStr();
    final yesterday = _yesterdayStr();

    // Son tamamlanan tarih bugün veya dün değilse streak sıfır
    final lastDate = dates.last;
    if (lastDate != today && lastDate != yesterday) return 0;

    var streak = 1;
    // Sondan başa doğru ardışık günleri say
    for (var i = dates.length - 2; i >= 0; i--) {
      final current = DateTime.parse(dates[i]);
      final next = DateTime.parse(dates[i + 1]);
      final diff = next.difference(current).inDays;

      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Tüm geçmişte en uzun streak'i bulur
  int _calculateLongestStreak(List<String> dates) {
    if (dates.isEmpty) return 0;

    var longest = 1;
    var current = 1;

    for (var i = 1; i < dates.length; i++) {
      final prev = DateTime.parse(dates[i - 1]);
      final curr = DateTime.parse(dates[i]);
      final diff = curr.difference(prev).inDays;

      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else if (diff > 1) {
        current = 1;
      }
      // diff == 0 ise aynı gün (olmamalı ama güvenlik için)
    }

    return longest;
  }

  /// Bugünün ISO 8601 date-only string'i
  String _todayStr() => _formatDateOnly(DateTime.now());

  /// Dünün ISO 8601 date-only string'i
  String _yesterdayStr() {
    return _formatDateOnly(
      DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  /// DateTime'ı "YYYY-MM-DD" formatına çevirir
  String _formatDateOnly(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }
}
