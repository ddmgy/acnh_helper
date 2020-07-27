import 'package:flutter/material.dart';

import 'package:preferences_ui/preferences_ui.dart';
import 'package:provider/provider.dart';

import 'package:acnh_helper/preference/preferences_helper.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/provider/arts_provider.dart';
import 'package:acnh_helper/provider/bugs_provider.dart';
import 'package:acnh_helper/provider/fishes_provider.dart';
import 'package:acnh_helper/provider/fossils_provider.dart';
import 'package:acnh_helper/provider/sea_creatures_provider.dart';
import 'package:acnh_helper/provider/villagers_provider.dart';
import 'package:acnh_helper/theme/theme_type.dart';
import 'package:acnh_helper/utils.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
          ),
          body: Scrollbar(
            child: PreferenceScreen(
              categories: [
                PreferenceCategory(
                  title: "General",
                  preferences: [
                    ListPreference(
                      title: "Application theme",
                      dialogTitle: "Choose theme",
                      value: provider.themeType,
                      entryValues: PreferenceValues.themes,
                      entries: PreferenceEntries.themes,
                      onChanged: (ThemeType newThemeType) {
                        provider.themeType = newThemeType;
                      },
                    ),
                  ],
                ),
                PreferenceCategory(
                  title: "Advanced",
                  preferences: [
                    TextPreference(
                      title: "Reset database",
                      onLongPress: () async {
                        final doRefresh = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Reset database",
                                style: context.titleTextStyle(fontSize: 18),
                              ),
                              content: Center(
                                child: Text(
                                  "Are you sure you want to reset the database? All data will be deleted and re-downloaded.",
                                  style: context.subtitleTextStyle(fontSize: 16),
                                ),
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    "Cancel",
                                    style: context.subtitleTextStyle(fontSize: 14),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                FlatButton(
                                  child: Text(
                                    "OK",
                                    style: context.subtitleTextStyle(fontSize: 14),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          },
                        );

                        if (doRefresh ?? false) {
                          Provider.of<ArtsProvider>(context, listen: false).resetArts();
                          Provider.of<BugsProvider>(context, listen: false).resetBugs();
                          Provider.of<FishesProvider>(context, listen: false).resetFishes();
                          Provider.of<FossilsProvider>(context, listen: false).resetFossils();
                          Provider.of<SeaCreaturesProvider>(context, listen: false).resetSeaCreatures();
                          Provider.of<VillagersProvider>(context, listen: false).resetVillagers();
                        }
                      },
                    ),
                    TextPreference(
                      title: "Reset user preferences",
                      onLongPress: () async {
                        Provider.of<PreferencesProvider>(context, listen: false).clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}