# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## [0.6.0] - 2020-07-31
### Added
- Add option to view months available as string (e.g., March - November), in addition to the graph.
- Add option to view times available as string (e.g., 8AM - 7PM), in addition to the graph.
- Add option to view times as 12-hour (3PM) or 24-hour (15:00) time.
- Marker on times available graph showing current hour (similar to in-game).
### Fixed
- Fix for off-by-one issue when getting availability, which led to incorrectly showing the months that an item was available.
- Progress bars on Progress screen will now show even if they are unable to load items.
- Certain month ranges would produce an error, but will now display properly.

## [0.5.0] - 2020-07-30
### Changed
- Editing calendar options (month and hemisphere) are now done in same menu as filters, rather than in separate dialog.

## [0.4.0] - 2020-07-29
### Added
- Screen to view progress for all items that can be donated to Museum. Each item type (bug, fish, art, etc.) shows progress for how many items were found and/or donated.
- About dialog, showing version number and linking to a list of licenses.
### Fixed
- Show as list/grid and sort ascending/descending preferences are now properly cleared when resetting all preferences.

## [0.3.0] - 2020-07-28
### Added
- Show/sort options are now specific to item type (e.g., Bugs can be displayed in ascending grid view, while Fish are descending list view).

## [0.2.0] - 2020-07-28
### Added
- Add this CHANGELOG.md
### Changed
- Filters are now specific to the item type (so Bug filters will no long be the same as Fish filters, etc.).

## [0.1.0] - 2020-07-27
### Added
- Manage lists of art, bugs, fish, fossils, sea creatures, and villagers from Animal Crossing: New Horizons
