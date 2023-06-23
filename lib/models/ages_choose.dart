import 'package:freezed_annotation/freezed_annotation.dart';

part 'ages_choose.freezed.dart';

@freezed
class AgesChoose with _$AgesChoose {
  factory AgesChoose.under18() = _Under18;
  factory AgesChoose.b18And24() = _B18And24;
  factory AgesChoose.b25And34() = _B25And34;
  factory AgesChoose.b35And44() = _B35And44;
  factory AgesChoose.above55() = _Above55;
}
