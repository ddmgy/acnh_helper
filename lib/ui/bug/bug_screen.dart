import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/bug.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/bugs_provider.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
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
    SortAscendingButton(),
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
    if (Provider.of<BugsProvider>(context, listen: false).items.isEmpty) {
      Provider.of<BugsProvider>(context, listen: false).loadItems();
      return;
    }

    final response = await api.getBugs();
    if (response.ok) {
      final maps = json.decode(response.body);
      var networkItems = List.generate(maps.length, (i) {
        return Bug.fromNetworkMap(maps[i]);
      });
      final dbItems = Provider.of<BugsProvider>(context, listen: false).items;

      for (int i = 0; i < dbItems.length; i++) {
        var dbItem = dbItems[i];
        var j = networkItems.indexWhere((item) => item.id == dbItem.id);
        var item = networkItems[j]
          ..found = dbItem.found
          ..donated = dbItem.donated;
        networkItems[j] = item;
      }

      Provider.of<BugsProvider>(context, listen: false).updateAllItems(networkItems);
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
    final calendarOptions = Provider.of<PreferencesProvider>(context, listen: false).calendarOptions;

    return [
      InfoChip(
        title: "Found",
        color: AppColors.foundColor,
        visible: item.found,
      ),
      InfoChip(
        title: "Donated",
        color: AppColors.donatedColor,
        visible: item.donated,
      ),
      InfoChip(
        title: "Available",
        color: AppColors.currentlyAvailableColor,
        visible: item.isCurrentlyAvailable(calendarOptions),
      ),
    ];
  }

  @override
  List<InfoBadge> gridInformationWidgets(BuildContext context, Bug item) {
    final calendarOptions = Provider.of<PreferencesProvider>(context, listen: false).calendarOptions;

    return [
      InfoBadge(
        color: AppColors.foundColor,
        visible: item.found && !item.donated,
        alignment: Alignment.topRight,
      ),
      InfoBadge(
        color: AppColors.donatedColor,
        visible: item.donated,
        alignment: Alignment.topRight,
      ),
      InfoBadge(
        color: AppColors.currentlyAvailableColor,
        visible: item.isCurrentlyAvailable(calendarOptions),
        alignment: Alignment.topLeft,
      ),
    ];
  }
}