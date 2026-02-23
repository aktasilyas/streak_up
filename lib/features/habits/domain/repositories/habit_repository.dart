import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_with_stats.dart';

/// Alışkanlık repository arayüzü — Domain katmanının veri sözleşmesi
///
/// Data katmanı bu arayüzü implement eder.
/// Domain katmanı sadece bu arayüze bağımlıdır (Dependency Inversion).
/// Tüm metodlar [Future] döner — asenkron veri erişimi.
abstract class HabitRepository {
  // ==========================================================================
  // HABIT CRUD
  // ==========================================================================

  /// Tüm alışkanlıkları getirir (arşivlenmiş dahil)
  Future<List<Habit>> getAll();

  /// Sadece aktif alışkanlıkları getirir (arşivlenmemiş)
  Future<List<Habit>> getActive();

  /// Belirli bir alışkanlığı ID ile getirir
  ///
  /// Bulunamazsa hata fırlatır
  Future<Habit> getById(int id);

  /// Yeni alışkanlık oluşturur ve kaydedilmiş halini döner
  ///
  /// Dönen entity veritabanı tarafından atanan [id] değerini içerir
  Future<Habit> create(Habit habit);

  /// Mevcut alışkanlığı günceller ve güncel halini döner
  Future<Habit> update(Habit habit);

  /// Alışkanlığı ve tüm tamamlama kayıtlarını kalıcı olarak siler
  Future<void> delete(int id);

  /// Alışkanlığı arşivler (geri yüklenebilir soft delete)
  Future<void> archive(int id);

  // ==========================================================================
  // COMPLETION İŞLEMLERİ
  // ==========================================================================

  /// Belirli bir günün tamamlama durumunu tersine çevirir
  ///
  /// Tamamlanmadıysa tamamlar, tamamlandıysa geri alır.
  /// [habitId] — Alışkanlık ID'si
  /// [date] — Tamamlama tarihi (sadece tarih kısmı kullanılır)
  Future<void> toggleCompletion(int habitId, DateTime date);

  /// Belirli bir günde alışkanlık tamamlanmış mı kontrol eder
  Future<bool> isCompleted(int habitId, DateTime date);

  /// Belirli tarih aralığındaki tamamlama tarihlerini getirir
  ///
  /// [from] ve [to] verilmezse tüm tarihler döner
  Future<List<DateTime>> getCompletedDates(
    int habitId, {
    DateTime? from,
    DateTime? to,
  });

  // ==========================================================================
  // İSTATİSTİK İŞLEMLERİ
  // ==========================================================================

  /// Tek bir alışkanlığı istatistikleriyle birlikte getirir
  Future<HabitWithStats> getHabitWithStats(int habitId);

  /// Tüm aktif alışkanlıkları istatistikleriyle birlikte getirir
  Future<List<HabitWithStats>> getAllWithStats();
}
