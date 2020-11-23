import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
import 'package:acnh_helper/ui/changelog/changelog_screen.dart';
import 'package:acnh_helper/utils.dart';

typedef ColorPreferenceSetter = Function(Color newColor);

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<PreferencesProvider>(
    builder: (context, provider, _) => PreferenceScreen(
      title: "Settings",
      children: [
        PreferenceGroup(
          title: "General",
          children: [
            ListPreference(
              title: "Application theme",
              dialogTitle: "Choose theme",
              leading: Icon(Icons.account_circle),
              value: provider.themeType,
              entryValues: PreferenceValues.themes,
              entries: PreferenceEntries.themes,
              onChanged: (ThemeType newThemeType) {
                provider.themeType = newThemeType;
              },
            ),
          ],
        ),
        PreferenceGroup(
          title: "Time",
          children: [
            CheckBoxPreference(
              title: "Months available",
              leading: Icon(Icons.calendar_today),
              value: provider.showMonthsAsString,
              summaryOn: "Months will be shown as string",
              summaryOff: "Months will be hidden",
              onChanged: (bool newShowMonthsAsString) {
                provider.showMonthsAsString = newShowMonthsAsString;
              },
            ),
            CheckBoxPreference(
              title: "Times available",
              leading: Icon(Icons.access_time),
              value: provider.showTimeAsString,
              summaryOn: "Times will be shown as string",
              summaryOff: "Times will be hidden",
              onChanged: (bool newShowTimeAsString) {
                provider.showTimeAsString = newShowTimeAsString;
              },
            ),
            SwitchPreference(
              title: "Time format",
              leading: Icon(Icons.watch),
              value: provider.showTimeAs12Hour,
              summaryOn: "12-hour (8AM - 4PM)",
              summaryOff: "24-hour (08 - 16)",
              onChanged: (bool newShowTimeAs12Hour) {
                provider.showTimeAs12Hour = newShowTimeAs12Hour;
              },
            ),
          ],
        ),
        PreferenceGroup(
          title: "Colors",
          children: [
            Preference(
              title: "Found",
              summary: "Items that have been marked as found by user",
              leading: _colorIcon(provider.foundColor),
              onTap: () => _showColorPickerDialog(
                context,
                provider.foundColor,
                (Color newColor) => provider.foundColor = newColor,
              ),
            ),
            Preference(
              title: "Donated",
              summary: "Items that have been marked as donated by user",
              leading: _colorIcon(provider.donatedColor),
              onTap: () => _showColorPickerDialog(
                context,
                provider.donatedColor,
                (Color newColor) => provider.donatedColor = newColor,
              ),
            ),
            Preference(
              title: "Currently available",
              summary: "Items that are available to find this month",
              leading: _colorIcon(provider.currentlyAvailableColor),
              onTap: () => _showColorPickerDialog(
                context,
                provider.currentlyAvailableColor,
                (Color newColor) => provider.currentlyAvailableColor = newColor,
              ),
            ),
            Preference(
              title: "Newly available",
              summary: "Items that are available to find this month, but were not available last month",
              leading: _colorIcon(provider.newlyAvailableColor),
              onTap: () => _showColorPickerDialog(
                context,
                provider.newlyAvailableColor,
                (Color newColor) => provider.newlyAvailableColor = newColor,
              ),
            ),
            Preference(
              title: "Leaving soon",
              summary: "Items that are available to find this month, but will not be available next month",
              leading: _colorIcon(provider.leavingSoonColor),
              onTap: () => _showColorPickerDialog(
                context,
                provider.leavingSoonColor,
                (Color newColor) => provider.leavingSoonColor = newColor,
              ),
            ),
            Preference(
              title: "Neighbor",
              summary: "Villagers that have been marked as a neighbor by user",
              leading: _colorIcon(provider.neighborColor),
              onTap: () => _showColorPickerDialog(
                context,
                provider.neighborColor,
                (Color newColor) => provider.neighborColor = newColor,
              ),
            ),
            Preference(
              title: "Reset colors",
              summary: "Reset colors to defaults",
              leading: Icon(Icons.color_lens),
              onLongPress: () => provider.resetColors(),
            ),
          ],
        ),
        PreferenceGroup(
          title: "Advanced",
          children: [
            Preference(
              title: "Reset database",
              leading: Icon(Icons.list_alt),
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
                        TextButton(
                          child: Text(
                            "Cancel",
                            style: context.subtitleTextStyle(fontSize: 14),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
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
            Preference(
              title: "Reset user preferences",
              leading: Icon(Icons.refresh),
              onLongPress: () async {
                Provider.of<PreferencesProvider>(context, listen: false).clear();
              },
            ),
          ],
        ),
        PreferenceGroup(
          title: "Other",
          children: [
            PreferencePage(
              title: "About",
              summary: "Information about this application",
              leading: Icon(Icons.info),
              children: [
                Preference(
                  title: "Version",
                  summary: "0.8.1",
                  onTap: () {}, // Just to show feedback like siblings
                ),
                Preference(
                  title: "Changelog",
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => ChangelogScreen(),
                  )),
                ),
                Preference(
                  title: "Licenses",
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: "AC:NH helper",
                    applicationVersion: "0.8.1",
                    applicationLegalese: "© 2020 David Mougey",
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  Widget _colorIcon(Color color) => AnimatedContainer(
    duration: kThemeChangeDuration,
    decoration: ShapeDecoration(
      color: color,
      shape: CircleBorder(),
    )
  );

  void _showColorPickerDialog(
    BuildContext context,
    Color initialColor,
    ColorPreferenceSetter onColorChanged,
  ) async {
    Color pickerColor = initialColor;
    final newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Choose a color"),
        scrollable: true,
        content: SlidePicker(
          pickerColor: pickerColor,
          showLabel: true,
          enableAlpha: false,
          paletteType: PaletteType.rgb,
          onColorChanged: (Color color) => pickerColor = color,
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(null),
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(pickerColor),
          ),
        ],
      ),
    );

    if (newColor != null && newColor != initialColor) {
      onColorChanged(newColor);
    }
  }
}