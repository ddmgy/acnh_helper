import 'package:acnh_helper/database/table/base_table.dart';

class VillagerTable extends BaseTable {
  static get table => "villagers";

  static get colId => "id";

  static get colName => "name";

  static get colImageUri => "image_uri";

  static get colThumbnailUri => "thumbnail_uri";

  static get colPersonality => "personality";

  static get colBirthday => "birthday";

  static get colBirthdayString => "birthday_string";

  static get colSpecies => "species";

  static get colGender => "gender";

  static get colIsNeighbor => "is_neighbor";
}