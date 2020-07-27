import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/filter_type.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

abstract class FilterByButton extends StatelessWidget {
  final String title;
  final String filterType;
  final String tooltip;

  FilterByButton({
    Key key,
    @required this.title,
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
            final value = provider.getFilterBy(filterType);
            provider.setFilterBy(filterType, value != null ? (!value ? true : null) : false);
          },
          trailing: Checkbox(
            value: provider.getFilterBy(filterType),
            tristate: true,
            onChanged: (bool value) {
              provider.setFilterBy(filterType, value);
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
  }) : super(
    key: key,
    title: "Found",
    tooltip: "Filter by found",
    filterType: FilterType.found,
  );
}

class FilterByDonatedButton extends FilterByButton {
  FilterByDonatedButton({
    Key key,
  }) : super(
    key: key,
    title: "Donated",
    tooltip: "Filter by donated",
    filterType: FilterType.donated,
  );
}

class FilterByIsNeighborButton extends FilterByButton {
  FilterByIsNeighborButton({
    Key key,
  }) : super(
    key: key,
    title: "Neighbor",
    tooltip: "Filter by neighbor status",
    filterType: FilterType.isNeighbor,
  );
}

class FilterByCurrentlyAvailable extends FilterByButton {
  FilterByCurrentlyAvailable({
    Key key,
  }) : super(
    key: key,
    title: "Currently available",
    tooltip: "Filter if item is currently available",
    filterType: FilterType.isCurrentlyAvailable,
  );
}

class FilterByNewlyAvailable extends FilterByButton {
  FilterByNewlyAvailable({
    Key key,
  }) : super(
    key: key,
    title: "Newly available",
    tooltip: "Filter if item is newly available",
    filterType: FilterType.isNewlyAvailable,
  );
}

class FilterByLeavingSoon extends FilterByButton {
  FilterByLeavingSoon({
    Key key,
  }) : super(
    key: key,
    title: "Leaving soon",
    tooltip: "Filter if item is leaving soon",
    filterType: FilterType.isLeavingSoon,
  );
}