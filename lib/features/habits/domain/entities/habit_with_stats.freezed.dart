// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_with_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HabitWithStats {
  Habit get habit => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  bool get todayCompleted => throw _privateConstructorUsedError;
  List<DateTime> get completedDates => throw _privateConstructorUsedError;

  /// Create a copy of HabitWithStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitWithStatsCopyWith<HabitWithStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitWithStatsCopyWith<$Res> {
  factory $HabitWithStatsCopyWith(
    HabitWithStats value,
    $Res Function(HabitWithStats) then,
  ) = _$HabitWithStatsCopyWithImpl<$Res, HabitWithStats>;
  @useResult
  $Res call({
    Habit habit,
    int currentStreak,
    int longestStreak,
    double completionRate,
    bool todayCompleted,
    List<DateTime> completedDates,
  });

  $HabitCopyWith<$Res> get habit;
}

/// @nodoc
class _$HabitWithStatsCopyWithImpl<$Res, $Val extends HabitWithStats>
    implements $HabitWithStatsCopyWith<$Res> {
  _$HabitWithStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitWithStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? habit = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? completionRate = null,
    Object? todayCompleted = null,
    Object? completedDates = null,
  }) {
    return _then(
      _value.copyWith(
            habit: null == habit
                ? _value.habit
                : habit // ignore: cast_nullable_to_non_nullable
                      as Habit,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            todayCompleted: null == todayCompleted
                ? _value.todayCompleted
                : todayCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedDates: null == completedDates
                ? _value.completedDates
                : completedDates // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>,
          )
          as $Val,
    );
  }

  /// Create a copy of HabitWithStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HabitCopyWith<$Res> get habit {
    return $HabitCopyWith<$Res>(_value.habit, (value) {
      return _then(_value.copyWith(habit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HabitWithStatsImplCopyWith<$Res>
    implements $HabitWithStatsCopyWith<$Res> {
  factory _$$HabitWithStatsImplCopyWith(
    _$HabitWithStatsImpl value,
    $Res Function(_$HabitWithStatsImpl) then,
  ) = __$$HabitWithStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Habit habit,
    int currentStreak,
    int longestStreak,
    double completionRate,
    bool todayCompleted,
    List<DateTime> completedDates,
  });

  @override
  $HabitCopyWith<$Res> get habit;
}

/// @nodoc
class __$$HabitWithStatsImplCopyWithImpl<$Res>
    extends _$HabitWithStatsCopyWithImpl<$Res, _$HabitWithStatsImpl>
    implements _$$HabitWithStatsImplCopyWith<$Res> {
  __$$HabitWithStatsImplCopyWithImpl(
    _$HabitWithStatsImpl _value,
    $Res Function(_$HabitWithStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitWithStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? habit = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? completionRate = null,
    Object? todayCompleted = null,
    Object? completedDates = null,
  }) {
    return _then(
      _$HabitWithStatsImpl(
        habit: null == habit
            ? _value.habit
            : habit // ignore: cast_nullable_to_non_nullable
                  as Habit,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        todayCompleted: null == todayCompleted
            ? _value.todayCompleted
            : todayCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedDates: null == completedDates
            ? _value._completedDates
            : completedDates // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>,
      ),
    );
  }
}

/// @nodoc

class _$HabitWithStatsImpl implements _HabitWithStats {
  const _$HabitWithStatsImpl({
    required this.habit,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completionRate = 0.0,
    this.todayCompleted = false,
    final List<DateTime> completedDates = const [],
  }) : _completedDates = completedDates;

  @override
  final Habit habit;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  @JsonKey()
  final double completionRate;
  @override
  @JsonKey()
  final bool todayCompleted;
  final List<DateTime> _completedDates;
  @override
  @JsonKey()
  List<DateTime> get completedDates {
    if (_completedDates is EqualUnmodifiableListView) return _completedDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedDates);
  }

  @override
  String toString() {
    return 'HabitWithStats(habit: $habit, currentStreak: $currentStreak, longestStreak: $longestStreak, completionRate: $completionRate, todayCompleted: $todayCompleted, completedDates: $completedDates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitWithStatsImpl &&
            (identical(other.habit, habit) || other.habit == habit) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.todayCompleted, todayCompleted) ||
                other.todayCompleted == todayCompleted) &&
            const DeepCollectionEquality().equals(
              other._completedDates,
              _completedDates,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    habit,
    currentStreak,
    longestStreak,
    completionRate,
    todayCompleted,
    const DeepCollectionEquality().hash(_completedDates),
  );

  /// Create a copy of HabitWithStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitWithStatsImplCopyWith<_$HabitWithStatsImpl> get copyWith =>
      __$$HabitWithStatsImplCopyWithImpl<_$HabitWithStatsImpl>(
        this,
        _$identity,
      );
}

abstract class _HabitWithStats implements HabitWithStats {
  const factory _HabitWithStats({
    required final Habit habit,
    final int currentStreak,
    final int longestStreak,
    final double completionRate,
    final bool todayCompleted,
    final List<DateTime> completedDates,
  }) = _$HabitWithStatsImpl;

  @override
  Habit get habit;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  double get completionRate;
  @override
  bool get todayCompleted;
  @override
  List<DateTime> get completedDates;

  /// Create a copy of HabitWithStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitWithStatsImplCopyWith<_$HabitWithStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
