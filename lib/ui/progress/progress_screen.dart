import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/item_type.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/provider/arts_provider.dart';
import 'package:acnh_helper/provider/bugs_provider.dart';
import 'package:acnh_helper/provider/fishes_provider.dart';
import 'package:acnh_helper/provider/fossils_provider.dart';
import 'package:acnh_helper/provider/sea_creatures_provider.dart';
import 'package:acnh_helper/ui/common/app_colors.dart';
import 'package:acnh_helper/ui/common/keys.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/utils.dart';

class ProgressItem {
  final String title;
  final int found;
  final int foundTotal;
  final int donated;
  final int donatedTotal;

  ProgressItem({
    @required this.title,
    @required this.found,
    @required this.foundTotal,
    @required this.donated,
    @required this.donatedTotal,
  });
}

class ProgressScreen extends StatelessWidget {
  ProgressItem _mapDonatableItemsToProgressItem(String title, List<DonatableTraits> donatableItems) {
    var found = 0;
    var donated = 0;
    donatableItems.forEach((d) {
      if (d.found) found++;
      if (d.donated) donated++;
    });
    return ProgressItem(
      title: title,
      found: found,
      foundTotal: donatableItems.length,
      donated: donated,
      donatedTotal: donatableItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bugs = Provider.of<BugsProvider>(context, listen: false);
    final fishes = Provider.of<FishesProvider>(context, listen: false);
    final seaCreatures = Provider.of<SeaCreaturesProvider>(context, listen: false);
    final fossils = Provider.of<FossilsProvider>(context, listen: false);
    final arts = Provider.of<ArtsProvider>(context, listen: false);

    return Consumer<PreferencesProvider>(
      builder: (context, prefs, _) {
        final showAsList = prefs.getShowAsList(ItemType.progress);

        var progressItems = [
          _mapDonatableItemsToProgressItem("Bugs", bugs.items),
          _mapDonatableItemsToProgressItem("Fish", fishes.items),
          _mapDonatableItemsToProgressItem("Sea creatures", seaCreatures.items),
          _mapDonatableItemsToProgressItem("Fossils", fossils.items),
          _mapDonatableItemsToProgressItem("Art", arts.items),
        ];

        Widget child;
        if (showAsList) {
          child = ListView.builder(
            itemCount: progressItems.length,
            itemExtent: 80,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: ProgressScreenListItem(
                progressItem: progressItems[index],
              ),
            ),
          );
        } else {
          child = GridView.builder(
            itemCount: progressItems.length,
            itemBuilder: (context, index) => ProgressScreenGridItem(
              progressItem: progressItems[index],
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.0,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Progress"),
            actions: [
              IconButton(
                icon: Icon(showAsList ? Icons.view_list : Icons.view_module),
                tooltip: showAsList ? "View as list" : "View as grid",
                onPressed: () => prefs.setShowAsList(ItemType.progress, !showAsList),
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
              ),
            ],
          ),
          body: Scrollbar(
            key: Keys.progressKey,
            child: child,
          ),
        );
      },
    );
  }
}

class ProgressScreenGridItem extends StatelessWidget {
  final ProgressItem progressItem;

  ProgressScreenGridItem({
    Key key,
    @required this.progressItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foundPercent = progressItem.foundTotal > 0 ? progressItem.found / progressItem.foundTotal : null;
    final donatedPercent = progressItem.donatedTotal > 0 ? progressItem.donated / progressItem.donatedTotal : null;

    return Stack(
      children: [
        Positioned.fill(
          child: Material(
            color: theme.cardColor,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 20,
          child: Text(
            progressItem.title,
            style: context.titleTextStyle(),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${progressItem.found}/${progressItem.foundTotal}",
                style: context.subtitleTextStyle().copyWith(
                  color: AppColors.foundColor,
                ),
              ),
              Text(
                "${progressItem.donated}/${progressItem.donatedTotal}",
                style: context.subtitleTextStyle().copyWith(
                  color: AppColors.donatedColor,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 28,
          right: 28,
          top: 28,
          bottom: 28,
          child: CircularProgressIndicator(
            value: foundPercent,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.foundColor),
            backgroundColor: theme.disabledColor,
            strokeWidth: 8,
          ),
        ),
        Positioned(
          left: 40,
          right: 40,
          top: 40,
          bottom: 40,
          child: CircularProgressIndicator(
            value: donatedPercent,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.donatedColor),
            backgroundColor: theme.disabledColor,
            strokeWidth: 8,
          ),
        ),
      ],
    );
  }
}

class ProgressScreenListItem extends StatelessWidget {
  final ProgressItem progressItem;

  ProgressScreenListItem({
    Key key,
    @required this.progressItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO: Make (or commission) icons to represent these items, so the text does not make the layout vary so wildly
            Expanded(
              child: Text(
                progressItem.title,
                style: context.titleTextStyle(),
              ),
              flex: 1,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ListItemProgressWidget(
                    color: AppColors.foundColor,
                    count: progressItem.found,
                    total: progressItem.foundTotal,
                  ),
                  _ListItemProgressWidget(
                    color: AppColors.donatedColor,
                    count: progressItem.donated,
                    total: progressItem.donatedTotal,
                  ),
                ],
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListItemProgressWidget extends StatelessWidget {
  final Color color;
  final int count;
  final int total;

  _ListItemProgressWidget({
    Key key,
    @required this.color,
    @required this.count,
    @required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = total > 0 ? count / total : null;

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: percent,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          flex: 5,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            "$count/$total",
            style: context.subtitleTextStyle().copyWith(
              color: color,
            ),
            textAlign: TextAlign.end,
          ),
          flex: 1,
        ),
      ],
    );
  }
}