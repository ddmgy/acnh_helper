import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/fish.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/fishes_provider.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_screen.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/ui/filter/filter_by_button.dart';
import 'package:acnh_helper/ui/filter/sort_ascending_button.dart';
import 'package:acnh_helper/ui/filter/sort_by_button.dart';
import 'package:acnh_helper/utils.dart';

class FishScreen extends BaseScreen<FishesProvider, Fish> {
  @override
  String get name => "Fish";

  @override
  String get itemType => ItemType.fishes;

  @override
  String getSearchLabel() => "Search fish";

  @override
  String getSearchSuggestionLabel() => "Filter fish by name, location, and shadow";

  @override
  String getSearchFailureLabel() => "No fish found";

  @override
  List<String> getSearchFilters(Fish item) => [
    item.name,
    item.location,
    item.shadow,
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
        SortBy.Shadow,
        SortBy.SellPrice,
      ],
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<FishesProvider>(context, listen: false);
    if (provider.items.isEmpty) {
      provider.loadItems();
      return;
    }

    final response = await api.getFishes();
    if (response.ok) {
      final maps = json.decode(response.body);
      var networkItems = List.generate(maps.length, (i) {
        return Fish.fromNetworkMap(maps[i]);
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
  void navigateToDetailsScreen(BuildContext context, Fish item) {
    Navigator.of(context).pushNamed(
      Routes.fishDetails,
      arguments: item.id,
    );
  }

  @override
  List<InfoChip> listInformationWidgets(BuildContext context, Fish item) {
    final calendarOptions = Provider.of<PreferencesProvider>(context, listen: false).calendarOptions;
    final isCurrentlyAvailable = item.isCurrentlyAvailable(calendarOptions);
    final isNewlyAvailable = item.isNewlyAvailable(calendarOptions);
    final isLeavingSoon = item.isLeavingSoon(calendarOptions);

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
        visible: isCurrentlyAvailable && !(isNewlyAvailable || isLeavingSoon),
      ),
      InfoChip(
        title: "New",
        color: AppColors.newlyAvailableColor,
        visible: isNewlyAvailable,
      ),
      InfoChip(
        title: "Leaving soon",
        color: AppColors.leavingSoonColor,
        visible: isLeavingSoon,
      ),
    ];
  }

  @override
  List<InfoBadge> gridInformationWidgets(BuildContext context, Fish item) {
    final calendarOptions = Provider.of<PreferencesProvider>(context, listen: false).calendarOptions;
    final isCurrentlyAvailable = item.isCurrentlyAvailable(calendarOptions);
    final isNewlyAvailable = item.isNewlyAvailable(calendarOptions);
    final isLeavingSoon = item.isLeavingSoon(calendarOptions);

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
        visible: isCurrentlyAvailable && !(isNewlyAvailable || isLeavingSoon),
        alignment: Alignment.topLeft,
      ),
      InfoBadge(
        color: AppColors.newlyAvailableColor,
        visible: isNewlyAvailable,
        alignment: Alignment.topLeft,
      ),
      InfoBadge(
        color: AppColors.leavingSoonColor,
        visible: isLeavingSoon,
        alignment: Alignment.topLeft,
      ),
    ];
  }
}