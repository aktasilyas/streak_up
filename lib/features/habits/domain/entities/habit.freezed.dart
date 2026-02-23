// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Habit {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  HabitFrequency get frequency => throw _privateConstructorUsedError;
  List<int>? get targetDays => throw _privateConstructorUsedError;
  String? get reminderTime => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitCopyWith<Habit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitCopyWith<$Res> {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) then) =
      _$HabitCopyWithImpl<$Res, Habit>;
  @useResult
  $Res call({
    int? id,
    String name,
    String? description,
    String icon,
    int color,
    HabitFrequency frequency,
    List<int>? targetDays,
    String? reminderTime,
    DateTime createdAt,
    DateTime updatedAt,
    bool isArchived,
  });
}

/// @nodoc
class _$HabitCopyWithImpl<$Res, $Val extends Habit>
    implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? icon = null,
    Object? color = null,
    Object? frequency = null,
    Object? targetDays = freezed,
    Object? reminderTime = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isArchived = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as int,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as HabitFrequency,
            targetDays: freezed == targetDays
                ? _value.targetDays
                : targetDays // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            reminderTime: freezed == reminderTime
                ? _value.reminderTime
                : reminderTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitImplCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$$HabitImplCopyWith(
    _$HabitImpl value,
    $Res Function(_$HabitImpl) then,
  ) = __$$HabitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String name,
    String? description,
    String icon,
    int color,
    HabitFrequency frequency,
    List<int>? targetDays,
    String? reminderTime,
    DateTime createdAt,
    DateTime updatedAt,
    bool isArchived,
  });
}

/// @nodoc
class __$$HabitImplCopyWithImpl<$Res>
    extends _$HabitCopyWithImpl<$Res, _$HabitImpl>
    implements _$$HabitImplCopyWith<$Res> {
  __$$HabitImplCopyWithImpl(
    _$HabitImpl _value,
    $Res Function(_$HabitImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? icon = null,
    Object? color = null,
    Object? frequency = null,
    Object? targetDays = freezed,
    Object? reminderTime = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isArchived = null,
  }) {
    return _then(
      _$HabitImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as int,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as HabitFrequency,
        targetDays: freezed == targetDays
            ? _value._targetDays
            : targetDays // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        reminderTime: freezed == reminderTime
            ? _value.reminderTime
            : reminderTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$HabitImpl implements _Habit {
  const _$HabitImpl({
    this.id,
    required this.name,
    this.description,
    this.icon = '✅',
    this.color = 0xFF4CAF50,
    this.frequency = HabitFrequency.daily,
    final List<int>? targetDays,
    this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  }) : _targetDays = targetDays;

  @override
  final int? id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final int color;
  @override
  @JsonKey()
  final HabitFrequency frequency;
  final List<int>? _targetDays;
  @override
  List<int>? get targetDays {
    final value = _targetDays;
    if (value == null) return null;
    if (_targetDays is EqualUnmodifiableListView) return _targetDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? reminderTime;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isArchived;

  @override
  String toString() {
    return 'Habit(id: $id, name: $name, description: $description, icon: $icon, color: $color, frequency: $frequency, targetDays: $targetDays, reminderTime: $reminderTime, createdAt: $createdAt, updatedAt: $updatedAt, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality().equals(
              other._targetDays,
              _targetDays,
            ) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    icon,
    color,
    frequency,
    const DeepCollectionEquality().hash(_targetDays),
    reminderTime,
    createdAt,
    updatedAt,
    isArchived,
  );

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      __$$HabitImplCopyWithImpl<_$HabitImpl>(this, _$identity);
}

abstract class _Habit implements Habit {
  const factory _Habit({
    final int? id,
    required final String name,
    final String? description,
    final String icon,
    final int color,
    final HabitFrequency frequency,
    final List<int>? targetDays,
    final String? reminderTime,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final bool isArchived,
  }) = _$HabitImpl;

  @override
  int? get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get icon;
  @override
  int get color;
  @override
  HabitFrequency get frequency;
  @override
  List<int>? get targetDays;
  @override
  String? get reminderTime;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isArchived;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
