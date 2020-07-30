enum SortBy {
  InGameOrder,
  Name,
  BuyPrice,
  SellPrice,
  Shadow,
  Location,
  Speed,
  Personality,
  Birthday,
  Species,
  Gender,
}

extension SortByExtensions on SortBy {
  int toInt() {
    return index;
  }

  String getName() {
    switch (this) {
      case SortBy.InGameOrder:
        return "In-game order";
      case SortBy.Name:
        return "Name";
      case SortBy.BuyPrice:
        return "Buy price";
      case SortBy.SellPrice:
        return "Sell price";
      case SortBy.Shadow:
        return "Shadow type";
      case SortBy.Location:
        return "Location";
      case SortBy.Speed:
        return "Speed";
      case SortBy.Personality:
        return "Personality";
      case SortBy.Birthday:
        return "Birthday";
      case SortBy.Species:
        return "Species";
      case SortBy.Gender:
        return "Gender";
    }

    throw Exception("Unknown value for SortBy: $this");
  }
}

extension IntExtensions on int {
  SortBy toSortBy() {
    assert(this >= 0 && this < SortBy.values.length);
    return SortBy.values[this];
  }
}