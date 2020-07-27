import 'package:acnh_helper/database/table/fossil_table.dart';
import 'package:acnh_helper/model/mappable.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/utils.dart';

class Fossil implements Mappable, CommonTraits, DonatableTraits {
  int id;
  String name;
  String imageUri;
  String thumbnailUri;
  int sellPrice;
  bool found;
  bool donated;

  Fossil({
    this.id,
    this.name,
    this.imageUri,
    this.thumbnailUri,
    this.sellPrice,
    this.found,
    this.donated,
  });

  @override
  Fossil copyWith({bool found, bool donated}) {
    return Fossil(
      id: this.id,
      name: this.name,
      imageUri: this.imageUri,
      thumbnailUri: this.thumbnailUri,
      sellPrice: this.sellPrice,
      found: found ?? this.found,
      donated: donated ?? this.donated,
    );
  }

  @override
  factory Fossil.fromMap(Map<String, dynamic> map) {
    return Fossil(
      id: map[FossilTable.colId] as int,
      name: map[FossilTable.colName] as String,
      imageUri: map[FossilTable.colImageUri] as String,
      thumbnailUri: map[FossilTable.colThumbnailUri],
      sellPrice: map[FossilTable.colSellPrice] as int,
      found: (map[FossilTable.colFound] as int).toBool(),
      donated: (map[FossilTable.colDonated] as int).toBool(),
    );
  }

  /// Create `Fossil` instance from map returned by API.
  @override
  factory Fossil.fromNetworkMap(int id, Map<String, dynamic> map) {
    return Fossil(
      id: id,
      name: (map["name"]["name-USen"] as String).capitalize(),
      imageUri: map["image_uri"] as String,
      thumbnailUri: map["image_uri"] as String,
      sellPrice: map["price"] as int,
      found: false,
      donated: false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      FossilTable.colId: id,
      FossilTable.colName: name,
      FossilTable.colImageUri: imageUri,
      FossilTable.colThumbnailUri: thumbnailUri,
      FossilTable.colSellPrice: sellPrice,
      FossilTable.colFound: found.toInt(),
      FossilTable.colDonated: donated.toInt(),
    };
  }
}
