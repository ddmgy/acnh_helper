import 'package:acnh_helper/database/table/base_table.dart';

class ArtTable extends BaseTable {
  static get table => "arts";

  static get colId => "id";

  static get colName => "name";

  static get colImageUri => "image_uri";

  static get colThumbnailUri => "thumbnail_uri";

  static get colHasFake => "has_fake";

  static get colBuyPrice => "buy_price";

  static get colSellPrice => "sell_price";

  static get colFound => "found";

  static get colDonated => "donated";
}