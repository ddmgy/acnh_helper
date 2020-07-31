import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/model/fossil.dart';
import 'package:acnh_helper/provider/fossils_provider.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_details_screen.dart';
import 'package:acnh_helper/utils.dart';

class FossilDetailsScreen extends BaseDetailsScreen<FossilsProvider, Fossil> {
  FossilDetailsScreen({int itemId}): super(itemId: itemId);

  @override
  List<InfoButton> interactiveWidgets(BuildContext context, Fossil item) {
    final theme = Theme.of(context);
    return [
      InfoButton(
        title: "Found",
        color: item.found ? AppColors.foundColor : theme.disabledColor,
        onPressed: () {
          Provider.of<FossilsProvider>(context, listen: false).updateItem(
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
          Provider.of<FossilsProvider>(context, listen: false).updateItem(
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
  List<InfoCard> informationWidgets(BuildContext context, Fossil item) => [
    InfoCard(
      title: "Sell price",
      subtitle: "${item.sellPrice}",
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<FossilsProvider>(context, listen: false);
    final dbItem = provider.items.firstWhere((fossil) => fossil.id == itemId, orElse: () => null);
    if (dbItem == null) {
      return;
    }

    final response = await api.getFossils(id: itemId);
    if (response.ok) {
      final networkItem = Fossil.fromNetworkMap(itemId, json.decode(response.body))
        ..found = dbItem.found
        ..donated = dbItem.donated;
      provider.updateItem(networkItem);
    }
  }
}