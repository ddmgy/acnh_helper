import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/model/sea_creature.dart';
import 'package:acnh_helper/provider/sea_creatures_provider.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_details_screen.dart';
import 'package:acnh_helper/ui/common/months_available.dart';
import 'package:acnh_helper/ui/common/times_available.dart';

class SeaCreatureDetailsScreen extends BaseDetailsScreen<SeaCreaturesProvider, SeaCreature> {
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
    InfoCard(
      title: "Sell price (Flick)",
      subtitle: "${(item.sellPrice * 1.5).floor()}",
    ),
  ];

  SeaCreatureDetailsScreen({int itemId}): super(itemId: itemId);
}