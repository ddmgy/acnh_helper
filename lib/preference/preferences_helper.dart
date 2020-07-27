import 'package:shared_preferences/shared_preferences.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/theme/theme_type.dart';

class PreferencesHelper {
  static final PreferencesHelper instance = PreferencesHelper._internal();

  static SharedPreferences _preferences;
  Future<SharedPreferences> get preferences async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _preferences;
  }

  PreferencesHelper._internal();

  Future<bool> clear() async {
    final prefs = await preferences;
    return prefs.clear();
  }

  Future<ThemeType> getTheme() async {
    final prefs = await preferences;
    return (prefs.getInt(PreferenceKeys.theme) ?? 0).toThemeType();
  }

  Future<void> setTheme(ThemeType theme) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.theme, theme.toInt());
  }

  Future<int> getLastUsedPage() async {
    final prefs = await preferences;
    return prefs.getInt(PreferenceKeys.lastUsedPage) ?? 0;
  }

  Future<void> setLastUsedPage(int lastUsedPage) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.lastUsedPage, lastUsedPage);
  }

  Future<bool> getShowAsList() async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.showAsList) ?? true;
  }

  Future<void> setShowAsList(bool showAsList) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.showAsList, showAsList);
  }

  Future<bool> getFirstFetch(String itemType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.firstFetch(itemType)) ?? true;
  }

  Future<void> setFirstFetch(String itemType, bool firstFetch) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.firstFetch(itemType), firstFetch);
  }

  Future<int> getPreferredMonth() async {
    final prefs = await preferences;
    return prefs.getInt(PreferenceKeys.preferredMonth) ?? 0;
  }

  Future<void> setPreferredMonth(int preferredMonth) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.preferredMonth, preferredMonth);
  }

  Future<Hemisphere> getPreferredHemisphere() async {
    final prefs = await preferences;
    return (prefs.getInt(PreferenceKeys.preferredHemisphere) ?? 0).toHemisphere();
  }

  Future<void> setPreferredHemisphere(Hemisphere preferredHemisphere) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.preferredHemisphere, preferredHemisphere.toInt());
  }

  Future<bool> getSortAscending() async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.sortAscending) ?? true;
  }

  Future<void> setSortAscending(bool sortAscending) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.sortAscending, sortAscending);
  }

  Future<SortBy> getSortBy(String itemType) async {
    final prefs = await preferences;
    return (prefs.getInt(PreferenceKeys.sortBy(itemType)) ?? 0).toSortBy();
  }

  Future<void> setSortBy(String itemType, SortBy sortBy) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.sortBy(itemType), sortBy.toInt());
  }

  Future<bool> getFilterBy(String filterType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.filterBy(filterType));
  }

  Future<void> setFilterBy(String filterType, bool filterBy) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.filterBy(filterType), filterBy);
  }

  Future<bool> getSortByTileExpanded(String itemType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.sortByTileExpanded(itemType)) ?? false;
  }

  Future<void> setSortByTileExpanded(String itemType, bool sortByTileExpanded) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.sortByTileExpanded(itemType), sortByTileExpanded);
  }

  Future<bool> getFilterByTileExpanded(String itemType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.filterByTileExpanded(itemType)) ?? false;
  }

  Future<void> setFilterByTileExpanded(String itemType, bool filterByTileExpanded) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.filterByTileExpanded(itemType), filterByTileExpanded);
  }
}

class PreferenceKeys {
  static String get theme => "theme";

  static String get lastUsedPage => "last_used_page";

  static String get showAsList => "show_as_list";

  static String firstFetch(String itemType) => "first_fetch_$itemType";

  static String get preferredMonth => "preferred_month";

  static String get preferredHemisphere => "preferred_hemisphere";

  static String get sortAscending => "sort_ascending";

  static String sortBy(String itemType) => "sort_by_$itemType";

  static String filterBy(String filterType) => "filter_by_$filterType";

  static String sortByTileExpanded(String itemType) => "sort_by_tile_expanded_$itemType";

  static String filterByTileExpanded(String itemType) => "filter_by_tile_expanded_$itemType";
}

class PreferenceValues {
  static List<ThemeType> get themes => ThemeType.values;
}

class PreferenceEntries {
  static List<String> get themes => PreferenceValues.themes.map((themeType) => themeType.getName()).toList();
}