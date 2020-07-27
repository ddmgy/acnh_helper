class FilterType {
  static get found => "found";

  static get donated => "donated";

  static get isNeighbor => "is_neighbor";

  static get isCurrentlyAvailable => "is_currently_available";

  static get isNewlyAvailable => "is_newly_available";

  static get isLeavingSoon => "is_leaving_soon";

  static get all => [
    found,
    donated,
    isNeighbor,
    isCurrentlyAvailable,
    isNewlyAvailable,
    isLeavingSoon,
  ];
}