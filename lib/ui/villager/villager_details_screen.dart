import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/model/villager.dart';
import 'package:acnh_helper/provider/villagers_provider.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_details_screen.dart';

class VillagerDetailsScreen extends BaseDetailsScreen<VillagersProvider, Villager> {
  @override
  List<InfoButton> interactiveWidgets(BuildContext context, Villager item) {
    final theme = Theme.of(context);
    return [
      InfoButton(
        title: "Neighbor",
        color: item.isNeighbor ? AppColors.neighborColor : theme.disabledColor,
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

  VillagerDetailsScreen({int itemId}): super(itemId: itemId);
}