import 'package:acnh_helper/database/table/fish_table.dart';
import 'package:acnh_helper/model/mappable.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/utils.dart';

class Fish implements Mappable, CommonTraits, DonatableTraits, AvailabilityTraits, LocationTraits, ShadowTraits {
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
  String shadow;

  Fish({
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
    this.shadow,
  });

  @override
  Fish copyWith({bool found, bool donated}) {
    return Fish(
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
      shadow: this.shadow,
    );
  }

  @override
  factory Fish.fromMap(Map<String, dynamic> map) {
    return Fish(
      id: map[FishTable.colId] as int,
      name: map[FishTable.colName] as String,
      imageUri: map[FishTable.colImageUri] as String,
      thumbnailUri: map[FishTable.colThumbnailUri] as String,
      sellPrice: map[FishTable.colSellPrice] as int,
      found: (map[FishTable.colFound] as int).toBool(),
      donated: (map[FishTable.colDonated] as int).toBool(),
      monthsAvailableNorthern: (map[FishTable.colMonthsAvailableNorthern] as int).toBoolList(12),
      monthsAvailableSouthern: (map[FishTable.colMonthsAvailableSouthern] as int).toBoolList(12),
      timesAvailable: (map[FishTable.colTimesAvailable] as int).toBoolList(24),
      location: map[FishTable.colLocation] as String,
      shadow: map[FishTable.colShadow] as String,
    );
  }

  /// Create `Fish` instance from map returned by API.
  @override
  factory Fish.fromNetworkMap(Map<String, dynamic> map) {
    final monthsNorthern = List<int>.from(map["availability"]["month-array-northern"]);
    final monthsSouthern = List<int>.from(map["availability"]["month-array-southern"]);
    final times = List<int>.from(map["availability"]["time-array"]);

    return Fish(
      id: map["id"] as int,
      name: (map["name"]["name-USen"] as String).capitalize(),
      imageUri: map["image_uri"] as String,
      thumbnailUri: map["icon_uri"] as String,
      sellPrice: map["price"] as int,
      found: false,
      donated: false,
      monthsAvailableNorthern: monthsNorthern.toBoolList(12),
      monthsAvailableSouthern: monthsSouthern.toBoolList(12),
      timesAvailable: times.toBoolList(24),
      location: map["availability"]["location"] as String,
      shadow: map["shadow"] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      FishTable.colId: id,
      FishTable.colName: name,
      FishTable.colImageUri: imageUri,
      FishTable.colThumbnailUri: thumbnailUri,
      FishTable.colSellPrice: sellPrice,
      FishTable.colFound: found.toInt(),
      FishTable.colDonated: donated.toInt(),
      FishTable.colMonthsAvailableNorthern: monthsAvailableNorthern.toInt(),
      FishTable.colMonthsAvailableSouthern: monthsAvailableSouthern.toInt(),
      FishTable.colTimesAvailable: timesAvailable.toInt(),
      FishTable.colLocation: location,
      FishTable.colShadow: shadow,
    };
  }
}
