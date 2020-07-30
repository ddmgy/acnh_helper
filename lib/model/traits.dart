import 'package:acnh_helper/calendar_options.dart';
import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/month.dart';
import 'package:acnh_helper/utils.dart';

/// Traits common to add entries in database
abstract class CommonTraits {
  int id;
  String name;
  String imageUri;
  String thumbnailUri;
}

/// Traits common to all entries that can be found and donated to museum
abstract class DonatableTraits {
  int sellPrice;
  bool found;
  bool donated;

  DonatableTraits copyWith({bool found, bool donated}) {
    throw UnimplementedError();
  }
}

/// Traits common to all entries that are only available at certain times
abstract class AvailabilityTraits {
  List<bool> monthsAvailableNorthern;
  List<bool> monthsAvailableSouthern;
  List<bool> timesAvailable;
}

extension AvailabilityTraitsExtensions on AvailabilityTraits {
  bool isCurrentlyAvailable(CalendarOptions options) {
    int month = (options.month == Month.Current ? getCurrentMonth() : options.month.index) - 1;
    if (options.hemisphere == Hemisphere.Northern) {
      return monthsAvailableNorthern[month];
    } else { // Hemisphere.Southern
      return monthsAvailableSouthern[month];
    }
  }

  bool isNewlyAvailable(CalendarOptions options) {
    int month = (options.month == Month.Current ? getCurrentMonth() : options.month.index) - 1;
    int previousMonth = (month - 1) % 12;
    if (options.hemisphere == Hemisphere.Northern) {
      return !monthsAvailableNorthern[previousMonth] && monthsAvailableNorthern[month];
    } else { // Hemisphere.Southern
      return !monthsAvailableSouthern[previousMonth] && monthsAvailableSouthern[month];
    }
  }

  bool isLeavingSoon(CalendarOptions options) {
    int month = (options.month == Month.Current ? getCurrentMonth() : options.month.index) - 1;
    int nextMonth = (month + 1) % 12;
    if (options.hemisphere == Hemisphere.Northern) {
      return !monthsAvailableNorthern[nextMonth] && monthsAvailableNorthern[month];
    } else { // Hemisphere.Southern
      return !monthsAvailableSouthern[nextMonth] && monthsAvailableSouthern[month];
    }
  }
}

/// Traits common to all entries that are only available at certain locations
abstract class LocationTraits {
  String location;
}

/// Traits common to all entries with a shadow
abstract class ShadowTraits {
  String shadow;
}

/// Traits exclusive to Art entries
abstract class ArtTraits {
  bool hasFake;
  int buyPrice;
}

/// Traits exclusive to SeaCreature entries
abstract class SeaCreatureTraits {
  String speed;
}

/// Traits exclusive to Villager entries
abstract class VillagerTraits {
  String personality;
  String birthday;
  String birthdayString;
  String species;
  String gender;
  bool isNeighbor;

  VillagerTraits copyWith({bool isNeighbor}) {
    throw UnimplementedError();
  }
}