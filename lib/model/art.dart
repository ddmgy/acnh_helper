import 'package:acnh_helper/database/table/art_table.dart';
import 'package:acnh_helper/model/mappable.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/utils.dart';

class Art implements Mappable, CommonTraits, ArtTraits, DonatableTraits {
  int id;
  String name;
  String imageUri;
  String thumbnailUri;
  bool hasFake;
  int buyPrice;
  int sellPrice;
  bool found;
  bool donated;

  Art({
    this.id,
    this.name,
    this.imageUri,
    this.thumbnailUri,
    this.hasFake,
    this.buyPrice,
    this.sellPrice,
    this.found,
    this.donated,
  });

  @override
  Art copyWith({bool found, bool donated}) {
    return Art(
      id: this.id,
      name: this.name,
      imageUri: this.imageUri,
      thumbnailUri: this.thumbnailUri,
      hasFake: this.hasFake,
      buyPrice: this.buyPrice,
      sellPrice: this.sellPrice,
      found: found ?? this.found,
      donated: donated ?? this.donated,
    );
  }

  @override
  factory Art.fromMap(Map<String, dynamic> map) {
    return Art(
      id: map[ArtTable.colId] as int,
      name: map[ArtTable.colName] as String,
      imageUri: map[ArtTable.colImageUri] as String,
      thumbnailUri: map[ArtTable.colThumbnailUri] as String,
      hasFake: (map[ArtTable.colHasFake] as int).toBool(),
      buyPrice: map[ArtTable.colBuyPrice] as int,
      sellPrice: map[ArtTable.colSellPrice] as int,
      found: (map[ArtTable.colFound] as int).toBool(),
      donated: (map[ArtTable.colDonated] as int).toBool(),
    );
  }

  /// Create `Art` instance from map returned by API.
  @override
  factory Art.fromNetworkMap(Map<String, dynamic> map) {
    return Art(
      id: map["id"] as int,
      name: (map["name"]["name-USen"] as String).capitalize(),
      imageUri: map["image_uri"] as String,
      thumbnailUri: map["image_uri"] as String,
      hasFake: map["hasFake"] as bool,
      buyPrice: map["buy-price"] as int,
      sellPrice: map["sell-price"] as int,
      found: false,
      donated: false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ArtTable.colId: id,
      ArtTable.colName: name,
      ArtTable.colImageUri: imageUri,
      ArtTable.colThumbnailUri: thumbnailUri,
      ArtTable.colHasFake: hasFake.toInt(),
      ArtTable.colBuyPrice: buyPrice,
      ArtTable.colSellPrice: sellPrice,
      ArtTable.colFound: found.toInt(),
      ArtTable.colDonated: donated.toInt(),
    };
  }
}
