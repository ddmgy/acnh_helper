import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/month.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

class CalendarHemisphereButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, prefs, _) {
        return ListTile(
          leading: SizedBox(
            height: 24,
            width: 24,
          ),
          title: Text(
            "Hemisphere",
            style: context.titleTextStyle(),
          ),
          trailing: DropdownButton<Hemisphere>(
            value: prefs.preferredHemisphere,
            onChanged: (Hemisphere value) {
              prefs.preferredHemisphere = value;
            },
            items: Hemisphere.values.map((hemisphere) {
              return DropdownMenuItem<Hemisphere>(
                value: hemisphere,
                child: Text(
                  hemisphere.getName(),
                  style: context.subtitleTextStyle(),
                ),
              );
            }).toList(),
            selectedItemBuilder: (context) => Hemisphere.values.map((hemisphere) {
              return Align(
                alignment: Alignment.center,
                child: Text(
                  hemisphere.getName(),
                  style: context.subtitleTextStyle(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class CalendarMonthButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, prefs, _) {
        return ListTile(
          leading: SizedBox(
            height: 24,
            width: 24,
          ),
          title: Text(
            "Month",
            style: context.titleTextStyle(),
          ),
          trailing: DropdownButton<Month>(
            value: prefs.preferredMonth,
            onChanged: (Month value) {
              prefs.preferredMonth = value;
            },
            items: Month.values.map((month) {
              return DropdownMenuItem<Month>(
                value: month,
                child: Text(
                  month.getName(),
                  style: context.subtitleTextStyle(),
                ),
              );
            }).toList(),
            selectedItemBuilder: (context) => Month.values.map((month) {
              return Align(
                alignment: Alignment.center,
                child: Text(
                  month.getName(),
                  style: context.subtitleTextStyle(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}