// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_completion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HabitCompletion {
  int? get id => throw _privateConstructorUsedError;
  int get habitId => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of HabitCompletion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitCompletionCopyWith<HabitCompletion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitCompletionCopyWith<$Res> {
  factory $HabitCompletionCopyWith(
    HabitCompletion value,
    $Res Function(HabitCompletion) then,
  ) = _$HabitCompletionCopyWithImpl<$Res, HabitCompletion>;
  @useResult
  $Res call({int? id, int habitId, DateTime completedAt, String? note});
}

/// @nodoc
class _$HabitCompletionCopyWithImpl<$Res, $Val extends HabitCompletion>
    implements $HabitCompletionCopyWith<$Res> {
  _$HabitCompletionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitCompletion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? habitId = null,
    Object? completedAt = null,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            habitId: null == habitId
                ? _value.habitId
                : habitId // ignore: cast_nullable_to_non_nullable
                      as int,
            completedAt: null == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitCompletionImplCopyWith<$Res>
    implements $HabitCompletionCopyWith<$Res> {
  factory _$$HabitCompletionImplCopyWith(
    _$HabitCompletionImpl value,
    $Res Function(_$HabitCompletionImpl) then,
  ) = __$$HabitCompletionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, int habitId, DateTime completedAt, String? note});
}

/// @nodoc
class __$$HabitCompletionImplCopyWithImpl<$Res>
    extends _$HabitCompletionCopyWithImpl<$Res, _$HabitCompletionImpl>
    implements _$$HabitCompletionImplCopyWith<$Res> {
  __$$HabitCompletionImplCopyWithImpl(
    _$HabitCompletionImpl _value,
    $Res Function(_$HabitCompletionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitCompletion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? habitId = null,
    Object? completedAt = null,
    Object? note = freezed,
  }) {
    return _then(
      _$HabitCompletionImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        habitId: null == habitId
            ? _value.habitId
            : habitId // ignore: cast_nullable_to_non_nullable
                  as int,
        completedAt: null == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$HabitCompletionImpl implements _HabitCompletion {
  const _$HabitCompletionImpl({
    this.id,
    required this.habitId,
    required this.completedAt,
    this.note,
  });

  @override
  final int? id;
  @override
  final int habitId;
  @override
  final DateTime completedAt;
  @override
  final String? note;

  @override
  String toString() {
    return 'HabitCompletion(id: $id, habitId: $habitId, completedAt: $completedAt, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitCompletionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.habitId, habitId) || other.habitId == habitId) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, habitId, completedAt, note);

  /// Create a copy of HabitCompletion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitCompletionImplCopyWith<_$HabitCompletionImpl> get copyWith =>
      __$$HabitCompletionImplCopyWithImpl<_$HabitCompletionImpl>(
        this,
        _$identity,
      );
}

abstract class _HabitCompletion implements HabitCompletion {
  const factory _HabitCompletion({
    final int? id,
    required final int habitId,
    required final DateTime completedAt,
    final String? note,
  }) = _$HabitCompletionImpl;

  @override
  int? get id;
  @override
  int get habitId;
  @override
  DateTime get completedAt;
  @override
  String? get note;

  /// Create a copy of HabitCompletion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitCompletionImplCopyWith<_$HabitCompletionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
