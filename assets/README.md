assets/images/

Place your app logo in `assets/images/`. The project currently references `assets/images/app_logo.jpg` in `pubspec.yaml`.

Recommended filenames (pick one):
- `app_logo.jpg` or `app_logo.png` — main image (e.g., 512x512)
- `app_logo@2x.png`, `app_logo@3x.png` — higher-resolution variants (optional)

After replacing the logo, run:

```powershell
flutter pub get; flutter clean; flutter run
```

Note: Launcher icons (the icon shown on the device home screen) are managed separately for Android and iOS. To update launcher icons, use the `flutter_launcher_icons` package or update the native resources in `android/app/src/main/res/` and the iOS asset catalogs in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`.
