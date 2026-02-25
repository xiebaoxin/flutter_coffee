## Cursor Cloud specific instructions

### Project Overview
This is **flutter_coffee** (极网咖啡), a Chinese IoT-connected coffee ordering Flutter mobile app. It targets Android and iOS, connecting to remote APIs at `wangpeiaiot.com`. There is no backend code in this repo.

### Development Environment

Environment variables are set in `~/.bashrc`:
- `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64`
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

2. **Java 17 required**: The `connectivity_plus` plugin requires Java 17 source level. JDK 17 must be installed and `JAVA_HOME` must point to it. JDK 11 will fail the build.

3. **Android build config**: AGP 7.3.0, Kotlin 1.7.10, Gradle 7.5.1, `compileSdkVersion 34`, `targetSdkVersion 34`. The `namespace` is set in `android/app/build.gradle`.

4. **Analysis status**: `flutter analyze lib/` produces 0 errors and ~264 warnings/infos. The `plugins/sip-ua/` directory has many errors (separate package, not part of main app).

5. **Stub files in `lib/stubs/`**: Several removed or unavailable packages are replaced by local stubs (e.g., `amap_stub.dart`, `color_dart.dart`, `decorated_flutter_stub.dart`, `fluwx_stub.dart`, `tobias_stub.dart`, `install_plugin_stub.dart`, etc.). These stubs provide minimal API surfaces to allow compilation.

6. **Remote APIs**: The app depends entirely on remote backends at `wp-api.wangpeiaiot.com` and `cashier.wangpeiaiot.com:8088`. No local backend is available. The app cannot be functionally tested end-to-end without network access to these servers.

7. **SIP UA plugin** (`plugins/sip-ua/`): A bundled VoIP plugin with its own tests. Its analysis errors are expected — it's a separate package not properly wired into the main project.

8. **Test file** (`test/widget_test.dart`): Default Flutter template smoke test. The `pumpWidget(MyApp())` call is commented out; the test compiles but fails at assertion. No meaningful automated tests exist.

9. **android:exported**: The main `AndroidManifest.xml` must have `android:exported="true"` on the `MainActivity` for Android 12+ (`targetSdkVersion 34`).
