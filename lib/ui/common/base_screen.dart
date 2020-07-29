import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

import 'package:acnh_helper/acnhapi.dart';
import 'package:acnh_helper/filter_type.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/museum_items_provider.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/ui/common/keys.dart';
import 'package:acnh_helper/ui/filter/show_as_list_button.dart';
import 'package:acnh_helper/utils.dart';

class MenuAction {
  final String title;
  final VoidCallback onPressed;
  final Widget icon;
  final bool isDivider;

  const MenuAction({
    @required this.title,
    @required this.onPressed,
    this.icon,
    this.isDivider = false,
  });

  factory MenuAction.divider() {
    return MenuAction(
      isDivider: true,
      title: null,
      onPressed: null,
      icon: null,
    );
  }
}

class InfoChip {
  final String title;
  final Color color;
  final bool visible;

  InfoChip({
    @required this.title,
    @required this.color,
    @required this.visible,
  });

}

class InfoBadge {
  final Color color;
  final bool visible;
  final Alignment alignment;

  InfoBadge({
    @required this.color,
    @required this.visible,
    @required this.alignment,
  });
}

abstract class BaseScreen<P extends MuseumItemsProvider, T extends CommonTraits> extends StatelessWidget {
  final api = AcnhApi.instance;

  /// Text to use in shared AppBar title
  String get name;

  String get itemType;

  /// Actions to use in shared AppBar's PopupMenuButton
  List<MenuAction> get actions => const [];

  /// Use SearchPage package to show a SearchDelegate
  void doSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: SearchPage<T>(
        items: Provider.of<P>(context, listen: false).items,
        searchLabel: getSearchLabel(),
        suggestion: Center(
          child: Text(
            getSearchSuggestionLabel(),
            style: context.subtitleTextStyle(),
          ),
        ),
        failure: Center(
          child: Text(
            getSearchFailureLabel(),
            style: context.subtitleTextStyle(),
          ),
        ),
        filter: (T item) => getSearchFilters(item),
        builder: (T item) => BaseScreenListItem<T>(
          item: item,
          onPressed: () {
            navigateToDetailsScreen(context, item);
          },
          infoChips: listInformationWidgets(context, item),
        ),
      ),
    );
  }

  String getSearchLabel();

  String getSearchSuggestionLabel();

  String getSearchFailureLabel();

  List<String> getSearchFilters(T item) => const [];

  /// Create a widget to display filters in Scaffold.endDrawer
  Widget getFilterWidget(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    List<Widget> children = [
      ShowAsListButton(itemType: itemType),
    ];

    final sortBys = getSortByWidgets(context);
    if (sortBys.length > 0) {
      final tile = ExpansionTile(
        leading: Icon(
          Icons.sort,
          color: context.iconColor(),
        ),
        title: Text(
          "Sort",
          style: context.titleTextStyle(),
        ),
        children: sortBys,
        initiallyExpanded: prefs.getSortByTileExpanded(itemType),
        onExpansionChanged: (bool expanded) {
          prefs.setSortByTileExpanded(itemType, expanded);
        },
      );

      children.add(tile);
    }

    final filterBys = getFilterByWidgets(context);
    if (filterBys.length > 0) {
      final tile = ExpansionTile(
        leading: Icon(
          Icons.filter_none,
          color: context.iconColor(),
        ),
        title: Text(
          "Filter",
          style: context.titleTextStyle(),
        ),
        children: filterBys,
        initiallyExpanded: prefs.getFilterByTileExpanded(itemType),
        onExpansionChanged: (bool expanded) {
          prefs.setFilterByTileExpanded(itemType, expanded);
        },
      );

      children.add(tile);
    }

    return ListView(
      children: children,
    );
  }

  /// FilterBy*Buttons that will added to FilterExpansionTile
  List<Widget> getFilterByWidgets(BuildContext context) => const [];

  /// SortBy*Buttons that will be added to SortExpansionTile
  List<Widget> getSortByWidgets(BuildContext context) => const [];

  /// Filter and sort items based on preferences
  List<T> performFilterAndSort(BuildContext context, List<T> items) {
    final prefs = Provider.of<PreferencesProvider>(context, listen: false);
    final filterByFound = prefs.getFilterBy(itemType, FilterType.found);
    final filterByDonated = prefs.getFilterBy(itemType, FilterType.donated);
    final filterByCurrentlyAvailable = prefs.getFilterBy(itemType, FilterType.isCurrentlyAvailable);
    final filterByNewlyAvailable = prefs.getFilterBy(itemType, FilterType.isNewlyAvailable);
    final filterByLeavingSoon = prefs.getFilterBy(itemType, FilterType.isLeavingSoon);
    final filterIsNeighbor = prefs.getFilterBy(itemType, FilterType.isNeighbor);
    final sortBy = prefs.getSortBy(itemType);
    final calendarOptions = prefs.calendarOptions;

    var result = items
      .where((item) {
        if (!(item is DonatableTraits)) {
          return true;
        }

        if (filterByFound != null) {
          final found = (item as DonatableTraits).found;
          return (filterByFound && found) || (!filterByFound && !found);
        }

        return true;
      }
    ).where((item) {
        if (!(item is DonatableTraits))  {
          return true;
        }

        if (filterByDonated != null) {
          final donated = (item as DonatableTraits).donated;
          return (filterByDonated && donated) || (!filterByDonated && !donated);
        }

        return true;
      }
    ).where((item) {
        if (!(item is AvailabilityTraits)) {
          return true;
        }

        if (filterByCurrentlyAvailable != null) {
          final currentlyAvailable = (item as AvailabilityTraits).isCurrentlyAvailable(calendarOptions);
          return (filterByCurrentlyAvailable && currentlyAvailable) || (!filterByCurrentlyAvailable && !currentlyAvailable);
        }

        return true;
      }
    ).where((item) {
        if (!(item is AvailabilityTraits)) {
          return true;
        }

        if (filterByNewlyAvailable != null) {
          final newlyAvailable = (item as AvailabilityTraits).isNewlyAvailable(calendarOptions);
          return (filterByNewlyAvailable && newlyAvailable) || (!filterByNewlyAvailable && !newlyAvailable);
        }

        return true;
      }
    ).where((item) {
        if (!(item is AvailabilityTraits)) {
          return true;
        }

        if (filterByLeavingSoon != null) {
          final leavingSoon = (item as AvailabilityTraits).isLeavingSoon(calendarOptions);
          return (filterByLeavingSoon && leavingSoon) || (!filterByLeavingSoon && !leavingSoon);
        }

        return true;
      }
    ).where((item) {
        if (!(item is VillagerTraits)) {
          return true;
        }

        if (filterIsNeighbor != null) {
          final isNeighbor = (item as VillagerTraits).isNeighbor;
          return (filterIsNeighbor && isNeighbor) || (!filterIsNeighbor && !isNeighbor);
        }

        return true;
      }
    ).toList();
    result.sort((a, b) {
      if (sortBy == SortBy.Name) {
        return a.name.compareTo(b.name);
      }

      if (a is ArtTraits) {
        if (sortBy == SortBy.BuyPrice) {
          final itemA = a as ArtTraits;
          final itemB = b as ArtTraits;
          return itemA.buyPrice.compareTo(itemB.buyPrice);
        }
      }

      if (a is DonatableTraits) {
        if (sortBy == SortBy.SellPrice) {
          final itemA = a as DonatableTraits;
          final itemB = b as DonatableTraits;
          return itemA.sellPrice.compareTo(itemB.sellPrice);
        }
      }

      if (a is ShadowTraits) {
        if (sortBy == SortBy.Shadow) {
          final itemA = a as ShadowTraits;
          final itemB = b as ShadowTraits;
          return itemA.shadow.compareTo(itemB.shadow);
        }
      }

      if (a is LocationTraits) {
        if (sortBy == SortBy.Location) {
          final itemA = a as LocationTraits;
          final itemB = b as LocationTraits;
          return itemA.location.compareTo(itemB.location);
        }
      }

      if (a is SeaCreatureTraits) {
        if (sortBy == SortBy.Speed) {
          final itemA = a as SeaCreatureTraits;
          final itemB = b as SeaCreatureTraits;
          return itemA.speed.compareTo(itemB.speed);
        }
      }

      if (a is VillagerTraits) {
        final itemA = a as VillagerTraits;
        final itemB = b as VillagerTraits;
        if (sortBy == SortBy.Personality) {
          return itemA.personality.compareTo(itemB.personality);
        } else if (sortBy == SortBy.Birthday) {
          return itemA.birthday.compareTo(itemB.birthday);
        } else if (sortBy == SortBy.Species) {
          return itemA.species.compareTo(itemB.species);
        } else if (sortBy == SortBy.Gender) {
          return itemA.gender.compareTo(itemB.gender);
        }
      }

      return a.id.compareTo(b.id); // Default: SortBy.InGameOrder
    });
    if (!prefs.sortAscending) {
      return result.reversed.toList();
    }
    return result.toList();
  }

  /// Refresh stored information from API
  void performRefresh(BuildContext context);

  /// Common method to use with list and grid widgets to navigate to screen with expanded details
  void navigateToDetailsScreen(BuildContext context, T item);

  List<InfoChip> listInformationWidgets(BuildContext context, T item) => const [];

  List<InfoBadge> gridInformationWidgets(BuildContext context, T item) => const [];

  double get gridItemAspectRatio => 1.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<P>(
      builder: (context, provider, _) {
        if  (provider.hasError) {
          return Text(
            provider.error,
            style: context.subtitleTextStyle(),
          );
        }

        var items = provider.items;
        if (items.length == 0) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Loading...",
                style: context.subtitleTextStyle(),
              ),
            ],
          );
        }

        items = performFilterAndSort(context, items);
        if (items.length == 0) {
          return Text(
            "No items found. Maybe try turning off some filters.",
            style: context.subtitleTextStyle(),
          );
        }

        final showAsList = Provider.of<PreferencesProvider>(context).getShowAsList(itemType);
        Widget child;
        if (showAsList) {
          child = ListView.builder(
            itemCount: items.length,
            itemExtent: 80,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: BaseScreenListItem<T>(
                item: items[index],
                infoChips: listInformationWidgets(context, items[index]),
                onPressed: () {
                  navigateToDetailsScreen(context, items[index]);
                },
              ),
            ),
          );
        } else {
          child = GridView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => BaseScreenGridItem<T>(
              item: items[index],
              infoBadges: gridInformationWidgets(context, items[index]),
              onPressed: () {
                navigateToDetailsScreen(context, items[index]);
              },
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: gridItemAspectRatio,
            ),
          );
        }

        return Scrollbar(
          key: Keys.screenKey,
          child: child,
        );
      }
    );
  }
}

class BaseScreenGridItem<T extends CommonTraits> extends StatelessWidget {
  final T item;
  final VoidCallback onPressed;
  final List<InfoBadge> infoBadges;

  BaseScreenGridItem({
    Key key,
    @required this.item,
    @required this.onPressed,
    @required this.infoBadges,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> badges = [];
    for (var i = 0; i < infoBadges.length; i++) {
      final badge = infoBadges[i];
      if (!badge.visible) {
        continue;
      }
      badges.add(
        Positioned(
          left: badge.alignment.leftMargin(4),
          top: badge.alignment.topMargin(4),
          bottom: badge.alignment.bottomMargin(4),
          right: badge.alignment.rightMargin(4),
          child: Container(
            height: 8,
            width: 8,
            decoration: ShapeDecoration(
              color: badge.color,
              shape: CircleBorder(
                side: BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Material(
            color: theme.cardColor,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          top: 0,
          right: 0,
          child: CachedNetworkImage(
            imageUrl: item.thumbnailUri,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Material(
            color: Theme.of(context).cardColor.withOpacity(0.65),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: AutoSizeText(
                item.name,
                minFontSize: 8,
                maxFontSize: 12,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: context.titleTextStyle(),
              ),
            ),
          ),
        ),
        ...badges,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}

class BaseScreenListItem<T extends CommonTraits> extends StatelessWidget {
  final T item;
  final VoidCallback onPressed;
  final List<InfoChip> infoChips;

  BaseScreenListItem({
    Key key,
    @required this.item,
    @required this.onPressed,
    @required this.infoChips,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> chips = [];
    for (var i = 0; i < infoChips.length; i++) {
      final chip = infoChips[i];
      if (!chip.visible) {
        continue;
      }
      if (chips.length > 0) {
        chips.add(
          SizedBox(width: 8),
        );
      }
      chips.add(
        Chip(
          label: Text(
            chip.title,
            style: context.subtitleTextStyle(),
          ),
          backgroundColor: chip.color,
          visualDensity: VisualDensity.compact,
          labelPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: -2),
        ),
      );
    }

    return Stack(
      children: [
        Material(
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CachedNetworkImage(
                    imageUrl: item.thumbnailUri,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: context.titleTextStyle(),
                      ),
                      Row(
                        children: chips,
                      ),
                    ],
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}