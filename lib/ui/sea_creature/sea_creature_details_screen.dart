import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/model/sea_creature.dart';
import 'package:acnh_helper/provider/sea_creatures_provider.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_details_screen.dart';
import 'package:acnh_helper/ui/common/months_available.dart';
import 'package:acnh_helper/ui/common/times_available.dart';
import 'package:acnh_helper/utils.dart';

class SeaCreatureDetailsScreen extends BaseDetailsScreen<SeaCreaturesProvider, SeaCreature> {
  SeaCreatureDetailsScreen({int itemId}): super(itemId: itemId);

  @override
  List<InfoButton> interactiveWidgets(BuildContext context, SeaCreature item) {
    final theme = Theme.of(context);
    return [
      InfoButton(
        title: "Found",
        color: item.found ? AppColors.foundColor : theme.disabledColor,
        onPressed: () {
          Provider.of<SeaCreaturesProvider>(context, listen: false).updateItem(
            item.copyWith(
              found: !item.found,
            ),
          );
        },
      ),
      InfoButton(
        title: "Donated",
        color: item.donated ? AppColors.donatedColor : theme.disabledColor,
        onPressed: () {
          Provider.of<SeaCreaturesProvider>(context, listen: false).updateItem(
            item.copyWith(
              found: !item.donated ? true : item.found,
              donated: !item.donated,
            ),
          );
        },
      ),
    ];
  }

  @override
  List<InfoCard> informationWidgets(BuildContext context, SeaCreature item) => [
    InfoCard(
      title: "Northern hemisphere",
      child: MonthsAvailable(
        item: item,
        hemisphere: Hemisphere.Northern,
      ),
    ),
    InfoCard(
      title: "Southern hemisphere",
      child: MonthsAvailable(
        item: item,
        hemisphere: Hemisphere.Southern,
      ),
    ),
    InfoCard(
      title: "Times available",
      child: TimesAvailable(
        item: item,
      ),
    ),
    InfoCard(
      title: "Speed",
      subtitle: item.speed,
    ),
    InfoCard(
      title: "Shadow",
      subtitle: item.shadow,
    ),
    InfoCard(
      title: "Sell price",
      subtitle: "${item.sellPrice}",
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<SeaCreaturesProvider>(context, listen: false);
    final dbItem = provider.items.firstWhere((seaCreature) => seaCreature.id == itemId, orElse: () => null);
    if (dbItem == null) {
      return;
    }

    final response = await api.getSeaCreatures(id: itemId);
    if (response.ok) {
      final networkItem = SeaCreature.fromNetworkMap(json.decode(response.body))
        ..found = dbItem.found
        ..donated = dbItem.donated;
      provider.updateItem(networkItem);
    }
  }
}