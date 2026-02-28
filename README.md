# VitalTrack

A cross-platform personal health tracker built with Flutter.

![VitalTrack](https://via.placeholder.com/800x400?text=VitalTrack+App)

## Features
- **User Authentication:** Email and Google Sign-in via Firebase.
- **Offline-First:** Built on Clean Architecture with local caching using Hive.
- **Health Trackers:** Water intake, step counting, meal calories, and sleep duration.
- **Habit Tracker:** Custom routines with streak tracking.
- **Analytics:** Weekly progress visualization with beautiful charts.
- **Customizable Settings:** Dark mode, units preference, and reminders.

---

## 🚀 Setup & Installation

### Prerequisites
1. [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. [Firebase CLI](https://firebase.google.com/docs/cli) installed and logged in.
3. [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) installed.

### 1. Initialize Firebase
The app uses Firebase Auth and Firestore. Connect your local project to a Firebase project:

```bash
# 1. Activate FlutterFire CLI if not already done
dart pub global activate flutterfire_cli

# 2. Configure Firebase in the project root
flutterfire configure
```
*Follow the prompts in your terminal to select or create a Firebase project.*

### 2. Generate Code (Hive & Freezed)
Because this app uses Hive for offline storage, you need to generate the binary adapters.

```bash
# Generate the adapter files
dart run build_runner build --delete-conflicting-outputs
```
*(Note: I pre-generated the most critical Hive adapters in `lib/data/models/*.g.dart` so the app should theoretically run even without this, but it's best practice if you make changes.)*

### 3. Run the App
```bash
flutter run
```

---

## 🏗 Architecture
This app follows **Clean Architecture** combined with the **Bloc/Cubit** pattern for state management.

- **`lib/domain/`**: Enterprise logic. Contains Entities, Failure classes, and abstract Repositories.
- **`lib/data/`**: Data layer. Contains Models (Hive adapters), actual Repository implementations (Firebase + Hive offline-first syncing), and Data Sources.
- **`lib/presentation/`**: UI layer. Contains all Flutter Widgets, Screens, and Blocs/Cubits.
- **`lib/core/`**: Shared utilities, theme config, router, and constants.
- **`lib/di/`**: Dependency Injection container (`get_it`).

### Offline-First Strategy
The Repositories in the `data/` layer write to Hive first for immediate UI updates, and then push changes to Firestore in the background.

---

## 🚀 Deployment Instructions

### Android
1. Generate an upload keystore.
2. Update `android/key.properties` with your keystore credentials.
3. Run: `flutter build appbundle`
4. Upload the generated `.aab` file in `build/app/outputs/bundle/release/` to the Google Play Console.

### iOS
1. Ensure you have an Apple Developer account.
2. Open `ios/Runner.xcworkspace` in Xcode.
3. Select your team in the "Signing & Capabilities" tab.
4. Run: `flutter build ipa`
5. Upload the resulting `.ipa` file using Transporter or Xcode to App Store Connect.
