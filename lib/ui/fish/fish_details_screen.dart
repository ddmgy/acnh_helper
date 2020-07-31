import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/model/fish.dart';
import 'package:acnh_helper/provider/fishes_provider.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_details_screen.dart';
import 'package:acnh_helper/ui/common/months_available.dart';
import 'package:acnh_helper/ui/common/times_available.dart';
import 'package:acnh_helper/utils.dart';

class FishDetailsScreen extends BaseDetailsScreen<FishesProvider, Fish> {
  FishDetailsScreen({int itemId}): super(itemId: itemId);

  @override
  List<InfoButton> interactiveWidgets(BuildContext context, Fish item) {
    final theme = Theme.of(context);
    return [
      InfoButton(
        title: "Found",
        color: item.found ? AppColors.foundColor : theme.disabledColor,
        onPressed: () {
          Provider.of<FishesProvider>(context, listen: false).updateItem(
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
          Provider.of<FishesProvider>(context, listen: false).updateItem(
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
  List<InfoCard> informationWidgets(BuildContext context, Fish item) => [
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
      title: "Location",
      subtitle: item.location,
    ),
    InfoCard(
      title: "Shadow",
      subtitle: item.shadow,
    ),
    InfoCard(
      title: "Sell price",
      subtitle: "${item.sellPrice}",
    ),
    InfoCard(
      title: "Sell price (CJ)",
      subtitle: "${(item.sellPrice * 1.5).floor()}",
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<FishesProvider>(context, listen: false);
    final dbItem = provider.items.firstWhere((fish) => fish.id == itemId, orElse: () => null);
    if (dbItem == null) {
      return;
    }

    final response = await api.getFishes(id: itemId);
    if (response.ok) {
      final networkItem = Fish.fromNetworkMap(json.decode(response.body))
        ..found = dbItem.found
        ..donated = dbItem.donated;
      provider.updateItem(networkItem);
    }
  }
}