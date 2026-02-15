# Changelog

## [0.0.4] - 2026-02-16

### Features

- Added `DioSpyWrapper` widget — an overlay-based alternative to the `navigatorKey` approach for displaying the inspector UI

## [0.0.3] - 2026-02-13

### Docs

- Update Screenshots

## [0.0.2] - 2026-02-13

### Features

- Added JSON visualizer with interactive tree view

## [0.0.1] - 2026-02-12

### Initial Release

A lightweight HTTP inspector for Dio with a clean minimal UI.

#### Features

- Automatic HTTP request/response capture via Dio interceptor
- Shake gesture to open inspector
- Clean UI with request/response details viewer
- Copy as cURL command
- Collapsible JSON tree viewer
- Request timing and response size tracking
- Quick filter by URL, HTTP method and status code
- In-memory circular buffer storage (configurable, default: 1000 calls)

#### Requirements

- Dart SDK: `^3.0.0`
- Flutter: `>=3.10.0`
- Dio: `>=5.0.0 <6.0.0`
