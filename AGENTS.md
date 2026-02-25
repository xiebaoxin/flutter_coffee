## Cursor Cloud specific instructions

### Project Overview
This is **flutter_coffee** (极网咖啡), a Chinese IoT-connected coffee ordering Flutter mobile app. It targets Android and iOS, connecting to remote APIs at `wangpeiaiot.com`. There is no backend code in this repo.

### Development Environment

Environment variables are set in `~/.bashrc`:
- `JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64`
- `ANDROID_HOME=/home/ubuntu/android-sdk`
- `PATH` includes `/home/ubuntu/flutter/bin` and Android SDK tools

### Key Commands
| Task | Command |
|------|---------|
| Check env | `flutter doctor` |
| Get deps | `flutter pub get` |
| Lint | `flutter analyze` |
| Test | `flutter test` |
| Build APK | `flutter build apk --debug` |

### Critical Gotchas

1. **Flutter 2.10.5 / Dart 2.16.2 required**: The `flutter_native_image` git dependency needs Dart >=2.12.0, so Flutter 1.x won't work. Flutter 2.10.5 is the best compatible version.

2. **Java 11 required**: The project uses Gradle 6.7.1 which is incompatible with Java 17+. Always use JDK 11.

3. **No `pubspec.lock` in repo**: The project uses `any` version constraints for most dependencies. Without a lock file, `flutter pub get` resolves to latest versions of packages, many of which have been updated to use newer Flutter APIs that are incompatible. This causes **compile errors** during `flutter analyze`, `flutter test`, and `flutter build`. These are pre-existing codebase issues, not environment problems.

4. **Pre-existing compile errors**: The codebase has naming conflicts (`Router` from fluro vs Flutter, `KeyEvent` from pay_password.dart vs Flutter) and resolved dependency versions that use removed APIs (`DiagnosticableMixin`, `inheritFromWidgetOfExactType`, `RenderToggleable`). A full build or test run will fail with Dart compilation errors.

5. **Android embedding v2 migration**: The `AndroidManifest.xml` originally referenced `io.flutter.app.FlutterApplication` (v1 embedding) while declaring v2 embedding metadata. The `android:name` attribute was removed to fix Flutter 2.10's v2 embedding enforcement.

6. **Kotlin 1.5.31**: Updated from 1.3.50 to match dependency requirements (`foundation_fluttify` compiled with Kotlin 1.5.31).

7. **Android Gradle Plugin 4.1.3 / Gradle 6.7.1**: Updated from AGP 3.5.0/Gradle 5.6.2 to support Kotlin 1.5.31.

8. **The test file** (`test/widget_test.dart`) is a default Flutter template smoke test with the main app call commented out — it would not pass even without dependency issues.

9. **Remote APIs**: The app depends entirely on remote backends at `wp-api.wangpeiaiot.com` and `cashier.wangpeiaiot.com:8088`. No local backend is available.

10. **SIP UA plugin** (`plugins/sip-ua/`): A bundled VoIP plugin with its own tests. Its test errors in `flutter analyze` are expected — it's a separate package not properly wired into the main project's test infrastructure.
