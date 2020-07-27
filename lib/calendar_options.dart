import 'package:equatable/equatable.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/utils.dart';

class CalendarOptions extends Equatable {
  final int month;
  final Hemisphere hemisphere;

  @override
  List<Object> get props => [month, hemisphere];

  const CalendarOptions({
    this.month = 0,
    this.hemisphere = Hemisphere.Northern,
  }) :
    assert(month >= 0 && month <= 12, "$month"),
    assert(hemisphere != null, "$hemisphere");

  @override
  String toString() {
    var _month = month;
    if (month == 0) {
      _month = getCurrentMonth();
    }

    return "${getMonthName(_month)}, ${hemisphere.getName()}";
  }
}