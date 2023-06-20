import 'package:freezed_annotation/freezed_annotation.dart';

part 'string_validator.freezed.dart';

@freezed
class StringValidator with _$StringValidator {
  factory StringValidator.emptyOrNull() = _EmptyOrNull;
  factory StringValidator.tooShort() = _TooShort;
}
