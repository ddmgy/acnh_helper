enum Hemisphere {
  Northern,
  Southern,
}

extension HemisphereExtensions on Hemisphere {
  int toInt() {
    return this.index;
  }

  String getName() {
    switch (this) {
      case Hemisphere.Northern:
        return "Northern";
      case Hemisphere.Southern:
        return "Southern";
    }

    throw Exception("Unknown value for Hemisphere: $this");
  }
}

extension IntExtensions on int {
  Hemisphere toHemisphere() {
    assert(this >= 0 && this < Hemisphere.values.length);
    return Hemisphere.values[this];
  }
}