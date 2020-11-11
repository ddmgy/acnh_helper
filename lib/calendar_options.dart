import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/month.dart';

class CalendarOptions {
  final Month month;
  final Hemisphere hemisphere;

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