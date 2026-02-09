# FitFlow - Professional Fitness Application

A modern, feature-rich Flutter fitness application designed to help users track workouts, achieve fitness goals, and connect with a community of fitness enthusiasts.

## 🎯 Overview

FitFlow is a comprehensive fitness tracking application built with Flutter that provides users with tools to monitor their fitness journey, access curated workout videos, track achievements, and engage with the fitness community through social features.

## ✨ Key Features

### 🏋️ Workout Management
- **Extensive Workout Library**: Access to a curated collection of workout categories and routines
- **Video Demonstrations**: High-quality workout videos with built-in video player (Chewie integration)
- **Workout Tracking**: Track completed workouts with detailed statistics
- **Category-Based Organization**: Workouts organized by type and difficulty level

### 📊 Progress Tracking
- **Statistics Dashboard**: Visualize fitness progress with interactive charts (fl_chart)
- **Achievement System**: Earn badges and milestones as you progress
- **Workout History**: Detailed logs of all completed workouts
- **Performance Metrics**: Track key fitness indicators over time

### 👥 Social Features
- **Social Connections**: Connect with other fitness enthusiasts
- **Activity Feed**: See achievements and progress from your connections
- **Community Engagement**: Share and celebrate fitness milestones
- **Social Activity Tracking**: Monitor interactions within the fitness community

### 👤 User Profile
- **Personalized Dashboard**: Customized workout recommendations
- **User Statistics**: Personal fitness metrics and progress
- **Profile Management**: Manage user information and preferences
- **Theme Customization**: Support for light/dark theme preferences

### 🎨 User Interface
- **Material Design 3**: Modern, intuitive material design interface
- **Smooth Animations**: Staggered animations and smooth transitions
- **Responsive Layout**: Optimized for various screen sizes
- **Theme Support**: Built-in light/dark mode toggle
- **Custom Typography**: Google Fonts integration for modern typography

### ⚡ Technical Features
- **Video Caching**: Efficient video caching system for offline access
- **State Management**: Provider pattern for robust state management
- **Local Storage**: SharedPreferences for persistent local data
- **Performance Optimized**: Shimmer loaders and lazy loading
- **Celebratory Effects**: Confetti animations for achievement celebrations

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🛠 Technology Stack

### Framework & Language
- **Flutter**: Latest stable version (SDK: >=3.0.0 <4.0.0)
- **Dart**: Modern cross-platform language

### Core Dependencies
- **Provider**: State management (v6.1.1)
- **Firebase**: Backend services (currently configured but disabled in build)
  - firebase_core
  - firebase_auth
  - cloud_firestore

### UI & Animations
- **Flutter Animate**: Advanced animation library (v4.5.0)
- **Flutter Staggered Animations**: Complex animation patterns (v1.1.1)
- **Shimmer**: Loading shimmer effects (v3.0.0)
- **Confetti**: Celebration animations (v0.8.0)
- **Flutter SVG**: SVG asset support (v2.0.9)

### Media & Charts
- **Video Player**: Native video playback (v2.8.2)
- **Chewie**: Wrapper for video player (v1.7.5)
- **FL Chart**: Interactive charts and graphs (v0.65.0)
- **Google Fonts**: Typography support (v6.1.0)

### Utilities
- **Shared Preferences**: Local data persistence (v2.2.2)
- **Path Provider**: File system paths (v2.1.5)
- **HTTP**: Network requests (v1.1.0)
- **Intl**: Internationalization (v0.20.2)
- **Logger**: Debug logging (v2.1.0)

## 📂 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── firebase_options.dart     # Firebase configuration
├── config/
│   ├── app_theme.dart       # Theme definitions
│   └── theme_config.dart    # Theme configuration
├── models/
│   ├── achievement.dart
│   ├── social_activity.dart
│   ├── social_connection.dart
│   ├── user_model.dart
│   ├── user_statistics.dart
│   ├── workout_category.dart
│   └── workout.dart
├── screens/
│   ├── auth/                # Authentication screens
│   ├── splash_screen.dart   # App splash screen
│   ├── home/                # Home dashboard
│   ├── workouts/            # Workout management
│   ├── achievements/        # Achievements display
│   ├── progress/            # Progress tracking
│   ├── social/              # Social features
│   ├── discover/            # Discover new content
│   └── profile/             # User profile
├── providers/
│   ├── user_provider.dart   # User state management
│   └── theme_provider.dart  # Theme state management
├── services/
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   ├── video_cache_service.dart
│   ├── workout_tracker_service.dart
│   ├── social_service.dart
│   ├── achievement_service.dart
│   └── social_activity_service.dart
├── utils/
│   └── logger.dart          # Logging utilities
├── widgets/                 # Reusable UI components
└── navigation/              # Navigation configuration
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio or Xcode (for platform-specific development)
- Git

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/fitflow.git
   cd fitflow
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Local Configurations**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the Application**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
```bash
# Build APK
flutter build apk

# Build release APK
flutter build apk --release
```

#### iOS
```bash
# Build IPA
flutter build ios

# Build release IPA
flutter build ipa --release
```

#### Web
```bash
# Run web version
flutter run -d chrome

# Build for web
flutter build web --release
```

## 🔧 Configuration

### Firebase Setup (Optional)
The project includes Firebase support but it's currently disabled. To enable:

1. Uncomment Firebase packages in `pubspec.yaml`
2. Configure Firebase in your project:
   ```bash
   flutterfire configure
   ```
3. Uncomment Firebase initialization in `lib/main.dart`

### Theme Configuration
- Light/Dark mode preferences saved to SharedPreferences
- Customize themes in `lib/config/app_theme.dart`
- Font settings configured via Google Fonts

## 📖 Architecture

### State Management
- **Provider Pattern**: Global state management for User and Theme
- **Local State**: Screen-level state using StatefulWidget

### Service Layer
- **Authentication Service**: User authentication and authorization
- **Video Cache Service**: Efficient video caching and management
- **Workout Tracker Service**: Workout data persistence and retrieval
- **Social Service**: Community features and connections
- **Achievement Service**: Badge and milestone tracking

### Models
- Type-safe data models for all core entities
- Equatable mixins for easy comparison
- Serialization support for local storage

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 🐛 Debugging

### Logging
The project includes a custom logger for debugging:
```dart
import 'package:fitflow/utils/logger.dart';

logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

### DevTools
Launch Flutter DevTools for debugging:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## 📦 Building for Release

### Android
```bash
# Build release APK
flutter build apk --release

# Build app bundle (for Google Play)
flutter build appbundle --release
```

### iOS
```bash
# Build release IPA
flutter build ipa --release
```

### Web
```bash
# Build release web app
flutter build web --release
```

## 🚢 Deployment

### Firebase Hosting (Web)
```bash
npm install -g firebase-tools
firebase init
firebase deploy
```

### Google Play Store (Android)
1. Create a signing key
2. Build app bundle: `flutter build appbundle --release`
3. Upload to Google Play Console

### Apple App Store (iOS)
1. Build release IPA: `flutter build ipa --release`
2. Upload using Transporter or TestFlight

## 📝 Git Workflow

### Initialize Git Repository
```bash
cd fitflow
git init
git add .
git commit -m "Initial commit: FitFlow fitness application"
```

### Connect to GitHub
```bash
# Add remote repository
git remote add origin https://github.com/yourusername/fitflow.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

### Common Git Commands
```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: describe your changes"

# Push feature branch
git push origin feature/your-feature-name

# Create Pull Request on GitHub

# Merge to main
git checkout main
git pull origin main
git merge feature/your-feature-name
git push origin main
```

## 🔐 Environment Variables

Create a `.env` file for sensitive configuration:
```
FIREBASE_PROJECT_ID=your_project_id
API_BASE_URL=your_api_url
```

**Note**: Add `.env` to `.gitignore` to prevent exposing sensitive data

## 📋 Checklist for GitHub Push

Before pushing to GitHub, ensure:
- ✅ Remove `.env` and sensitive files from git
- ✅ Update version in `pubspec.yaml`
- ✅ Run `flutter analyze` for code quality
- ✅ Test all features locally
- ✅ Update documentation
- ✅ Add meaningful commit messages
- ✅ Create `.gitignore` file

### Sample `.gitignore`
```
# Dart/Flutter/Plugins
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
pubspec.lock

# IDE
.idea/
.vscode/
.sublime-project
.sublime-workspace
*.iml
*.lock

# Environment
.env
.env.local

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db

# Firebase
google-services.json
GoogleService-Info.plist

# Coverage
coverage/
```

## 📞 Support & Contribution

### Reporting Issues
Open an issue on GitHub with:
- Description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/videos if applicable

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community packages used in this project
- All contributors to FitFlow

## 📊 Project Statistics

- **Total Screens**: 8+ feature screens
- **Services**: 7 service modules
- **Models**: 8 core data models
- **Supported Platforms**: 6 platforms
- **Dependencies**: 20+ essential packages
- **Platform Support**: Android, iOS, Web, Windows, macOS, Linux

## 🔄 Version History

### v1.0.0
- Initial release
- Core workout tracking features
- User authentication and profiles
- Social features and achievement system
- Video playback and caching
- Progress visualization with charts
- Theme support (Light/Dark mode)

## 📞 Contact & Support

For questions or support:
- 📧 Email: support@fitflow.app
- 🐦 Twitter: [@fitflow_app](https://twitter.com)
- 💬 Discord: [Join Community](https://discord.gg)

---

**Made with ❤️ by the FitFlow Team**

Last Updated: February 2026
