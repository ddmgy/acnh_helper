import 'package:acnh_helper/database/table/villager_table.dart';
import 'package:acnh_helper/model/mappable.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/utils.dart';

class Villager implements Mappable, CommonTraits, VillagerTraits {
  int id;
  String name;
  String imageUri;
  String thumbnailUri;
  String personality;
  String birthday;
  String birthdayString;
  String species;
  String gender;
  bool isNeighbor;

  Villager({
    this.id,
    this.name,
    this.imageUri,
    this.thumbnailUri,
    this.personality,
    this.birthday,
    this.birthdayString,
    this.species,
    this.gender,
    this.isNeighbor,
  });

  @override
  Villager copyWith({bool isNeighbor}) {
    return Villager(
      id: this.id,
      name: this.name,
      imageUri: this.imageUri,
      thumbnailUri: this.thumbnailUri,
      personality: this.personality,
      birthday: this.birthday,
      birthdayString: this.birthdayString,
      species: this.species,
      gender: this.gender,
      isNeighbor: isNeighbor ?? this.isNeighbor,
    );
  }

  @override
  factory Villager.fromMap(Map<String, dynamic> map) {
    return Villager(
      id: map[VillagerTable.colId] as int,
      name: map[VillagerTable.colName] as String,
      imageUri: map[VillagerTable.colImageUri] as String,
      thumbnailUri: map[VillagerTable.colThumbnailUri] as String,
      personality: map[VillagerTable.colPersonality] as String,
      birthday: map[VillagerTable.colBirthday] as String,
      birthdayString: map[VillagerTable.colBirthdayString] as String,
      species: map[VillagerTable.colSpecies] as String,
      gender: map[VillagerTable.colGender] as String,
      isNeighbor: (map[VillagerTable.colIsNeighbor] as int).toBool(),
    );
  }

  /// Create `Villager` instance from map returned by API.
  @override
  factory Villager.fromNetworkMap(Map<String, dynamic> map) {
    return Villager(
      id: map["id"] as int,
      name: (map["name"]["name-USen"] as String).capitalize(),
      imageUri: map["image_uri"] as String,
      thumbnailUri: map["icon_uri"] as String,
      personality: map["personality"] as String,
      birthday: (map["birthday"] as String).reverseDate(),
      birthdayString: map["birthday-string"] as String,
      species: map["species"] as String,
      gender: map["gender"] as String,
      isNeighbor: false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      VillagerTable.colId: id,
      VillagerTable.colName: name,
      VillagerTable.colImageUri: imageUri,
      VillagerTable.colThumbnailUri: thumbnailUri,
      VillagerTable.colPersonality: personality,
      VillagerTable.colBirthday: birthday,
      VillagerTable.colBirthdayString: birthdayString,
      VillagerTable.colSpecies: species,
      VillagerTable.colGender: gender,
      VillagerTable.colIsNeighbor: isNeighbor.toInt(),
    };
  }
}
