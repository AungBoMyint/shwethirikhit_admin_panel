import 'package:freezed_annotation/freezed_annotation.dart';

part 'rbpoint.freezed.dart';

@freezed
class RBPoint with _$RBPoint {
  const factory RBPoint.xl() = _XL;
  const factory RBPoint.desktop() = _Desktop;
  const factory RBPoint.tablet() = _Tablet;
  const factory RBPoint.mobile() = _Mobile;
}
