/// String için yardımcı extension metodları
///
/// String manipülasyon ve validasyon işlemlerini kolaylaştırır
extension StringExtensions on String {
  // ==========================================================================
  // CAPITALIZATION
  // ==========================================================================

  /// İlk harfi büyük yapar
  ///
  /// Örnek: "hello" → "Hello"
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Her kelimenin ilk harfini büyük yapar (Title Case)
  ///
  /// Örnek: "hello world" → "Hello World"
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Tüm harfleri büyük yapar
  ///
  /// Örnek: "hello" → "HELLO"
  String toUpperCaseAll() {
    return toUpperCase();
  }

  /// Tüm harfleri küçük yapar
  ///
  /// Örnek: "HELLO" → "hello"
  String toLowerCaseAll() {
    return toLowerCase();
  }

  // ==========================================================================
  // VALIDATION
  // ==========================================================================

  /// String boş veya null mu?
  ///
  /// Sadece boşluk karakterleri içeriyorsa da true döner
  bool get isNullOrEmpty {
    return trim().isEmpty;
  }

  /// String dolu mu?
  bool get isNotNullOrEmpty {
    return !isNullOrEmpty;
  }

  /// Email formatı geçerli mi?
  bool get isValidEmail {
    if (isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// URL formatı geçerli mi?
  bool get isValidUrl {
    if (isEmpty) return false;
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Sadece sayı içeriyor mu?
  bool get isNumeric {
    if (isEmpty) return false;
    return double.tryParse(this) != null;
  }

  /// Alfabetik karakterler içeriyor mu?
  bool get isAlphabetic {
    if (isEmpty) return false;
    final alphabeticRegex = RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$');
    return alphabeticRegex.hasMatch(this);
  }

  /// Alfanumerik karakterler içeriyor mu?
  bool get isAlphanumeric {
    if (isEmpty) return false;
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9ğüşıöçĞÜŞİÖÇ\s]+$');
    return alphanumericRegex.hasMatch(this);
  }

  // ==========================================================================
  // TRIMMING
  // ==========================================================================

  /// Başındaki ve sonundaki boşlukları temizler
  String trimAll() {
    return trim();
  }

  /// Başındaki boşlukları temizler
  String trimStart() {
    return replaceFirst(RegExp(r'^\s+'), '');
  }

  /// Sonundaki boşlukları temizler
  String trimEnd() {
    return replaceFirst(RegExp(r'\s+$'), '');
  }

  /// Tüm boşlukları temizler (kelime aralarındaki dahil)
  String removeAllSpaces() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // ==========================================================================
  // TRUNCATION
  // ==========================================================================

  /// String'i belirtilen uzunlukta keser ve sonuna "..." ekler
  ///
  /// Örnek: "Hello World".truncate(8) → "Hello..."
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// String'i kelime sınırında keser
  ///
  /// Örnek: "Hello World Today".truncateWords(2) → "Hello World..."
  String truncateWords(int wordCount, {String suffix = '...'}) {
    final words = split(' ');
    if (words.length <= wordCount) return this;
    return '${words.take(wordCount).join(' ')}$suffix';
  }

  // ==========================================================================
  // PARSING
  // ==========================================================================

  /// String'i integer'a çevirir, başarısız olursa null döner
  int? toIntOrNull() {
    return int.tryParse(this);
  }

  /// String'i integer'a çevirir, başarısız olursa varsayılan değer döner
  int toIntOrDefault(int defaultValue) {
    return int.tryParse(this) ?? defaultValue;
  }

  /// String'i double'a çevirir, başarısız olursa null döner
  double? toDoubleOrNull() {
    return double.tryParse(this);
  }

  /// String'i double'a çevirir, başarısız olursa varsayılan değer döner
  double toDoubleOrDefault(double defaultValue) {
    return double.tryParse(this) ?? defaultValue;
  }

  /// String'i boolean'a çevirir
  ///
  /// "true", "1", "yes" → true
  /// "false", "0", "no" → false
  /// Diğer değerler → null
  bool? toBoolOrNull() {
    final lower = toLowerCase();
    if (lower == 'true' || lower == '1' || lower == 'yes') return true;
    if (lower == 'false' || lower == '0' || lower == 'no') return false;
    return null;
  }

  // ==========================================================================
  // CONTAINS
  // ==========================================================================

  /// Case-insensitive contains
  ///
  /// Örnek: "Hello World".containsIgnoreCase("world") → true
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }

  /// Belirtilen karakterlerden birini içeriyor mu?
  bool containsAny(List<String> characters) {
    return characters.any((char) => contains(char));
  }

  /// Belirtilen karakterlerin hepsini içeriyor mu?
  bool containsAll(List<String> characters) {
    return characters.every((char) => contains(char));
  }

  // ==========================================================================
  // REPLACEMENT
  // ==========================================================================

  /// Birden fazla replace işlemini birlikte yapar
  ///
  /// Örnek:
  /// ```dart
  /// "Hello {name}, you are {age} years old"
  ///   .replaceMultiple({'{name}': 'John', '{age}': '25'})
  /// // → "Hello John, you are 25 years old"
  /// ```
  String replaceMultiple(Map<String, String> replacements) {
    var result = this;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  // ==========================================================================
  // EMOJI
  // ==========================================================================

  /// Emoji içeriyor mu?
  bool get containsEmoji {
    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F700}-\u{1F77F}]|[\u{1F780}-\u{1F7FF}]|[\u{1F800}-\u{1F8FF}]|[\u{1F900}-\u{1F9FF}]|[\u{1FA00}-\u{1FA6F}]|[\u{1FA70}-\u{1FAFF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
      unicode: true,
    );
    return emojiRegex.hasMatch(this);
  }

  /// Sadece emoji içeriyor mu? (başka karakter yok)
  bool get isOnlyEmoji {
    if (isEmpty) return false;
    final withoutEmoji = replaceAll(
      RegExp(
        r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F700}-\u{1F77F}]|[\u{1F780}-\u{1F7FF}]|[\u{1F800}-\u{1F8FF}]|[\u{1F900}-\u{1F9FF}]|[\u{1FA00}-\u{1FA6F}]|[\u{1FA70}-\u{1FAFF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
        unicode: true,
      ),
      '',
    );
    return withoutEmoji.trim().isEmpty && containsEmoji;
  }
}

/// Nullable String için extension
extension NullableStringExtensions on String? {
  /// Null veya boş mu?
  bool get isNullOrEmpty {
    return this == null || this!.trim().isEmpty;
  }

  /// Null veya boş değil mi?
  bool get isNotNullOrEmpty {
    return !isNullOrEmpty;
  }

  /// Null ise varsayılan değer döner
  String orDefault(String defaultValue) {
    return isNullOrEmpty ? defaultValue : this!;
  }
}
