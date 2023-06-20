// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'string_validator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$StringValidator {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() emptyOrNull,
    required TResult Function() tooShort,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? emptyOrNull,
    TResult? Function()? tooShort,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? emptyOrNull,
    TResult Function()? tooShort,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmptyOrNull value) emptyOrNull,
    required TResult Function(_TooShort value) tooShort,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmptyOrNull value)? emptyOrNull,
    TResult? Function(_TooShort value)? tooShort,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmptyOrNull value)? emptyOrNull,
    TResult Function(_TooShort value)? tooShort,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StringValidatorCopyWith<$Res> {
  factory $StringValidatorCopyWith(
          StringValidator value, $Res Function(StringValidator) then) =
      _$StringValidatorCopyWithImpl<$Res, StringValidator>;
}

/// @nodoc
class _$StringValidatorCopyWithImpl<$Res, $Val extends StringValidator>
    implements $StringValidatorCopyWith<$Res> {
  _$StringValidatorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_EmptyOrNullCopyWith<$Res> {
  factory _$$_EmptyOrNullCopyWith(
          _$_EmptyOrNull value, $Res Function(_$_EmptyOrNull) then) =
      __$$_EmptyOrNullCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_EmptyOrNullCopyWithImpl<$Res>
    extends _$StringValidatorCopyWithImpl<$Res, _$_EmptyOrNull>
    implements _$$_EmptyOrNullCopyWith<$Res> {
  __$$_EmptyOrNullCopyWithImpl(
      _$_EmptyOrNull _value, $Res Function(_$_EmptyOrNull) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_EmptyOrNull implements _EmptyOrNull {
  _$_EmptyOrNull();

  @override
  String toString() {
    return 'StringValidator.emptyOrNull()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_EmptyOrNull);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() emptyOrNull,
    required TResult Function() tooShort,
  }) {
    return emptyOrNull();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? emptyOrNull,
    TResult? Function()? tooShort,
  }) {
    return emptyOrNull?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? emptyOrNull,
    TResult Function()? tooShort,
    required TResult orElse(),
  }) {
    if (emptyOrNull != null) {
      return emptyOrNull();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmptyOrNull value) emptyOrNull,
    required TResult Function(_TooShort value) tooShort,
  }) {
    return emptyOrNull(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmptyOrNull value)? emptyOrNull,
    TResult? Function(_TooShort value)? tooShort,
  }) {
    return emptyOrNull?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmptyOrNull value)? emptyOrNull,
    TResult Function(_TooShort value)? tooShort,
    required TResult orElse(),
  }) {
    if (emptyOrNull != null) {
      return emptyOrNull(this);
    }
    return orElse();
  }
}

abstract class _EmptyOrNull implements StringValidator {
  factory _EmptyOrNull() = _$_EmptyOrNull;
}

/// @nodoc
abstract class _$$_TooShortCopyWith<$Res> {
  factory _$$_TooShortCopyWith(
          _$_TooShort value, $Res Function(_$_TooShort) then) =
      __$$_TooShortCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_TooShortCopyWithImpl<$Res>
    extends _$StringValidatorCopyWithImpl<$Res, _$_TooShort>
    implements _$$_TooShortCopyWith<$Res> {
  __$$_TooShortCopyWithImpl(
      _$_TooShort _value, $Res Function(_$_TooShort) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_TooShort implements _TooShort {
  _$_TooShort();

  @override
  String toString() {
    return 'StringValidator.tooShort()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_TooShort);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() emptyOrNull,
    required TResult Function() tooShort,
  }) {
    return tooShort();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? emptyOrNull,
    TResult? Function()? tooShort,
  }) {
    return tooShort?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? emptyOrNull,
    TResult Function()? tooShort,
    required TResult orElse(),
  }) {
    if (tooShort != null) {
      return tooShort();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmptyOrNull value) emptyOrNull,
    required TResult Function(_TooShort value) tooShort,
  }) {
    return tooShort(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmptyOrNull value)? emptyOrNull,
    TResult? Function(_TooShort value)? tooShort,
  }) {
    return tooShort?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmptyOrNull value)? emptyOrNull,
    TResult Function(_TooShort value)? tooShort,
    required TResult orElse(),
  }) {
    if (tooShort != null) {
      return tooShort(this);
    }
    return orElse();
  }
}

abstract class _TooShort implements StringValidator {
  factory _TooShort() = _$_TooShort;
}
