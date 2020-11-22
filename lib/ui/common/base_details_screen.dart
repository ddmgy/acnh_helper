import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:acnh_helper/acnhapi.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/museum_items_provider.dart';
import 'package:acnh_helper/ui/common/keys.dart';
import 'package:acnh_helper/ui/common/museum_item_thumbnail.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/utils.dart';

class InfoButton {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const InfoButton({
    @required this.title,
    @required this.color,
    @required this.onPressed,
  });
}

class InfoCard {
  final String title;
  final String subtitle;
  final Widget child;

  const InfoCard({
    @required this.title,
    this.subtitle,
    this.child,
  }) : assert(subtitle != null || child != null);
}

abstract class BaseDetailsScreen<P extends MuseumItemsProvider, T extends CommonTraits> extends StatelessWidget {
  final api = AcnhApi.instance;

  final int itemId;

  String get itemType;

  BaseDetailsScreen({this.itemId});

  List<InfoButton> interactiveWidgets(BuildContext context, T item) => const [];

  List<InfoCard> informationWidgets(BuildContext context, T item) => const [];

  void performRefresh(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final item = context.select<P, T>((provider) => provider.items.firstWhere((i) => i.id == itemId));

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => performRefresh(context),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return _landscape(context, item);
          } else { // Orientation.portrait
            return _portrait(context, item);
          }
        },
      ),
    );
  }

  Widget _landscape(BuildContext context, T item) {
    final theme = Theme.of(context);

    List<Widget> children = [];

    for (var button in interactiveWidgets(context, item)) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: RaisedButton(
            child: Text(
              button.title,
              style: context.titleTextStyle(),
            ),
            color: button.color,
            onPressed: button.onPressed,
          ),
        ),
      );
    }

    for (var card in informationWidgets(context, item)) {
      Widget child;
      if (card.subtitle != null) {
        child = Text(
          card.subtitle,
          style: context.subtitleTextStyle(),
          textAlign: TextAlign.end,
          maxLines: 2,
        );
      } else {
        child = card.child;
      }
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: theme.cardColor,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    card.title,
                    style: context.titleTextStyle(),
                    textAlign: TextAlign.start,
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              child: MuseumItemImage(
                imageUri: item.imageUri,
                tag: "$itemType#$itemId",
                fit: BoxFit.fitHeight,
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              key: Keys.detailsScreenKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _portrait(BuildContext context, T item) {
    final theme = Theme.of(context);

    List<Widget> children = [
      MuseumItemImage(
        imageUri: item.imageUri,
        tag: "$itemType#$itemId",
        fit: BoxFit.fitWidth,
      ),
    ];

    for (var button in interactiveWidgets(context, item)) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: RaisedButton(
            child: Text(
              button.title,
              style: context.titleTextStyle(),
            ),
            color: button.color,
            onPressed: button.onPressed,
          ),
        ),
      );
    }

    for (var card in informationWidgets(context, item)) {
      Widget child;
      if (card.subtitle != null) {
        child = Text(
          card.subtitle,
          style: context.subtitleTextStyle(),
          textAlign: TextAlign.end,
          maxLines: 2,
        );
      } else {
        child = card.child;
      }
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: theme.cardColor,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    card.title,
                    style: context.titleTextStyle(),
                    textAlign: TextAlign.start,
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: ListView(
        key: Keys.detailsScreenKey,
        children: children,
      ),
    );
  }
}