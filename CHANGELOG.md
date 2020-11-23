# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Added
- Add ability for user to set colors of badges/chips.

## [0.8.0] - 2020-11-22
### Added
- Add new badges/chips to show if an item is newly available (was not available previous month) or leaving soon (will not be available next month).
- Add hero transition when navigating between home screen and details screen. Thumbnail/image widget now transitions between positions on those screens.
### Fixed
- Displays in progress screen will now properly update, instead of endlessly loading.
### Changed
- Change unused colors to use for newly available/leaving soon widgets.
- Remove unnecessary "Sell price (Flick)" info widget on sea creature details screen, as Flick does not purchase sea creatures.
- Change transition between pages to fade transition.

## [0.7.2] - 2020-11-11
### Added
- Add option to view changelog in settings.
### Changed
- Rewrite settings screen for new preferences_ui library.
- Remove About dialog, add Settings > About > Licenses.

## [0.7.1] - 2020-11-10
### Added
- Add Windows, Linux, and iOS targets.
### Changed
- Update dependencies.

## [0.7.0] - 2020-07-31
### Added
- Added refresh and settings buttons to details screens.

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
