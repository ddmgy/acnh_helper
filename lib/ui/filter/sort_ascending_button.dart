import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

class SortAscendingButton extends StatelessWidget {
  final String itemType;

  SortAscendingButton({
    Key key,
    @required this.itemType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        final sortAscending = provider.getSortAscending(itemType);

        return ListTile(
          leading: Icon(
            sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            color: context.iconColor(),
          ),
          title: Text(
            sortAscending ? "Ascending" : "Descending",
            style: context.titleTextStyle(),
          ),
          onTap: () {
            provider.setSortAscending(itemType, !sortAscending);
          },
          dense: true,
        );
      },
    );
  }
}