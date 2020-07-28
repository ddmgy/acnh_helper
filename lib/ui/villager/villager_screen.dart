import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/villager.dart';
import 'package:acnh_helper/provider/villagers_provider.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_screen.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/ui/filter/filter_by_button.dart';
import 'package:acnh_helper/ui/filter/sort_ascending_button.dart';
import 'package:acnh_helper/ui/filter/sort_by_button.dart';
import 'package:acnh_helper/utils.dart';

class VillagerScreen extends BaseScreen<VillagersProvider, Villager> {
  @override
  String get name => "Villagers";

  @override
  String get itemType => ItemType.villagers;

  @override
  String getSearchLabel() => "Search villagers";

  @override
  String getSearchSuggestionLabel() => "Filter villagers by name, personality, birthday, species, and gender";

  @override
  String getSearchFailureLabel() => "No villagers found";

  @override
  List<String> getSearchFilters(Villager item) => [
    item.name,
    item.personality,
    item.birthday,
    item.species,
    item.gender,
  ];

  @override
  List<Widget> getFilterByWidgets(BuildContext context) => [
    FilterByIsNeighborButton(itemType: itemType),
  ];

  @override
  List<Widget> getSortByWidgets(BuildContext context) => [
    SortAscendingButton(),
    SortByButton(
      itemType: itemType,
      values: [
        SortBy.InGameOrder,
        SortBy.Name,
        SortBy.Personality,
        SortBy.Birthday,
        SortBy.Species,
        SortBy.Gender,
      ],
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<VillagersProvider>(context, listen: false);
    if (provider.items.isEmpty) {
      provider.loadItems();
      return;
    }

    final response = await api.getVillagers();
    if (response.ok) {
      final maps = json.decode(response.body);
      var networkItems = List.generate(maps.length, (i) {
        return Villager.fromNetworkMap(maps[i]);
      });
      final dbItems = provider.items;

      for (int i = 0; i < dbItems.length; i++) {
        var dbItem = dbItems[i];
        var j = networkItems.indexWhere((item) => item.id == dbItem.id);
        var item = networkItems[j]
          ..isNeighbor = dbItem.isNeighbor;
        networkItems[j] = item;
      }

      provider.updateAllItems(networkItems);
    }
  }

  @override
  void navigateToDetailsScreen(BuildContext context, Villager item) {
    Navigator.of(context).pushNamed(
      Routes.villagerDetails,
      arguments: item.id,
    );
  }

  @override
  List<InfoChip> listInformationWidgets(BuildContext context, Villager item) {
    return [
      InfoChip(
        title: "Neighbor",
        color: AppColors.neighborColor,
        visible: item.isNeighbor,
      ),
    ];
  }

  @override
  List<InfoBadge> gridInformationWidgets(BuildContext context, Villager item) {
    return [
      InfoBadge(
        color: AppColors.neighborColor,
        visible: item.isNeighbor,
        alignment: Alignment.topRight,
      ),
    ];
  }
}