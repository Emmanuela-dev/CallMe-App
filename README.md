# CallMe - Phone Dialer App

A simple and attractive mobile phone dialer app built with Flutter that allows users to enter phone numbers, simulate dialing, and end calls. This app works completely independently without depending on any external phone apps.

## Features

- **Phone Dialer**: Interactive keypad for entering phone numbers
- **Call Simulation**: Simulate making and ending phone calls
- **Contacts Management**: View, add, edit, and delete contacts
- **Navigation**: Bottom navigation between Dialer and Contacts
- **Data Persistence**: Contacts saved locally using SharedPreferences
- **Attractive UI**: Modern Material Design interface with green theme
- **Custom App Icon**: Personalized launcher icon

## What We Built

This is a Flutter application that provides a complete phone dialer and contacts management experience:

1. **Navigation System**:
   - Bottom navigation bar with Dialer and Contacts tabs
   - Seamless switching between features

2. **Phone Dialer**:
   - Large display showing entered numbers
   - Numeric keypad (0-9, *, #) for input
   - Backspace button for corrections
   - Call and End Call buttons with state management

3. **Contacts Management**:
   - List view of all contacts with avatars
   - Add new contacts with name and phone number
   - Edit existing contacts
   - Delete contacts
   - Persistent storage using SharedPreferences

4. **Data Persistence**:
   - Contacts saved locally on device
   - JSON encoding/decoding for data storage
   - Sample contacts loaded on first run

3. **Design**:
   - Green color scheme (phone-themed)
   - Material Design components
   - Responsive layout

## How We Did It

### 1. Project Setup
- Created a new Flutter project
- Configured the app name in `pubspec.yaml`

### 2. App Name Configuration
**File**: `pubspec.yaml`
```yaml
name: callme
```
The app name is defined in the `name` field. This affects:
- The package identifier
- Import paths in code
- App identification in stores

### 3. User Interface Development
**File**: `lib/main.dart`

- Used `MaterialApp` for the app structure
- Created a `StatefulWidget` for the dialer page
- Implemented a `GridView` for the keypad
- Added `Text` widget for number display
- Used `FloatingActionButton` for call actions

### 4. Functionality Implementation
- **Number Input**: Each keypad button appends digits to a `TextEditingController`
- **Dial**: Sets calling state and shows notification
- **End Call**: Resets state and shows confirmation
- **Backspace**: Removes last digit from input

### 5. App Icon Setup
**File**: `pubspec.yaml`
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_logo.jpg"
```

**Steps**:
1. Place your logo image in `assets/images/app_logo.jpg`
2. Add `flutter_launcher_icons` to dev_dependencies
3. Configure the icon path in `flutter_launcher_icons` section
4. Run `flutter pub run flutter_launcher_icons` to generate icons

### 6. Dependencies Used
- `flutter/material.dart` - Core Flutter UI components (built-in)
- `shared_preferences` - For local data persistence
- `flutter_launcher_icons` - For generating app icons (dev dependency)

### 7. Key Code Components

#### Main App Structure
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CallMe',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PhoneDialerPage(),
    );
  }
}
```

#### Keypad Implementation
```dart
GridView.count(
  crossAxisCount: 3,
  children: [
    for (var i = 1; i <= 9; i++)
      ElevatedButton(
        onPressed: () => _appendDigit(i.toString()),
        child: Text(i.toString()),
      ),
    // ... more buttons
  ],
)
```

#### State Management
```dart
class _PhoneDialerPageState extends State<PhoneDialerPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isCalling = false;

  void _dial() {
    // Simulate dialing
    setState(() => _isCalling = true);
  }

  void _endCall() {
    // Reset call state
    setState(() => _isCalling = false);
  }
}
```

## File Structure

```
callme/
├── lib/
│   └── main.dart          # Main app code
├── assets/
│   └── images/
│       └── app_logo.jpg   # App icon source
├── android/               # Android platform code
├── ios/                   # iOS platform code
├── pubspec.yaml           # Project configuration
└── README.md             # This file
```

## How to Run

1. **Install Flutter**: Follow [Flutter installation guide](https://flutter.dev/docs/get-started/install)
2. **Clone/Download** this project
3. **Navigate** to project directory
4. **Install dependencies**:
   ```bash
   flutter pub get
   ```
5. **Generate app icons** (if changing icon):
   ```bash
   flutter pub run flutter_launcher_icons
   ```
6. **Run the app**:
   ```bash
   flutter run
   ```

## For Beginners: Key Concepts Learned

### Flutter Basics
- **Widgets**: Building blocks of Flutter UI
- **State Management**: Using `StatefulWidget` for dynamic content
- **Material Design**: Pre-built UI components

### App Configuration
- **pubspec.yaml**: Where app name, dependencies, and assets are defined
- **Assets**: Images and other resources
- **Icons**: How to set custom launcher icons

### Mobile Development Concepts
- **Platform-specific code**: Android/iOS differences handled by Flutter
- **Dependencies**: Adding packages for extra functionality
- **Build process**: How Flutter compiles to native code

### UI/UX Design
- **Responsive design**: Layouts that work on different screen sizes
- **User interaction**: Buttons, input handling
- **Visual feedback**: SnackBars, state changes

## Customization Guide

### Changing App Name
1. Edit `name` in `pubspec.yaml`
2. Update `title` in `lib/main.dart`
3. Update app bar title

### Changing Colors
1. Modify `primarySwatch` in `MaterialApp` theme
2. Customize button colors using `style` property

### Adding New Features
1. Add new methods in `_PhoneDialerPageState`
2. Update UI in `build` method
3. Handle state changes with `setState()`

### Changing Icon
1. Replace `assets/images/app_logo.jpg`
2. Run `flutter pub run flutter_launcher_icons`

## Troubleshooting

- **Icons not updating**: Clean and rebuild
  ```bash
  flutter clean
  flutter pub get
  flutter pub run flutter_launcher_icons
  ```
- **App not running**: Check Flutter installation
  ```bash
  flutter doctor
  ```

## Next Steps

- Implement call history
- Add vibration/sound effects
- Support for different number formats
- Dark mode support
- Contact search and filtering
- Import contacts from device

---

Built with ❤️ using Flutter
