import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/villager.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/provider/villagers_provider.dart';
import 'package:acnh_helper/ui/common/base_details_screen.dart';
import 'package:acnh_helper/utils.dart';

class VillagerDetailsScreen extends BaseDetailsScreen<VillagersProvider, Villager> {
  @override
  String get itemType => ItemType.villagers;

  VillagerDetailsScreen({int itemId}): super(itemId: itemId);

  @override
  List<InfoButton> interactiveWidgets(BuildContext context, Villager item) {
    final theme = Theme.of(context);
    final prefs = Provider.of<PreferencesProvider>(context, listen: true);

    return [
      InfoButton(
        title: "Neighbor",
        color: item.isNeighbor ? prefs.neighborColor : theme.disabledColor,
        onPressed: () {
          Provider.of<VillagersProvider>(context, listen: false).updateItem(
            item.copyWith(
              isNeighbor: !item.isNeighbor,
            ),
          );
        },
      ),
    ];
  }

  @override
  List<InfoCard> informationWidgets(BuildContext context, Villager item) => [
    InfoCard(
      title: "Personality",
      subtitle: item.personality,
    ),
    InfoCard(
      title: "Birthday",
      subtitle: item.birthday,
    ),
    InfoCard(
      title: "Species",
      subtitle: item.species,
    ),
    InfoCard(
      title: "Gender",
      subtitle: item.gender,
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<VillagersProvider>(context, listen: false);
    final dbItem = provider.items.firstWhere((villager) => villager.id == itemId, orElse: () => null);
    if (dbItem == null) {
      return;
    }

    final response = await api.getVillagers(id: itemId);
    if (response.ok) {
      final networkItem = Villager.fromNetworkMap(json.decode(response.body))
        ..isNeighbor = dbItem.isNeighbor;
      provider.updateItem(networkItem);
    }
  }
}