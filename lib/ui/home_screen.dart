import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/ui/art/art_screen.dart';
import 'package:acnh_helper/ui/bug/bug_screen.dart';
import 'package:acnh_helper/ui/common/base_screen.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/ui/fish/fish_screen.dart';
import 'package:acnh_helper/ui/fossil/fossil_screen.dart';
import 'package:acnh_helper/ui/sea_creature/sea_creature_screen.dart';
import 'package:acnh_helper/ui/villager/villager_screen.dart';
import 'package:acnh_helper/utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BaseScreen> screens = [
    BugScreen(),
    FishScreen(),
    SeaCreatureScreen(),
    FossilScreen(),
    ArtScreen(),
    VillagerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, prefs, _) {
        final body = screens[prefs.lastUsedPage];

        final endDrawerWidget = body.getFilterWidget(context);
        final overflowActions = [
          ...body.actions,
          if (body.actions.length > 0) MenuAction.divider(),
          MenuAction(
            title: "Refresh data",
            icon: Icon(Icons.refresh),
            onPressed: () async {
              bool refresh = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Confirm action",
                      style: context.titleTextStyle(),
                    ),
                    content: Center(
                      child: Text(
                        "Are you sure you want to refresh this data?",
                        style: context.titleTextStyle(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          "Cancel",
                          style: context.titleTextStyle(),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text(
                          "OK",
                          style: context.titleTextStyle(),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );
              if (refresh ?? false) {
                body.performRefresh(context);
              }
            }
          ),
          MenuAction(
            title: "Settings",
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.settings);
            },
          ),
        ];

        List<Widget> drawerChildren = [];

        for (int index = 0; index < screens.length; index++) {
          final screen = screens[index];
          final tile = ListTile(
            title: Text(
              screen.name,
              style: context.titleTextStyle(),
            ),
            dense: true,
            selected: prefs.lastUsedPage == index,
            onTap: () {
              prefs.lastUsedPage = index;
              Navigator.of(context).pop();
            },
          );
          drawerChildren.add(tile);
        }

        drawerChildren.add(Divider());
        drawerChildren.add(
          ListTile(
            title: Text(
              "Progress",
              style: context.titleTextStyle(),
            ),
            dense: true,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(Routes.progress);
            },
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(body.name),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => body.doSearch(context),
              ),
              if (endDrawerWidget != null) HomeFilterButton(),
              PopupMenuButton<int>(
                onSelected: (int index) {
                  overflowActions[index].onPressed();
                },
                itemBuilder: (context) {
                  return List<PopupMenuEntry<int>>.generate(overflowActions.length, (index) {
                    final action = overflowActions[index];
                    if (action.isDivider) {
                      return PopupMenuDivider();
                    }

                    final iconThemeData = IconThemeData(
                      color: context.iconColor(),
                    );
                    final icon = IconTheme.merge(
                      data: iconThemeData,
                      child: action.icon,
                    );

                    final textStyle = context.titleTextStyle();
                    final text = AnimatedDefaultTextStyle(
                      style: textStyle,
                      duration: kThemeChangeDuration,
                      child: Text(action.title),
                    );

                    return PopupMenuItem<int>(
                      value: index,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          icon,
                          Container(width: 16),
                          Expanded(
                            flex: 1,
                            child: text,
                          ),
                        ],
                      ),
                    );
                  }).toList();
                }
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: drawerChildren,
            ),
          ),
          endDrawer: Drawer(
            child: endDrawerWidget,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: body,
            ),
          ),
        );
      },
    );
  }
}

class HomeFilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}