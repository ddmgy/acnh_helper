enum ThemeType {
  Light,
  Dark,
}

extension ThemeExtension on ThemeType {
  String getName() {
    switch (this) {
      case ThemeType.Light:
        return "Light";
      case ThemeType.Dark:
        return "Dark";
    }
    throw Exception("Unknown value for ThemeType.getName: ${this}");
  }

  int toInt() {
    switch (this) {
      case ThemeType.Light:
        return 0;
      case ThemeType.Dark:
        return 1;
    }
    throw Exception("Unknown value for ThemeType.toInt: ${this}");
  }
}

extension IntToThemeException on int {
  ThemeType toThemeType() {
    switch (this) {
      case 0:
        return ThemeType.Light;
      case 1:
        return ThemeType.Dark;
    }
    throw Exception("Unknown value for int.toThemeType: ${this}");
  }
}