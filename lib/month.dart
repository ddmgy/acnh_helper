import 'package:acnh_helper/utils.dart';

enum Month {
  Current,
  January,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December,
}

const _monthNamesShort = [
  "Jan.",
  "Feb.",
  "Mar.",
  "Apr.",
  "May",
  "June",
  "July",
  "Aug.",
  "Sept.",
  "Oct.",
  "Nov.",
  "Dec.",
];

const _monthNamesLong = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

extension MonthExtensions on Month {
  int toInt() {
    assert(this != null);
    return index;
  }

  String getName() {
    assert(this != null);
    if (this == Month.Current) {
      final index = getCurrentMonth() - 1;
      return "${_monthNamesLong[index]} (current)";
    } else {
      return _monthNamesLong[this.index - 1];
    }
  }

  String getShortName() {
    assert(this != null);
    final index = this == Month.Current ? getCurrentMonth() : this.index;
    return _monthNamesShort[index - 1];
  }
}

extension IntExtensions on int {
  Month toMonth() {
    assert(this != null && this >= 0 && this < Month.values.length);
    return Month.values[this];
  }
}