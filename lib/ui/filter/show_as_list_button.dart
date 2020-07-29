import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

class ShowAsListButton extends StatelessWidget {
  final String itemType;

  ShowAsListButton({
    Key key,
    @required this.itemType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        final showAsList = provider.getShowAsList(itemType);

        return ListTile(
          leading: Icon(
            showAsList ? Icons.view_list : Icons.view_module,
            color: context.iconColor(),
          ),
          title: Text(
            showAsList ? "Show as list" : "Show as grid",
            style: context.titleTextStyle(),
          ),
          onTap: () {
            provider.setShowAsList(itemType, !showAsList);
          },
          dense: true,
        );
      },
    );
  }
}