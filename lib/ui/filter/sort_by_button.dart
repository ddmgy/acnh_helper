import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/sort_by.dart';
import 'package:acnh_helper/utils.dart';

class SortByButton extends StatelessWidget {
  final String itemType;
  final List<SortBy> values;

  SortByButton({
    Key key,
    @required this.itemType,
    @required this.values,
  }) :
    assert(itemType.isNotNullOrEmpty),
    assert(values != null && values.isNotEmpty),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        return ListTile(
          leading: Icon(
            Icons.sort,
            color: context.iconColor(),
          ),
          title: Text(
            "Sort by",
            style: context.titleTextStyle(),
          ),
          trailing: DropdownButton<SortBy>(
            value: provider.getSortBy(itemType),
            onChanged: (SortBy value) {
              provider.setSortBy(itemType, value);
            },
            items: values.map((sortBy) {
              return DropdownMenuItem<SortBy>(
                value: sortBy,
                child: Text(
                  sortBy.getName(),
                  style: context.subtitleTextStyle(),
                ),
              );
            }).toList(),
            selectedItemBuilder: (context) => values.map((sortBy) {
              return Align(
                alignment: Alignment.center,
                child: Text(
                  sortBy.getName(),
                  style: context.subtitleTextStyle(),
                ),
              );
            }).toList(),
          ),
          dense: true,
        );
      },
    );
  }
}