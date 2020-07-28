import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/fossil.dart';
import 'package:acnh_helper/provider/fossils_provider.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_screen.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/ui/filter/filter_by_button.dart';
import 'package:acnh_helper/ui/filter/sort_ascending_button.dart';
import 'package:acnh_helper/ui/filter/sort_by_button.dart';
import 'package:acnh_helper/utils.dart';

class FossilScreen extends BaseScreen<FossilsProvider, Fossil> {
  @override
  String get name => "Fossils";

  @override
  String get itemType => ItemType.fossils;

  @override
  String getSearchLabel() => "Search fossils";

  @override
  String getSearchSuggestionLabel() => "Filter fossils by name";

  @override
  String getSearchFailureLabel() => "No fossils found";

  @override
  List<String> getSearchFilters(Fossil item) => [
    item.name,
  ];

  @override
  List<Widget> getFilterByWidgets(BuildContext context) => [
    FilterByFoundButton(itemType: itemType),
    FilterByDonatedButton(itemType: itemType),
  ];

  @override
  List<Widget> getSortByWidgets(BuildContext context) => [
    SortAscendingButton(),
    SortByButton(
      itemType: itemType,
      values: [
        SortBy.InGameOrder,
        SortBy.Name,
        SortBy.SellPrice,
      ],
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    if (Provider.of<FossilsProvider>(context, listen: false).items.isEmpty) {
      Provider.of<FossilsProvider>(context, listen: false).loadItems();
      return;
    }

    final response = await api.getFossils();
    if (response.ok) {
      final maps = json.decode(response.body);
      var networkItems = List.generate(maps.length, (i) {
        return Fossil.fromNetworkMap(i + 1, maps[i]);
      });
      final dbItems = Provider.of<FossilsProvider>(context, listen: false).items;

      for (int i = 0; i < dbItems.length; i++) {
        var dbItem = dbItems[i];
        var j = networkItems.indexWhere((item) => item.id == dbItem.id);
        var item = networkItems[j]
          ..found = dbItem.found
          ..donated = dbItem.donated;
        networkItems[j] = item;
      }

      Provider.of<FossilsProvider>(context, listen: false).updateAllItems(networkItems);
    }
  }

  @override
  void navigateToDetailsScreen(BuildContext context, Fossil item) {
    Navigator.of(context).pushNamed(
      Routes.fossilDetails,
      arguments: item.id,
    );
  }

  @override
  List<InfoChip> listInformationWidgets(BuildContext context, Fossil item) {
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
    ];
  }

  @override
  List<InfoBadge> gridInformationWidgets(BuildContext context, Fossil item) {
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
    ];
  }
}