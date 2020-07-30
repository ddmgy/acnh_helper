import 'package:equatable/equatable.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/month.dart';

class CalendarOptions extends Equatable {
  final Month month;
  final Hemisphere hemisphere;

  @override
  List<Object> get props => [month, hemisphere];

  const CalendarOptions({
    this.month = Month.Current,
    this.hemisphere = Hemisphere.Northern,
  }) :
    assert(hemisphere != null, "$hemisphere");

  @override
  String toString() {
    return "${month.getName(includeCurrent: false)}, ${hemisphere.getName()}";
  }
}