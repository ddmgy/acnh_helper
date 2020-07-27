import 'package:acnh_helper/database/table/sea_creature_table.dart';
import 'package:acnh_helper/model/mappable.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/utils.dart';

class SeaCreature implements Mappable, CommonTraits, DonatableTraits, AvailabilityTraits, ShadowTraits, SeaCreatureTraits {
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
  String shadow;
  String speed;

  SeaCreature({
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
    this.shadow,
    this.speed,
  });

  @override
  SeaCreature copyWith({bool found, bool donated}) {
    return SeaCreature(
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
      shadow: this.shadow,
      speed: this.speed,
    );
  }

  @override
  factory SeaCreature.fromMap(Map<String, dynamic> map) {
    return SeaCreature(
      id: map[SeaCreatureTable.colId] as int,
      name: map[SeaCreatureTable.colName] as String,
      imageUri: map[SeaCreatureTable.colImageUri] as String,
      thumbnailUri: map[SeaCreatureTable.colThumbnailUri] as String,
      sellPrice: map[SeaCreatureTable.colSellPrice] as int,
      found: (map[SeaCreatureTable.colFound] as int).toBool(),
      donated: (map[SeaCreatureTable.colDonated] as int).toBool(),
      monthsAvailableNorthern: (map[SeaCreatureTable.colMonthsAvailableNorthern] as int).toBoolList(12),
      monthsAvailableSouthern: (map[SeaCreatureTable.colMonthsAvailableSouthern] as int).toBoolList(12),
      timesAvailable: (map[SeaCreatureTable.colTimesAvailable] as int).toBoolList(24),
      shadow: map[SeaCreatureTable.colShadow] as String,
      speed: map[SeaCreatureTable.colSpeed] as String,
    );
  }

  /// Create `SeaCreature` instance from map returned by API.
  @override
  factory SeaCreature.fromNetworkMap(Map<String, dynamic> map) {
    final monthsNorthern = List<int>.from(map["availability"]["month-array-northern"]);
    final monthsSouthern = List<int>.from(map["availability"]["month-array-southern"]);
    final times = List<int>.from(map["availability"]["time-array"]);

    return SeaCreature(
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
      shadow: map["shadow"] as String,
      speed: map["speed"] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      SeaCreatureTable.colId: id,
      SeaCreatureTable.colName: name,
      SeaCreatureTable.colImageUri: imageUri,
      SeaCreatureTable.colThumbnailUri: thumbnailUri,
      SeaCreatureTable.colSellPrice: sellPrice,
      SeaCreatureTable.colFound: found.toInt(),
      SeaCreatureTable.colDonated: donated.toInt(),
      SeaCreatureTable.colMonthsAvailableNorthern: monthsAvailableNorthern.toInt(),
      SeaCreatureTable.colMonthsAvailableSouthern: monthsAvailableSouthern.toInt(),
      SeaCreatureTable.colTimesAvailable: timesAvailable.toInt(),
      SeaCreatureTable.colShadow: shadow,
      SeaCreatureTable.colSpeed: speed,
    };
  }
}
