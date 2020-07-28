import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/filter_type.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

abstract class FilterByButton extends StatelessWidget {
  final String title;
  final String itemType;
  final String filterType;
  final String tooltip;

  FilterByButton({
    Key key,
    @required this.title,
    @required this.itemType,
    @required this.filterType,
    this.tooltip,
  }) :
    assert(title != null),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        Widget result = ListTile(
          leading: Icon(
            Icons.filter_none,
            color: context.iconColor(),
          ),
          title: Text(
            title,
            style: context.titleTextStyle(),
          ),
          onTap: () {
            final value = provider.getFilterBy(itemType, filterType);
            provider.setFilterBy(itemType, filterType, value != null ? (!value ? true : null) : false);
          },
          trailing: Checkbox(
            value: provider.getFilterBy(itemType, filterType),
            tristate: true,
            onChanged: (bool value) {
              provider.setFilterBy(itemType, filterType, value);
            },
          ),
          dense: true,
        );

        if (tooltip != null) {
          result = Tooltip(
            message: tooltip,
            child: result,
          );
        }

        return result;
      },
    );
  }
}

class FilterByFoundButton extends FilterByButton {
  FilterByFoundButton({
    Key key,
    @required String itemType,
  }) : super(
    key: key,
    title: "Found",
    itemType: itemType,
    filterType: FilterType.found,
    tooltip: "Filter if item has been found",
  );
}

class FilterByDonatedButton extends FilterByButton {
  FilterByDonatedButton({
    Key key,
    @required String itemType,
  }) : super(
    key: key,
    title: "Donated",
    itemType: itemType,
    filterType: FilterType.donated,
    tooltip: "Filter if item has been donated",
  );
}

class FilterByIsNeighborButton extends FilterByButton {
  FilterByIsNeighborButton({
    Key key,
    @required String itemType,
  }) : super(
    key: key,
    title: "Neighbor",
    itemType: itemType,
    filterType: FilterType.isNeighbor,
    tooltip: "Filter by neighbor status",
  );
}

class FilterByCurrentlyAvailable extends FilterByButton {
  FilterByCurrentlyAvailable({
    Key key,
    @required String itemType,
  }) : super(
    key: key,
    title: "Currently available",
    itemType: itemType,
    filterType: FilterType.isCurrentlyAvailable,
    tooltip: "Filter if item is currently available",
  );
}

class FilterByNewlyAvailable extends FilterByButton {
  FilterByNewlyAvailable({
    Key key,
    @required String itemType,
  }) : super(
    key: key,
    title: "Newly available",
    itemType: itemType,
    filterType: FilterType.isNewlyAvailable,
    tooltip: "Filter if item is newly available",
  );
}

class FilterByLeavingSoon extends FilterByButton {
  FilterByLeavingSoon({
    Key key,
    @required String itemType,
  }) : super(
    key: key,
    title: "Leaving soon",
    itemType: itemType,
    filterType: FilterType.isLeavingSoon,
    tooltip: "Filter if item is leaving soon",
  );
}