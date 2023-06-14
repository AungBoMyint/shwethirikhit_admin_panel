import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_type.freezed.dart';

@freezed
class PageType with _$PageType {
  const factory PageType.initial() = _Initial;
  const factory PageType.news() = _Overview;
  const factory PageType.newsSlider() = _NewsSlider;
  const factory PageType.newsType() = _NewsType;
  const factory PageType.newsItems() = _NewsItems;
  const factory PageType.newsItemsAdd() = _NewsItemsAdd;
  const factory PageType.vlog() = _Vlog;
  const factory PageType.vlogAdd() = _VlogAdd;
  const factory PageType.customers() = _Customers;
  const factory PageType.addCustomer() = _AddCustomer;
  const factory PageType.learning() = _Learning;
  const factory PageType.therapy() = _Therapy;
  const factory PageType.therapyCategory() = _TherapyCategory;
  const factory PageType.therapyItems() = _TherapyItems;
  const factory PageType.therapyItemsAdd() = _TherapyItemsAdd;
  const factory PageType.affirmations() = _Affirmations;
  const factory PageType.affirmationsCategory() = _AffirmationsCategory;
  const factory PageType.affirmationsType() = _AffirmationsType;
  const factory PageType.affirmationsItems() = _AffirmationsItems;
  const factory PageType.affirmationsItemsAdd() = _AffirmationsItemsAdd;
  const factory PageType.settings() = _Settings;
  const factory PageType.updateProfile() = _UpdateProfile;
}
