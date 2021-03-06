import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/bug.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/bugs_provider.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/ui/common/base_screen.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/ui/filter/filter_by_button.dart';
import 'package:acnh_helper/ui/filter/sort_ascending_button.dart';
import 'package:acnh_helper/ui/filter/sort_by_button.dart';
import 'package:acnh_helper/utils.dart';

class BugScreen extends BaseScreen<BugsProvider, Bug> {
  @override
  String get name => "Bugs";

  @override
  String get itemType => ItemType.bugs;

  @override
  String getSearchLabel() => "Search bugs";

  @override
  String getSearchSuggestionLabel() => "Filter bugs by name and location";

  @override
  String getSearchFailureLabel() => "No bugs found";

  @override
  List<String> getSearchFilters(Bug item) => [
    item.name,
    item.location,
  ];

  @override
  List<Widget> getFilterByWidgets(BuildContext context) => [
    FilterByFoundButton(itemType: itemType),
    FilterByDonatedButton(itemType: itemType),
    FilterByCurrentlyAvailable(itemType: itemType),
    FilterByNewlyAvailable(itemType: itemType),
    FilterByLeavingSoon(itemType: itemType),
  ];

  @override
  List<Widget> getSortByWidgets(BuildContext context) => [
    SortAscendingButton(itemType: itemType),
    SortByButton(
      itemType: itemType,
      values: [
        SortBy.InGameOrder,
        SortBy.Name,
        SortBy.Location,
        SortBy.SellPrice,
      ],
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<BugsProvider>(context, listen: false);
    if (provider.items.isEmpty) {
      provider.loadItems();
      return;
    }

    final response = await api.getBugs();
    if (response.ok) {
      final maps = json.decode(response.body);
      var networkItems = List.generate(maps.length, (i) {
        return Bug.fromNetworkMap(maps[i]);
      });
      final dbItems = provider.items;

      for (int i = 0; i < dbItems.length; i++) {
        var dbItem = dbItems[i];
        var j = networkItems.indexWhere((item) => item.id == dbItem.id);
        var item = networkItems[j]
          ..found = dbItem.found
          ..donated = dbItem.donated;
        networkItems[j] = item;
      }

      provider.updateAllItems(networkItems);
    }
  }

  @override
  void navigateToDetailsScreen(BuildContext context, Bug item) {
    Navigator.of(context).pushNamed(
      Routes.bugDetails,
      arguments: item.id,
    );
  }

  @override
  List<InfoChip> listInformationWidgets(BuildContext context, Bug item) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: true);
    final calendarOptions = prefs.calendarOptions;
    final isCurrentlyAvailable = item.isCurrentlyAvailable(calendarOptions);
    final isNewlyAvailable = item.isNewlyAvailable(calendarOptions);
    final isLeavingSoon = item.isLeavingSoon(calendarOptions);

    return [
      InfoChip(
        title: "Found",
        color: prefs.foundColor,
        visible: item.found,
      ),
      InfoChip(
        title: "Donated",
        color: prefs.donatedColor,
        visible: item.donated,
      ),
      InfoChip(
        title: "Available",
        color: prefs.currentlyAvailableColor,
        visible: isCurrentlyAvailable && !(isNewlyAvailable || isLeavingSoon),
      ),
      InfoChip(
        title: "New",
        color: prefs.newlyAvailableColor,
        visible: isNewlyAvailable,
      ),
      InfoChip(
        title: "Leaving soon",
        color: prefs.leavingSoonColor,
        visible: isLeavingSoon,
      ),
    ];
  }

  @override
  List<InfoBadge> gridInformationWidgets(BuildContext context, Bug item) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: true);
    final calendarOptions = prefs.calendarOptions;
    final isCurrentlyAvailable = item.isCurrentlyAvailable(calendarOptions);
    final isNewlyAvailable = item.isNewlyAvailable(calendarOptions);
    final isLeavingSoon = item.isLeavingSoon(calendarOptions);

    return [
      InfoBadge(
        color: prefs.foundColor,
        visible: item.found && !item.donated,
        alignment: Alignment.topRight,
      ),
      InfoBadge(
        color: prefs.donatedColor,
        visible: item.donated,
        alignment: Alignment.topRight,
      ),
      InfoBadge(
        color: prefs.currentlyAvailableColor,
        visible: isCurrentlyAvailable && !(isNewlyAvailable || isLeavingSoon),
        alignment: Alignment.topLeft,
      ),
      InfoBadge(
        color: prefs.newlyAvailableColor,
        visible: isNewlyAvailable,
        alignment: Alignment.topLeft,
      ),
      InfoBadge(
        color: prefs.leavingSoonColor,
        visible: isLeavingSoon,
        alignment: Alignment.topLeft,
      ),
    ];
  }
}