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

1. **Flutter 3.22.3 / Dart 3.4.4**: The project `pubspec.yaml` declares `sdk: ">=3.0.0 <4.0.0"`. The installed Flutter SDK is 3.22.3 with Dart 3.4.4.

2. **Java 11 required**: The project uses Gradle 7.5.1 with AGP 7.3.0. Java 17+ has not been tested; use JDK 11.

3. **Android build config**: AGP 7.3.0, Kotlin 1.7.10, Gradle 7.5.1, `compileSdkVersion 34`, `targetSdkVersion 34`. The `namespace` is set in `android/app/build.gradle`.

4. **Pre-existing Dart compile errors**: The codebase has ~1500+ analysis errors mostly related to incomplete null-safety migration (fields needing `late`/`?`, constructor params needing defaults, type mismatches). These are pre-existing codebase issues. `flutter analyze` runs successfully but reports many errors. `flutter test` and `flutter build apk --debug` fail at Dart compilation due to these errors.

5. **Stub files in `lib/stubs/`**: Several removed or unavailable packages are replaced by local stubs (e.g., `amap_stub.dart`, `color_dart.dart`, `decorated_flutter_stub.dart`, `fluwx_stub.dart`, `tobias_stub.dart`, `install_plugin_stub.dart`, etc.). These stubs provide minimal API surfaces to allow compilation.

6. **Migration in progress**: The codebase was migrated from Flutter 1.x/Dart 2.x to Flutter 3.22.3/Dart 3.4.4. Import paths, widget APIs (e.g., `FlatButton` -> `TextButton`), and package names (e.g., `connectivity` -> `connectivity_plus`) have been updated. Null-safety migration is incomplete.

7. **Remote APIs**: The app depends entirely on remote backends at `wp-api.wangpeiaiot.com` and `cashier.wangpeiaiot.com:8088`. No local backend is available. The app cannot be functionally tested end-to-end without network access to these servers.

8. **SIP UA plugin** (`plugins/sip-ua/`): A bundled VoIP plugin with its own tests. Its analysis errors are expected — it's a separate package not properly wired into the main project.

9. **Test file** (`test/widget_test.dart`): Default Flutter template smoke test with the main app call commented out — it cannot pass due to Dart compilation errors in imported files.
