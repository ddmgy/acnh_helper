import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

/// Expand paths beginning with '~' or '~user".
///
/// Based on Python's os.path.expanduser.
Future<String> expandUser(String path) async {
  if (Platform.isAndroid || Platform.isIOS || kIsWeb) {
    return path;
  }
  if (Platform.isWindows) {
    return _expandUserWindows(path);
  } else {
    return _expandUserPosix(path);
  }
}

Future<String> _expandUserWindows(String path) async {
  if (!path.startsWith("~")) {
    return path;
  }

  Set<String> seps = {'\\', '/'};
  int i = 1;
  while (i < path.length && !seps.contains(path.substring(i, i + 1))) {
    i += 1;
  }

  Map<String, String> env = Platform.environment;
  String userHome;
  if (env.containsKey("USERPROFILE")) {
    userHome = env["USERPROFILE"];
  } else if (!env.containsKey("HOMEPATH")) {
    return path;
  } else {
    String drive;
    if (env.containsKey("HOMEDRIVE")) {
      drive = env["HOMEDRIVE"];
    } else {
      drive = "";
    }
    userHome = p.join(drive, env["HOMEPATH"]);
  }

  if (i != 1) {
    userHome = p.join(p.dirname(userHome), path.substring(1, i));
  }

  return userHome + path.substring(i);
}

// TODO: Test on Linux machine.
Future<String> _expandUserPosix(String path) async {
  if (!path.startsWith("~")) {
    return path;
  }

  int i = path.indexOf("/", 1);
  if (i < 0) {
    i = path.length;
  }

  Map<String, String> env = Platform.environment;
  String userHome;
  if (i == 1) {
    if (!env.containsKey("HOME")) {
      // TODO: Find a way to access password database (pwd) on Posix system?
      return path;
    }
    userHome = env["HOME"];
  } else {
    // TODO: Fix this vary naive implementation. A user's home directory can be anywhere. How to find it without $HOME variable? $HOME will probably exist on all properly configured systems.
    userHome = p.join("/home", path.substring(1, i));
  }

  return userHome + path.substring(i);
}

extension StringExtensions on String {
  bool get isNullOrEmpty => (this == null || this.isEmpty);
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  String capitalize() {
    if (this == null || this.length == 0) {
      return this;
    }
    if (this.length == 1) {
      return this.toUpperCase();
    }
    return this[0].toUpperCase() + substring(1);
  }

  String reverseDate() {
    if (this == null || !this.contains("/")) {
      return this;
    }
    return this.split("/").reversed.join("/");
  }
}

extension RequestsExtensions on http.BaseResponse {
  bool get ok => !(statusCode >= 400 && statusCode < 600);
}

extension IntExtensions on int {
  List<bool> toBoolList(int length) {
    return List<bool>.generate(length,
        (i) => ((1 << i) & this) == (1 << i));
  }

  bool toBool() {
    return this == 1;
  }
}

extension IntListExtensions on List<int> {
  List<bool> toBoolList(int length) {
    return List<bool>.generate(length, (i) => contains(i));
  }
}

extension BoolListExtensions on List<bool> {
  int toInt() {
    int n = 0;
    for (int i = 0; i < this.length; i++) {
      if (this[i]) {
        n |= (1 << i);
      }
    }
    return n;
  }
}

extension BoolExtensions on bool {
  int toInt() {
    return this ? 1 : 0;
  }
}

extension BuildContextExtensions on BuildContext {
  Color iconColor() {
    final theme = Theme.of(this);

    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black87;
      default:
        return null;
    }
  }

  Color textColor() {
    final theme = Theme.of(this);

    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black87;
      case Brightness.dark:
        return Colors.white70;
    }

    return null;
  }

  Color subtitleTextColor() {
    final theme = Theme.of(this);

    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black54;
      case Brightness.dark:
        return Colors.white54;
    }

    return null;
  }

  TextStyle titleTextStyle({double fontSize: 16}) {
    final style = Theme.of(this).textTheme.subtitle1;
    final color = this.textColor();
    return style.copyWith(color: color, fontSize: fontSize);
  }

  TextStyle subtitleTextStyle({double fontSize: 12}) {
    final style = Theme.of(this).textTheme.bodyText1;
    final color = this.subtitleTextColor();
    return style.copyWith(color: color, fontSize: fontSize);
  }
}

extension AlignmentExtensions on Alignment {
  double leftMargin(double margin) {
    if (this == Alignment.bottomLeft || this == Alignment.centerLeft || this == Alignment.topLeft) {
      return margin;
    }
    return null;
  }

  double rightMargin(double margin) {
    if (this == Alignment.bottomRight || this == Alignment.centerRight || this == Alignment.topRight) {
      return margin;
    }
    return null;
  }

  double bottomMargin(double margin) {
    if (this == Alignment.bottomCenter || this == Alignment.bottomLeft || this == Alignment.bottomRight) {
      return margin;
    }
    return null;
  }

  double topMargin(double margin) {
    if (this == Alignment.topCenter || this == Alignment.topLeft || this == Alignment.topRight) {
      return margin;
    }
    return null;
  }
}

extension ColorExtensions on Color {
  // These methods were copies from [tinycolor package](https://github.com/FooStudio/tinycolor/blob/master/lib/tinycolor.dart).
  Color lighten({int amount: 0}) {
    final hsl = HSLColor.fromColor(this);
    double l = hsl.lightness + (amount / 100);
    l = l.clamp(0, 1);
    double s = hsl.saturation;
    if (this.red == 0 && this.green == 0 && this.blue == 0) {
      // Special case for black, as lightening black makes red
      s = 0;
    }
    return hsl.withLightness(l).withSaturation(s).toColor();
  }

  Color darken({int amount: 10}) {
    final hsl = HSLColor.fromColor(this);
    double l = hsl.lightness - (amount / 100);
    l = l.clamp(0, 1);
    double s = hsl.saturation;
    if (this.red == 0 && this.green == 0 && this.blue == 0) {
      // Special case for black, as lightening black makes red
      s = 0;
    }
    return hsl.withLightness(l).withSaturation(s).toColor();
  }
}

// TODO: Migrate to using Month enum in lib/month.dart, rather than an integer

int getCurrentMonth() {
  var now = DateTime.now();
  return now.month;
}

String getMonthName(int month) => const [
  "Jan.",
  "Feb.",
  "Mar.",
  "Apr.",
  "May",
  "June",
  "July",
  "Aug.",
  "Sept.",
  "Oct.",
  "Nov.",
  "Dec.",
][month - 1];
