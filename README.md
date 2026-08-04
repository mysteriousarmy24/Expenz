# Expenz

Expenz is a Flutter personal-finance app for tracking income, expenses, and category budgets.

## Download the app

Download the latest Android APK from the [GitHub Releases page](https://github.com/mysteriousarmy24/Expenz/releases/latest).

> Android may prompt you to allow installation from this source. Only install APKs downloaded from this repository's releases.

## Latest update

- Refreshed the UI for responsive use across mobile screen sizes.
- Added safe layouts for long transaction names, category labels, and large currency values.
- Improved scrolling, adaptive padding, and chart/card constraints to prevent overflow and clipping.

## Run locally

```bash
flutter pub get
flutter run
```

## Build a release APK

```bash
flutter build apk --release
```

The generated APK is available at `build/app/outputs/flutter-apk/app-release.apk`.
