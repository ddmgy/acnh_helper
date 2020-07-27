import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

class SortAscendingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        return ListTile(
          leading: Icon(
            provider.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            color: context.iconColor(),
          ),
          title: Text(
            provider.sortAscending ? "Ascending" : "Descending",
            style: context.titleTextStyle(),
          ),
          onTap: () {
            provider.sortAscending = !provider.sortAscending;
          },
          dense: true,
        );
      },
    );
  }
}