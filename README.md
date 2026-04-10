# 🎯 Reflection — Goal Tracking App

Reflection is a cross-platform mobile (and desktop/web) application that helps individuals set meaningful goals, break them down into actionable daily tasks, and track progress over time. The app guides users through an AI-assisted goal-creation session, generates personalised daily tasks, and provides a history view to review past activity — all behind secure JWT authentication.

**Target users:** Anyone looking to build better habits, achieve personal goals, or stay accountable on long-term projects.

[![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## ✨ Features

- **🔐 Secure Authentication** — Register and log in with email/password. JWT tokens are stored in encrypted device storage.
- **🎯 Goal Management** — Create, view, and track personal goals with deadlines and progress percentages.
- **🤖 AI-Assisted Goal Creation** — An interactive session guides users through clarifying questions to refine their goal before it is saved.
- **📋 Daily Task Generation** — The backend automatically generates a tailored daily task list for each active goal.
- **✅ Task Completion Tracking** — Mark tasks as complete/incomplete; status is persisted via the API.
- **📝 Task History** — Review previously completed tasks filtered by time period (e.g. last week).
- **🎨 Modern UI** — Clean, intuitive interface built with Material Design 3 and the Inter typeface.
- **💾 Secure Storage** — All sensitive data (tokens, user credentials) is encrypted using Flutter Secure Storage.
- **🌐 Cross-Platform** — Runs on Android, iOS, Web, Windows, Linux, and macOS from a single codebase.

---

## 🏛️ Technical Description

### Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern, organised around feature modules:

| Layer | Responsibility |
|---|---|
| **View** (`features/*/view/`) | Renders UI, listens to state changes via `ConsumerWidget` |
| **ViewModel** (`features/*/viewmodel/`) | Contains business logic, calls repositories, emits state via `StateNotifier` |
| **State** (`features/*/state/`) | Immutable state classes consumed by the View |
| **Repository** (`data/repositories/`) | Abstracts data access; calls API services |
| **Service** (`data/services/`) | Handles raw HTTP communication and response parsing |
| **Model** (`data/models/`) | Plain Dart data classes with JSON serialisation |

### State Management

**Riverpod 2.6.1** is used throughout the app via `StateNotifierProvider` and `StateNotifierProvider.family`:

- Each feature exposes a `StateNotifierProvider` registered in `lib/providers/providers.dart`.
- The `ProviderScope` at the root of `main.dart` makes all providers available app-wide.
- The `AuthWrapper` widget watches `authViewModelProvider` to decide whether to show the login screen or the main goals view.

### Data Flow

```
User Interaction (View)
        │
        ▼
  ViewModel (StateNotifier)
        │  calls
        ▼
  Repository
        │  calls
        ▼
  API Service (http)
        │  HTTP request
        ▼
  REST Backend (Render.com)
        │  JSON response
        ▼
  Model (fromJson)
        │
        ▼
  Repository returns model
        │
        ▼
  ViewModel emits new State
        │
        ▼
  View re-renders via ref.watch()
```

### Backend & API Integration

The app communicates with a hosted REST API:

- **Base URL:** `https://reflection-backend-r7uw.onrender.com`
- **Auth endpoints:** `POST /auth/register`, `POST /auth/login`
- **Goal endpoints:** `GET /goals?userId=`, `POST /goals`, `GET /goals/:id`
- **Goal Session endpoints:** `POST /goal-sessions`, `GET /goal-sessions/:id/next-question`, `POST /goal-questions/:id/answer`, `POST /goal-sessions/:id/complete`
- **Daily Task endpoints:** `GET /goals/:id/today-tasks`, `POST /goals/:id/generate-tasks`, `PATCH /goals/tasks/:id/status`, `GET /goals/:id/previous-tasks?period=`

All requests that require authentication attach a `Bearer <token>` header. Token management is handled entirely inside `AuthService` and `GoalApiService`.

For full authentication details see [AUTH_IMPLEMENTATION.md](AUTH_IMPLEMENTATION.md) and [SETUP_AUTH.md](SETUP_AUTH.md).

### Key Packages

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^2.6.1 | State management |
| `riverpod_annotation` | ^2.6.1 | Code-gen annotations for providers |
| `http` | ^1.2.0 | REST API communication |
| `flutter_secure_storage` | ^9.2.2 | Encrypted storage for JWT tokens |
| `intl` | ^0.19.0 | Date/time formatting |
| `build_runner` | ^2.4.13 | Code generation runner |
| `riverpod_generator` | ^2.6.2 | Generates Riverpod provider boilerplate |

---

## 🏗️ Project Structure

```
reflection_mobile_app/
├── fonts/                      # Inter font family (TTF files)
├── lib/
│   ├── core/
│   │   └── constants/          # App-wide strings, colours, and theme values
│   ├── data/
│   │   ├── models/             # Dart data classes: User, Goal, GoalSession,
│   │   │                       #   DailyTask, ChatMessage
│   │   ├── repositories/       # GoalRepository, GoalSessionRepository
│   │   └── services/           # AuthService (auth + token storage),
│   │                           #   GoalApiService (all goal/task endpoints)
│   ├── features/
│   │   ├── auth/               # Login & Register screens, AuthViewModel, AuthState
│   │   ├── goals/              # My Goals list screen, MyGoalsViewModel
│   │   ├── goal_creation/      # AI-guided goal creation wizard
│   │   ├── goal_details/       # Goal detail view with today's tasks
│   │   └── task_history/       # Historical task review screen
│   ├── providers/
│   │   └── providers.dart      # All Riverpod provider declarations
│   └── main.dart               # App entry point; ProviderScope + AuthWrapper
├── test/                       # Unit and widget tests
├── pubspec.yaml                # Dependencies and asset configuration
└── analysis_options.yaml       # Dart linting rules
```

---

## ⚙️ Setup Instructions

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **3.10.7 or higher**
- **Dart SDK 3.10.7 or higher** (bundled with Flutter)
- Android Studio (Android development) or Xcode (iOS development)
- A running instance of the Reflection backend, or use the hosted API at `https://reflection-backend-r7uw.onrender.com`

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MuneebDevss/reflection_mobile_app.git
   cd reflection_mobile_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Riverpod code** _(only required if modifying provider annotations)_
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure the API endpoint** _(optional — the default points to the hosted backend)_

   Edit the `baseUrl` constant in both service files if you are running a local backend:
   ```dart
   // lib/data/services/auth_service.dart
   // lib/data/services/goal_api_service.dart
   static const String baseUrl = 'http://localhost:3000'; // example
   ```

   See [SETUP_AUTH.md](SETUP_AUTH.md) for full authentication setup guidance.

---

## 🚀 Build & Run

### Development

```bash
# Run on the connected device / emulator (auto-detects)
flutter run

# Target a specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
flutter run -d windows
```

### Production Builds

```bash
# Android APK
flutter build apk --release

# Android App Bundle (recommended for Play Store)
flutter build appbundle --release

# iOS (requires macOS + Xcode)
flutter build ipa --release

# Web
flutter build web --release

# Windows desktop
flutter build windows --release
```

### Tests

```bash
# Run all tests
flutter test

# Run with coverage report
flutter test --coverage
```

---

## 📸 Screenshots

> _Screenshots and a demo GIF will be added in a future update._

---

## 🔮 Future Improvements

- **Push Notifications** — Remind users of daily tasks and upcoming deadlines.
- **Offline Support** — Cache goals and tasks locally so the app works without an internet connection.
- **Progress Charts** — Visual graphs showing goal progress and task completion trends over time.
- **Dark Mode** — A dedicated dark theme for low-light usage.
- **Social / Accountability Features** — Share goals with friends or join challenges.
- **Goal Categories & Tags** — Organise goals by category (health, career, learning, etc.).
- **Localisation** — Multi-language support using Flutter's `intl` package.
- **Automated CI/CD** — GitHub Actions pipeline for running tests and deploying builds on every push.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Muneeb**
- GitHub: [@MuneebDevss](https://github.com/MuneebDevss)

---

Made with ❤️ using Flutter
