import 'package:freezed_annotation/freezed_annotation.dart';

part 'areas_choose.freezed.dart';

@freezed
class AreasChoose with _$AreasChoose {
  factory AreasChoose.CLID() = _CLID;
  factory AreasChoose.BMJ() = _BMJ;
  factory AreasChoose.ISE() = _ISE;
  factory AreasChoose.BMS() = _BMS;
  factory AreasChoose.ENST() = _ENST;
  factory AreasChoose.HIC() = _HIC;
  factory AreasChoose.BGH() = _BGH;
}
