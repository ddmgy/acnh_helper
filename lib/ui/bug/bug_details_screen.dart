import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/bug.dart';
import 'package:acnh_helper/provider/bugs_provider.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/ui/common/base_details_screen.dart';
import 'package:acnh_helper/ui/common/months_available.dart';
import 'package:acnh_helper/ui/common/times_available.dart';
import 'package:acnh_helper/utils.dart';

class BugDetailsScreen extends BaseDetailsScreen<BugsProvider, Bug> {
  @override
  String get itemType => ItemType.bugs;

  BugDetailsScreen({int itemId}): super(itemId: itemId);

  @override
  List<InfoButton> interactiveWidgets(BuildContext context, Bug item) {
    final theme = Theme.of(context);
    final prefs = Provider.of<PreferencesProvider>(context, listen: true);

    return [
      InfoButton(
        title: "Found",
        color: item.found ? prefs.foundColor : theme.disabledColor,
        onPressed: () {
          Provider.of<BugsProvider>(context, listen: false).updateItem(
            item.copyWith(
              found: !item.found,
            ),
          );
        },
      ),
      InfoButton(
        title: "Donated",
        color: item.donated ? prefs.donatedColor : theme.disabledColor,
        onPressed: () {
          Provider.of<BugsProvider>(context, listen: false).updateItem(
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
  List<InfoCard> informationWidgets(BuildContext context, Bug item) => [
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
      title: "Sell price",
      subtitle: "${item.sellPrice}",
    ),
    InfoCard(
      title: "Sell price (Flick)",
      subtitle: "${(item.sellPrice * 1.5).floor()}",
    ),
  ];

  @override
  void performRefresh(BuildContext context) async {
    final provider = Provider.of<BugsProvider>(context, listen: false);
    final dbItem = provider.items.firstWhere((bug) => bug.id == itemId, orElse: () => null);
    if (dbItem == null) {
      return;
    }

    final response = await api.getBugs(id: itemId);
    if (response.ok) {
      final networkItem = Bug.fromNetworkMap(json.decode(response.body))
        ..found = dbItem.found
        ..donated = dbItem.donated;
      provider.updateItem(networkItem);
    }
  }
}