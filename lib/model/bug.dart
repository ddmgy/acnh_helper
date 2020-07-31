import 'package:acnh_helper/database/table/bug_table.dart';
import 'package:acnh_helper/model/mappable.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/utils.dart';

class Bug implements Mappable, CommonTraits, DonatableTraits, AvailabilityTraits, LocationTraits {
  int id;
  String name;
  String imageUri;
  String thumbnailUri;
  int sellPrice;
  bool found;
  bool donated;
  List<bool> monthsAvailableNorthern;
  List<bool> monthsAvailableSouthern;
  List<bool> timesAvailable;
  String location;

  Bug({
    this.id,
    this.name,
    this.imageUri,
    this.thumbnailUri,
    this.sellPrice,
    this.found,
    this.donated,
    this.monthsAvailableNorthern,
    this.monthsAvailableSouthern,
    this.timesAvailable,
    this.location,
  });

  @override
  Bug copyWith({bool found, bool donated}) {
    return Bug(
      id: this.id,
      name: this.name,
      imageUri: this.imageUri,
      thumbnailUri: this.thumbnailUri,
      sellPrice: this.sellPrice,
      found: found ?? this.found,
      donated: donated ?? this.donated,
      monthsAvailableNorthern: this.monthsAvailableNorthern,
      monthsAvailableSouthern: this.monthsAvailableSouthern,
      timesAvailable: this.timesAvailable,
      location: this.location,
    );
  }

  @override
  factory Bug.fromMap(Map<String, dynamic> map) {
    return Bug(
      id: map[BugTable.colId] as int,
      name: map[BugTable.colName] as String,
      imageUri: map[BugTable.colImageUri] as String,
      thumbnailUri: map[BugTable.colThumbnailUri] as String,
      sellPrice: map[BugTable.colSellPrice] as int,
      found: (map[BugTable.colFound] as int).toBool(),
      donated: (map[BugTable.colDonated] as int).toBool(),
      monthsAvailableNorthern: (map[BugTable.colMonthsAvailableNorthern] as int).toBoolList(12),
      monthsAvailableSouthern: (map[BugTable.colMonthsAvailableSouthern] as int).toBoolList(12),
      timesAvailable: (map[BugTable.colTimesAvailable] as int).toBoolList(24),
      location: map[BugTable.colLocation] as String,
    );
  }

  /// Create `Fish` instance from map returned by API.
  @override
  factory Bug.fromNetworkMap(Map<String, dynamic> map) {
    final monthsNorthern = List<int>.from(map["availability"]["month-array-northern"]);
    final monthsSouthern = List<int>.from(map["availability"]["month-array-southern"]);
    final times = List<int>.from(map["availability"]["time-array"]);

    return Bug(
      id: map["id"] as int,
      name: (map["name"]["name-USen"] as String).capitalize(),
      imageUri: map["image_uri"] as String,
      thumbnailUri: map["icon_uri"] as String,
      sellPrice: map["price"] as int,
      found: false,
      donated: false,
      monthsAvailableNorthern: monthsNorthern.toBoolList(12),
      monthsAvailableSouthern: monthsSouthern.toBoolList(12),
      timesAvailable: times.toBoolList(24, offByOne: false),
      location: map["availability"]["location"] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      BugTable.colId: id,
      BugTable.colName: name,
      BugTable.colImageUri: imageUri,
      BugTable.colThumbnailUri: thumbnailUri,
      BugTable.colSellPrice: sellPrice,
      BugTable.colFound: found.toInt(),
      BugTable.colDonated: donated.toInt(),
      BugTable.colMonthsAvailableNorthern: monthsAvailableNorthern.toInt(),
      BugTable.colMonthsAvailableSouthern: monthsAvailableSouthern.toInt(),
      BugTable.colTimesAvailable: timesAvailable.toInt(),
      BugTable.colLocation: location,
    };
  }
}
