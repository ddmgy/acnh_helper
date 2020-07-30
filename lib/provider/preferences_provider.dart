import 'package:flutter/material.dart';

import 'package:acnh_helper/calendar_options.dart';
import 'package:acnh_helper/filter_type.dart';
import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/month.dart';
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

  Map<String, bool> _showAsLists = {};

  bool getShowAsList(String itemType) {
    return _showAsLists.containsKey(itemType) ? _showAsLists[itemType] : true;
  }

  void setShowAsList(String itemType, bool showAsList) {
    _showAsLists[itemType] = showAsList;
    notifyListeners();
    _prefs.setShowAsList(itemType, showAsList);
  }

  Month _preferredMonth = Month.Current;
  Month get preferredMonth => _preferredMonth;
  set preferredMonth(Month newPreferredMonth) {
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

  Map<String, bool> _sortAscendings = {};

  bool getSortAscending(String itemType) {
    return _sortAscendings.containsKey(itemType) ? _sortAscendings[itemType] : true;
  }

  void setSortAscending(String itemType, bool sortAscending) {
    _sortAscendings[itemType] = sortAscending;
    notifyListeners();
    _prefs.setSortAscending(itemType, sortAscending);
  }

  Map<String, SortBy> _sortBys = {};

  SortBy getSortBy(String itemType) {
    return _sortBys.containsKey(itemType) ? _sortBys[itemType] : SortBy.InGameOrder;
  }

  void setSortBy(String itemType, SortBy sortBy) {
    _sortBys[itemType] = sortBy;
    notifyListeners();
    _prefs.setSortBy(itemType, sortBy);
  }

  Map<String, bool> _filterBys = {};

  String _filterBysKey(String itemType, String filterType) => "$itemType,$filterType";

  bool getFilterBy(String itemType, String filterType) {
    final key = _filterBysKey(itemType, filterType);
    return _filterBys.containsKey(key) ? _filterBys[key] : null;
  }

  void setFilterBy(String itemType, String filterType, bool filterBy) {
    _filterBys[_filterBysKey(itemType, filterType)] = filterBy;
    notifyListeners();
    _prefs.setFilterBy(itemType, filterType, filterBy);
  }

  Map<String, bool> _sortByTileExpanded = {};

  bool getSortByTileExpanded(String itemType) {
    return _sortByTileExpanded.containsKey(itemType) ? _sortByTileExpanded[itemType] : false;
  }

  void setSortByTileExpanded(String itemType, bool sortByTileExpanded) {
    _sortByTileExpanded[itemType] = sortByTileExpanded;
    notifyListeners();
    _prefs.setSortByTileExpanded(itemType, sortByTileExpanded);
  }

  Map<String, bool> _filterByTileExpanded = {};

  bool getFilterByTileExpanded(String itemType) {
    return _filterByTileExpanded.containsKey(itemType) ? _filterByTileExpanded[itemType] : false;
  }

  void setFilterByTileExpanded(String itemType, bool filterByTileExpanded) {
    _filterByTileExpanded[itemType] = filterByTileExpanded;
    notifyListeners();
    _prefs.setFilterByTileExpanded(itemType, filterByTileExpanded);
  }

  PreferencesProvider() {
    _initPreferences();
  }

  void _initPreferences() async {
    _themeType = await _prefs.getTheme();
    _lastUsedPage = await _prefs.getLastUsedPage();
    _preferredMonth = await _prefs.getPreferredMonth();
    _preferredHemisphere = await _prefs.getPreferredHemisphere();
    _updateCalendarOptions();
    for (var itemType in ItemType.all) {
      _showAsLists[itemType] = await _prefs.getShowAsList(itemType);
      _sortAscendings[itemType] = await _prefs.getSortAscending(itemType);
      _sortBys[itemType] = await _prefs.getSortBy(itemType);
      _sortByTileExpanded[itemType] = await _prefs.getSortByTileExpanded(itemType);
      _filterByTileExpanded[itemType] = await _prefs.getFilterByTileExpanded(itemType);
      for (var filterType in FilterType.all) {
        _filterBys[_filterBysKey(itemType, filterType)] = await _prefs.getFilterBy(itemType, filterType);
      }
    }
    notifyListeners();
  }

  void clear() async {
    await _prefs.clear();
    _showAsLists.clear();
    _sortAscendings.clear();
    _sortBys.clear();
    _filterBys.clear();
    _sortByTileExpanded.clear();
    _filterByTileExpanded.clear();
    _initPreferences();
  }
}