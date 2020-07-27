import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

class ShowAsListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        return ListTile(
          leading: Icon(
            provider.showAsList ? Icons.view_list : Icons.view_module,
            color: context.iconColor(),
          ),
          title: Text(
            provider.showAsList ? "Show as list" : "Show as grid",
            style: context.titleTextStyle(),
          ),
          onTap: () {
            provider.showAsList = !provider.showAsList;
          },
          dense: true,
        );
      },
    );
  }
}