import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite veritabanı servisi — Singleton pattern
///
/// Uygulama genelinde tek bir veritabanı bağlantısı yönetir.
/// Habits ve completions tablolarını oluşturur ve CRUD yardımcıları sağlar.
class DatabaseService {
  DatabaseService._internal();

  /// Singleton instance
  static final DatabaseService instance = DatabaseService._internal();

  /// Factory constructor — her zaman aynı instance'ı döner
  factory DatabaseService() => instance;

  /// Veritabanı instance'ı (lazy init)
  Database? _database;

  /// Veritabanı versiyon numarası
  ///
  /// Her şema değişikliğinde artırılmalı
  static const int _version = 1;

  /// Veritabanı dosya adı
  static const String _databaseName = 'streak_up.db';

  // ==========================================================================
  // TABLO ADLARI
  // ==========================================================================

  /// Alışkanlıklar tablosu
  static const String tableHabits = 'habits';

  /// Tamamlama kayıtları tablosu
  static const String tableCompletions = 'completions';

  // ==========================================================================
  // HABITS TABLO KOLON ADLARI
  // ==========================================================================

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colDescription = 'description';
  static const String colIcon = 'icon';
  static const String colColor = 'color';
  static const String colFrequency = 'frequency';
  static const String colTargetDays = 'target_days';
  static const String colReminderTime = 'reminder_time';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colIsArchived = 'is_archived';

  // ==========================================================================
  // COMPLETIONS TABLO KOLON ADLARI
  // ==========================================================================

  static const String colHabitId = 'habit_id';
  static const String colCompletedAt = 'completed_at';
  static const String colNote = 'note';

  // ==========================================================================
  // VERITABANI YAŞAM DÖNGÜSÜ
  // ==========================================================================

  /// Veritabanı instance'ını döner — ilk çağrıda init eder
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Veritabanını oluşturur ve açar
  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, _databaseName);

    debugPrint('DatabaseService: Veritabanı açılıyor → $path');

    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  /// Foreign key desteğini aktifleştirir
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// İlk kurulumda tabloları oluşturur (v1)
  Future<void> _onCreate(Database db, int version) async {
    debugPrint('DatabaseService: Tablolar oluşturuluyor (v$version)');

    // Habits tablosu
    await db.execute('''
      CREATE TABLE $tableHabits (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT NOT NULL,
        $colDescription TEXT,
        $colIcon TEXT NOT NULL DEFAULT '✅',
        $colColor INTEGER NOT NULL DEFAULT 0xFF4CAF50,
        $colFrequency TEXT NOT NULL DEFAULT 'daily',
        $colTargetDays TEXT,
        $colReminderTime TEXT,
        $colCreatedAt TEXT NOT NULL,
        $colUpdatedAt TEXT NOT NULL,
        $colIsArchived INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Completions tablosu
    await db.execute('''
      CREATE TABLE $tableCompletions (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colHabitId INTEGER NOT NULL,
        $colCompletedAt TEXT NOT NULL,
        $colNote TEXT,
        FOREIGN KEY ($colHabitId) REFERENCES $tableHabits($colId) ON DELETE CASCADE,
        UNIQUE($colHabitId, $colCompletedAt)
      )
    ''');

    // Performans için index
    await db.execute('''
      CREATE INDEX idx_completions_habit_date
      ON $tableCompletions($colHabitId, $colCompletedAt)
    ''');

    debugPrint('DatabaseService: Tablolar başarıyla oluşturuldu');
  }

  /// Şema güncellemeleri için migration handler
  ///
  /// Her yeni versiyon için bir case eklenir.
  /// Drop table ASLA yapılmaz — sadece ALTER TABLE kullanılır.
  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    debugPrint(
      'DatabaseService: Migration v$oldVersion → v$newVersion',
    );

    // Gelecek migration'lar burada zincirlenir:
    // if (oldVersion < 2) { await _migrateV1ToV2(db); }
    // if (oldVersion < 3) { await _migrateV2ToV3(db); }
  }

  // ==========================================================================
  // CRUD YARDIMCI METODLARI
  // ==========================================================================

  /// Yeni kayıt ekler ve oluşturulan id'yi döner
  Future<int> insert(String table, Map<String, Object?> values) async {
    final db = await database;
    return db.insert(table, values);
  }

  /// Tüm kayıtları getirir
  ///
  /// [where] ve [whereArgs] ile filtreleme yapılabilir.
  /// [orderBy] ile sıralama yapılabilir.
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Kaydı günceller ve etkilenen satır sayısını döner
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Kaydı siler ve etkilenen satır sayısını döner
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Ham SQL sorgusu çalıştırır (karmaşık JOIN sorgular için)
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await database;
    return db.rawQuery(sql, arguments);
  }

  /// Transaction içinde birden fazla işlem yapar
  ///
  /// Tüm işlemler atomik olarak çalışır — birisi hata verirse
  /// hepsi geri alınır.
  Future<T> transaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    final db = await database;
    return db.transaction(action);
  }

  // ==========================================================================
  // VERITABANI BAKIM
  // ==========================================================================

  /// Veritabanını kapatır
  ///
  /// Uygulama kapanırken çağrılmalı
  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
      debugPrint('DatabaseService: Veritabanı kapatıldı');
    }
  }

  /// Veritabanının açık olup olmadığını kontrol eder
  bool get isOpen => _database?.isOpen ?? false;
}
