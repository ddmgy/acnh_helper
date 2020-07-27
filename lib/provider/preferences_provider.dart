import 'package:flutter/material.dart';

import 'package:acnh_helper/calendar_options.dart';
import 'package:acnh_helper/filter_type.dart';
import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/preference/preferences_helper.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/theme/theme_type.dart';

// TODO: Customize light theme
ThemeData _lightTheme = ThemeData.light().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

// TODO: Customize dark theme
ThemeData _darkTheme = ThemeData.dark().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper _prefs = PreferencesHelper.instance;

  ThemeType _themeType = ThemeType.Light;
  ThemeType get themeType => _themeType;
  set themeType(ThemeType newThemeType) {
    if (newThemeType == _themeType || newThemeType == null) {
      return;
    }
    _themeType = newThemeType;
    notifyListeners();
    _prefs.setTheme(_themeType);
  }

  ThemeData get theme {
    switch (_themeType) {
      case ThemeType.Light:
        return _lightTheme;
      case ThemeType.Dark:
        return _darkTheme;
    }
    throw Exception("unreachable");
  }

  int _lastUsedPage = 0;
  int get lastUsedPage => _lastUsedPage;
  set lastUsedPage(int newLastUsedPage) {
    if (newLastUsedPage == _lastUsedPage) {
      return;
    }
    _lastUsedPage = newLastUsedPage;
    notifyListeners();
    _prefs.setLastUsedPage(_lastUsedPage);
  }

  bool _showAsList = true;
  bool get showAsList => _showAsList;
  set showAsList(bool newShowAsList) {
    if (newShowAsList == _showAsList) {
      return;
    }
    _showAsList = newShowAsList;
    notifyListeners();
    _prefs.setShowAsList(_showAsList);
  }

  int _preferredMonth = 0;
  int get preferredMonth => _preferredMonth;
  set preferredMonth(int newPreferredMonth) {
    if (newPreferredMonth == _preferredMonth) {
      return;
    }
    _preferredMonth = newPreferredMonth;
    _updateCalendarOptions();
    notifyListeners();
    _prefs.setPreferredMonth(_preferredMonth);
  }

  Hemisphere _preferredHemisphere = Hemisphere.Northern;
  Hemisphere get preferredHemisphere => _preferredHemisphere;
  set preferredHemisphere(Hemisphere newPreferredHemisphere) {
    if (newPreferredHemisphere == _preferredHemisphere) {
      return;
    }
    _preferredHemisphere = newPreferredHemisphere;
    _updateCalendarOptions();
    notifyListeners();
    _prefs.setPreferredHemisphere(_preferredHemisphere);
  }

  CalendarOptions _calendarOptions;
  CalendarOptions get calendarOptions => _calendarOptions;

  void _updateCalendarOptions() {
    _calendarOptions = CalendarOptions(
      month: _preferredMonth,
      hemisphere: _preferredHemisphere,
    );
  }

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;
  set sortAscending(bool newSortAscending) {
    if (newSortAscending == _sortAscending) {
      return;
    }
    _sortAscending = newSortAscending;
    notifyListeners();
    _prefs.setSortAscending(_sortAscending);
  }

  Map<String, SortBy> _sortBys = {};

  SortBy getSortBy(String itemType) {
    return _sortBys.containsKey(itemType) ? _sortBys[itemType] : SortBy.InGameOrder;
  }

  Future<void> setSortBy(String itemType, SortBy sortBy) async {
    await _prefs.setSortBy(itemType, sortBy);
    _sortBys[itemType] = sortBy;
    notifyListeners();
  }

  Map<String, bool> _filterBys = {};

  bool getFilterBy(String filterType) {
    return _filterBys.containsKey(filterType) ? _filterBys[filterType] : null;
  }

  Future<void> setFilterBy(String filterType, bool filterBy) async {
    await _prefs.setFilterBy(filterType, filterBy);
    _filterBys[filterType] = filterBy;
    notifyListeners();
  }

  Map<String, bool> _sortByTileExpanded = {};

  bool getSortByTileExpanded(String itemType) {
    return _sortByTileExpanded.containsKey(itemType) ? _sortByTileExpanded[itemType] : false;
  }

  Future<void> setSortByTileExpanded(String itemType, bool sortByTileExpanded) async {
    await _prefs.setSortByTileExpanded(itemType, sortByTileExpanded);
    _sortByTileExpanded[itemType] = sortByTileExpanded;
    notifyListeners();
  }

  Map<String, bool> _filterByTileExpanded = {};

  bool getFilterByTileExpanded(String itemType) {
    return _filterByTileExpanded.containsKey(itemType) ? _filterByTileExpanded[itemType] : false;
  }

  Future<void> setFilterByTileExpanded(String itemType, bool filterByTileExpanded) async {
    await _prefs.setFilterByTileExpanded(itemType, filterByTileExpanded);
    _filterByTileExpanded[itemType] = filterByTileExpanded;
    notifyListeners();
  }

  PreferencesProvider() {
    _initPreferences();
  }

  void _initPreferences() async {
    _themeType = await _prefs.getTheme();
    _lastUsedPage = await _prefs.getLastUsedPage();
    _showAsList = await _prefs.getShowAsList();
    _preferredMonth = await _prefs.getPreferredMonth();
    _preferredHemisphere = await _prefs.getPreferredHemisphere();
    _updateCalendarOptions();
    _sortAscending = await _prefs.getSortAscending();
    for (var itemType in ItemType.all) {
      _sortBys[itemType] = await _prefs.getSortBy(itemType);
      _sortByTileExpanded[itemType] = await _prefs.getSortByTileExpanded(itemType);
      _filterByTileExpanded[itemType] = await _prefs.getFilterByTileExpanded(itemType);
    }
    for (var filterType in FilterType.all) {
      _filterBys[filterType] = await _prefs.getFilterBy(filterType);
    }
    notifyListeners();
  }

  void clear() async {
    await _prefs.clear();
    _sortBys.clear();
    _filterBys.clear();
    _sortByTileExpanded.clear();
    _filterByTileExpanded.clear();
    _initPreferences();
  }
}