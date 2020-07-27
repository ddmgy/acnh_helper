import 'package:acnh_helper/database/table/base_table.dart';

class FishTable extends BaseTable {
  static get table => "fishes";

  static get colId => "id";

  static get colName => "name";

  static get colImageUri => "image_uri";

  static get colThumbnailUri => "thumbnail_uri";

  static get colSellPrice => "sell_price";

  static get colFound => "found";

  static get colDonated => "donated";

  static get colMonthsAvailableNorthern => "months_available_northern";

  static get colMonthsAvailableSouthern => "months_available_southern";

  static get colTimesAvailable => "times_available";

  static get colLocation => "location";

  static get colShadow => "shadow";
}