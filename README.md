# GreenLeaf Samsung Galaxy S25 - Android test build

This package contains the original GreenLeaf 5-tab HTML prototype wrapped in a **Flutter WebView**.
It is a demo UI: no real campaigns, messages, opt-in or payment operations are connected.

## Why this project exists

The earlier 21 KB experimental `GreenLeaf_Android_UI_Test.apk` was not compiled using Flutter or Android's official build tools. **Do not reuse that APK.** This source is designed to produce an APK using the Flutter toolchain.

## Option A - Build on GitHub without installing software on your PC

1. Create a GitHub repository (private is fine) named `greenleaf-s25-preview`.
2. Upload the **contents** of this project folder to the repository root, including `.github/workflows/build-android-apk.yml`. Do not upload just the zip file or nest the entire project in an extra folder.
3. GitHub Actions will start after the initial commit to `main` or `master`. You can also choose `Actions` -> `Build GreenLeaf Samsung APK` -> `Run workflow`.
4. Open the completed build's page, go to **Artifacts** and download `GreenLeaf-S25-Android-Test-APK`.
5. Unzip the artifact, then transfer `app-debug.apk` to your Samsung Galaxy S25 and install it.

The workflow downloads the Flutter stable SDK and runs `flutter create`, `flutter pub get`, `flutter analyze`, and `flutter build apk --debug`. It uses Flutter's standard Android debug signing. It can fail due to upstream tool/download changes or project errors. The APK has **not been built in the current offline environment or tested on a Galaxy S25**.

## Option B - Build on Windows with Android Studio and Flutter

Open a terminal in this folder and run:

```powershell
flutter create . --platforms=android --org com.greenleaf --project-name greenleaf_mobile_preview
flutter pub get
flutter analyze
flutter build apk --debug
```

The APK will be at `build\app\outputs\flutter-apk\app-debug.apk`.

## Notes

- The app is offline and preserves the HTML design and its built-in demo interactions.
- No GreenLeaf backend credentials are included and no WhatsApp message is sent.
- The original HTML is in `assets/index.html`; Flutter host code is in `lib/main.dart`.
- This is a development/debug build, not a Play Store release. For production, implement secure authentication, APIs, proper permissions and production signing.
- If you have installed the previous broken test shell, uninstall `GreenLeaf Preview` before installing this build (different app package/signature may prevent an update).
