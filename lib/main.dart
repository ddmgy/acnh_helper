import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/provider/arts_provider.dart';
import 'package:acnh_helper/provider/bugs_provider.dart';
import 'package:acnh_helper/provider/fishes_provider.dart';
import 'package:acnh_helper/provider/fossils_provider.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/provider/sea_creatures_provider.dart';
import 'package:acnh_helper/provider/villagers_provider.dart';
import 'package:acnh_helper/ui/home_screen.dart';
import 'package:acnh_helper/ui/art/art_details_screen.dart';
import 'package:acnh_helper/ui/bug/bug_details_screen.dart';
import 'package:acnh_helper/ui/common/routes.dart';
import 'package:acnh_helper/ui/setting/settings_screen.dart';
import 'package:acnh_helper/ui/fish/fish_details_screen.dart';
import 'package:acnh_helper/ui/fossil/fossil_details_screen.dart';
import 'package:acnh_helper/ui/progress/progress_screen.dart';
import 'package:acnh_helper/ui/sea_creature/sea_creature_details_screen.dart';
import 'package:acnh_helper/ui/villager/villager_details_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PreferencesProvider>(
          create: (_) => PreferencesProvider(),
        ),
        ChangeNotifierProvider<BugsProvider>(
          create: (_) => BugsProvider()..loadItems(),
        ),
        ChangeNotifierProvider<FishesProvider>(
          create: (_) => FishesProvider()..loadItems(),
        ),
        ChangeNotifierProvider<SeaCreaturesProvider>(
          create: (_) => SeaCreaturesProvider()..loadItems(),
        ),
        ChangeNotifierProvider<FossilsProvider>(
          create: (_) => FossilsProvider()..loadItems(),
        ),
        ChangeNotifierProvider<ArtsProvider>(
          create: (_) => ArtsProvider()..loadItems(),
        ),
        ChangeNotifierProvider<VillagersProvider>(
          create: (_) => VillagersProvider()..loadItems(),
        ),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PreferencesProvider, ThemeData>(
      selector: (_, provider) => provider.theme,
      builder: (context, theme, _) {
        return MaterialApp(
          title: "AC:NH Helper",
          theme: theme,
          initialRoute: Routes.home,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case Routes.home:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => HomeScreen(),
                );
                break;
              case Routes.artDetails:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => ArtDetailsScreen(itemId: id),
                );
                break;
              case Routes.bugDetails:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => BugDetailsScreen(itemId: id),
                );
                break;
              case Routes.fishDetails:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => FishDetailsScreen(itemId: id),
                );
                break;
              case Routes.fossilDetails:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => FossilDetailsScreen(itemId: id),
                );
                break;
              case Routes.seaCreatureDetails:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => SeaCreatureDetailsScreen(itemId: id),
                );
                break;
              case Routes.villagerDetails:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => VillagerDetailsScreen(itemId: id),
                );
                break;
              case Routes.settings:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => SettingsScreen(),
                );
                break;
              case Routes.progress:
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => ProgressScreen(),
                );
                break;
            }
            throw Exception("Unknown route name: ${settings.name}");
          },
        );
      },
    );
  }
}