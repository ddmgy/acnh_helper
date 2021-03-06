import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/month.dart';
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

  Future<bool> getShowAsList(String itemType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.showAsList(itemType)) ?? true;
  }

  Future<void> setShowAsList(String itemType, bool showAsList) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.showAsList(itemType), showAsList);
  }

  Future<bool> getFirstFetch(String itemType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.firstFetch(itemType)) ?? true;
  }

  Future<void> setFirstFetch(String itemType, bool firstFetch) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.firstFetch(itemType), firstFetch);
  }

  Future<Month> getPreferredMonth() async {
    final prefs = await preferences;
    return (prefs.getInt(PreferenceKeys.preferredMonth) ?? 0).toMonth();
  }

  Future<void> setPreferredMonth(Month preferredMonth) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.preferredMonth, preferredMonth.toInt());
  }

  Future<Hemisphere> getPreferredHemisphere() async {
    final prefs = await preferences;
    return (prefs.getInt(PreferenceKeys.preferredHemisphere) ?? 0).toHemisphere();
  }

  Future<void> setPreferredHemisphere(Hemisphere preferredHemisphere) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.preferredHemisphere, preferredHemisphere.toInt());
  }

  Future<bool> getSortAscending(String itemType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.sortAscending(itemType)) ?? true;
  }

  Future<void> setSortAscending(String itemType, bool sortAscending) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.sortAscending(itemType), sortAscending);
  }

  Future<SortBy> getSortBy(String itemType) async {
    final prefs = await preferences;
    return (prefs.getInt(PreferenceKeys.sortBy(itemType)) ?? 0).toSortBy();
  }

  Future<void> setSortBy(String itemType, SortBy sortBy) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.sortBy(itemType), sortBy.toInt());
  }

  Future<bool> getFilterBy(String itemType, String filterType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.filterBy(itemType, filterType));
  }

  Future<void> setFilterBy(String itemType, String filterType, bool filterBy) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.filterBy(itemType, filterType), filterBy);
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

  Future<bool> getCalendarTileExpanded(String itemType) async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.calendarTileExpanded(itemType)) ?? false;
  }

  Future<void> setCalendarTileExpanded(String itemType, bool calendarTileExpanded) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.calendarTileExpanded(itemType), calendarTileExpanded);
  }

  Future<bool> getShowMonthsAsString() async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.showMonthsAsString) ?? true;
  }

  Future<void> setShowMonthsAsString(bool showMonthsAsString) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.showMonthsAsString, showMonthsAsString);
  }

  Future<bool> getShowTimeAsString() async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.showTimeAsString) ?? true;
  }

  Future<void> setShowTimeAsString(bool showTimeAsString) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.showTimeAsString, showTimeAsString);
  }

  Future<bool> getShowTimeAs12Hour() async {
    final prefs = await preferences;
    return prefs.getBool(PreferenceKeys.showTimeAs12Hour) ?? true;
  }

  Future<void> setShowTimeAs12Hour(bool showTimeAs12Hour) async {
    final prefs = await preferences;
    prefs.setBool(PreferenceKeys.showTimeAs12Hour, showTimeAs12Hour);
  }

  Future<Color> getColor(String colorType, Color defaultValue) async {
    final prefs = await preferences;
    final savedValue = prefs.getInt(PreferenceKeys.color(colorType));
    return savedValue != null ? Color(savedValue) : defaultValue;
  }

  Future<void> setColor(String colorType, Color color) async {
    final prefs = await preferences;
    prefs.setInt(PreferenceKeys.color(colorType), color.value);
  }
}

class PreferenceKeys {
  static String get theme => "theme";

  static String get lastUsedPage => "last_used_page";

  static String showAsList(String itemType) => "show_as_list_on_$itemType";

  static String firstFetch(String itemType) => "first_fetch_$itemType";

  static String get preferredMonth => "preferred_month";

  static String get preferredHemisphere => "preferred_hemisphere";

  static String sortAscending(String itemType) => "sort_ascending_on_$itemType";

  static String sortBy(String itemType) => "sort_by_$itemType";

  static String filterBy(String itemType, String filterType) => "filter_by_${filterType}_on_$itemType";

  static String sortByTileExpanded(String itemType) => "sort_by_tile_expanded_$itemType";

  static String filterByTileExpanded(String itemType) => "filter_by_tile_expanded_$itemType";

  static String calendarTileExpanded(String itemType) => "calendar_tile_expanded_$itemType";

  static String get showMonthsAsString => "show_months_as_string";

  static String get showTimeAsString => "show_time_as_string";

  static String get showTimeAs12Hour => "show_time_as_12_hour";

  static String color(String colorType) => "color_$colorType";
}

class PreferenceValues {
  static List<ThemeType> get themes => ThemeType.values;
}

class PreferenceEntries {
  static List<String> get themes => PreferenceValues.themes.map((themeType) => themeType.getName()).toList();
}