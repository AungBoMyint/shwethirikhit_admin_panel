import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_filter_type.freezed.dart';

@freezed
class CustomerFilterType with _$CustomerFilterType {
  const factory CustomerFilterType.initial() = _Initial;
  const factory CustomerFilterType.admin() = _Admin;
  const factory CustomerFilterType.customer() = _Customer;
  const factory CustomerFilterType.active() = _Active;
  const factory CustomerFilterType.inactive() = _Inactive;
}
