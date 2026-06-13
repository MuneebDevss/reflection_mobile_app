# 🎯 Reflection - Goal Tracking App

A beautiful, cross-platform goal tracking and task management application built with Flutter. Reflection helps you set, track, and achieve your goals with an intuitive interface and powerful features.

[![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

- **🔐 Secure Authentication** - JWT-based authentication with secure token storage
- **🎯 Goal Management** - Create, track, and manage your personal goals
- **📝 Task History** - Keep track of completed tasks and monitor your progress
- **🎨 Modern UI** - Clean, intuitive interface with Material Design 3
- **💾 Secure Storage** - All sensitive data encrypted using Flutter Secure Storage
- **🌐 Cross-Platform** - Runs on Android, iOS, Web, Windows, Linux, and macOS
- **⚡ State Management** - Efficient state management using Riverpod

## 📸 Screenshots

_Coming soon 

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.7 or higher
- Dart SDK 3.10.7 or higher
- Android Studio / Xcode (for mobile development)
- A backend API server (see API configuration below)

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

3. **Generate code (for Riverpod)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure API endpoint**
   - Update the API base URL in your service files
   - See [SETUP_AUTH.md](SETUP_AUTH.md) for detailed authentication setup

5. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d chrome
   flutter run -d windows
   ```

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/      # App-wide constants and strings
│   ├── theme/          # Theme configuration
│   └── utils/          # Utility functions
├── data/
│   ├── models/         # Data models (User, Goal, Task)
│   ├── repositories/   # Data repositories
│   └── services/       # API services
├── features/
│   ├── auth/           # Authentication feature
│   ├── goals/          # Goals list and management
│   ├── goal_creation/  # Create new goals
│   ├── goal_details/   # Goal details view
│   └── task_history/   # Task history tracking
├── providers/          # Riverpod providers
├── widgets/            # Reusable widgets
└── main.dart           # App entry point
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.10.7
- **Language**: Dart 3.10.7
- **State Management**: Riverpod 2.6.1
- **HTTP Client**: http 1.2.0
- **Secure Storage**: flutter_secure_storage 9.2.2
- **Date Formatting**: intl 0.19.0
- **Code Generation**: build_runner, riverpod_generator

## 🔑 Authentication

This app uses JWT (JSON Web Token) based authentication. For detailed information about the authentication implementation, see:

- [AUTH_IMPLEMENTATION.md](AUTH_IMPLEMENTATION.md) - Complete authentication documentation
- [SETUP_AUTH.md](SETUP_AUTH.md) - Setup guide for authentication

Key features:
- Secure token storage using Flutter Secure Storage
- Automatic token refresh
- Protected API endpoints
- Login/Register flows

## 📱 Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ipa --release
```

### Web
```bash
flutter build web --release
```

### Windows
```bash
flutter build windows --release
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📝 Configuration

### API Configuration
Update the base URL in your service files:
- `lib/data/services/auth_service.dart`
- `lib/data/services/goal_api_service.dart`

### Custom Fonts
The app uses Inter font. Font files are located in `fonts/` directory.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Muneeb**
- GitHub: [@MuneebDevss](https://github.com/MuneebDevss)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- All contributors who help improve this project

## 📞 Support

If you have any questions or need help, feel free to:
- Open an issue
- Contact the maintainer

---

Made with ❤️ using Flutter
