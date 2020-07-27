import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/model/art.dart';
import 'package:acnh_helper/provider/arts_provider.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/base_details_screen.dart';

class ArtDetailsScreen extends BaseDetailsScreen<ArtsProvider, Art> {
  @override
  List<InfoButton> interactiveWidgets(BuildContext context, Art item) {
    final theme = Theme.of(context);
    return [
      InfoButton(
        title: "Found",
        color: item.found ? AppColors.foundColor : theme.disabledColor,
        onPressed: () {
          Provider.of<ArtsProvider>(context, listen: false).updateItem(
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
          Provider.of<ArtsProvider>(context, listen: false).updateItem(
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
  List<InfoCard> informationWidgets(BuildContext context, Art item) => [
    InfoCard(
      title: "Buy price",
      subtitle: "${item.buyPrice} bells",
    ),
    InfoCard(
      title: "Sell price",
      subtitle: "${item.sellPrice} bells",
    ),
    InfoCard(
      title: "Has fakes?",
      subtitle: item.hasFake ? "Yes" : "No",
    ),
  ];

  ArtDetailsScreen({int itemId}): super(itemId: itemId);
}