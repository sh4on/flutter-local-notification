# Flutter Local Notifications Project

This project demonstrates how to implement local notifications in a Flutter application using the `flutter_local_notifications` package (version 20.x). It covers initialization, permission handling, and displaying notifications on both Android and iOS.

## Features

- **Singleton Notification Service**: Centralized management of notification logic.
- **Android 13+ Support**: Handles the new `POST_NOTIFICATIONS` permission.
- **iOS Foreground Notifications**: Configured to show alerts, badges, and play sounds even when the app is in the foreground.
- **Core Library Desugaring**: Configured for Android to support modern Java APIs required by the plugin.

## Setup Instructions

### 1. Dependencies

Added to `pubspec.yaml`:
```yaml
dependencies:
  flutter_local_notifications: ^20.1.0
```

### 2. Android Configuration

#### AndroidManifest.xml
Added the following permission:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

#### build.gradle.kts (app level)
To support the plugin's requirements, **Core Library Desugaring** is enabled:
```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        // ...
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
```

### 3. iOS Configuration

#### AppDelegate.swift
Ensure the following is present to handle notification presentation while the app is in the foreground:
```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```

## How it Works

### Notification Service (`lib/servies/notification_service.dart`)

The project uses a `NotificationService` class implemented as a singleton to manage all notification-related tasks.

#### Initialization
Initializes settings for both Android (using `@mipmap/ic_launcher`) and iOS.
```dart
await flutterLocalNotificationsPlugin.initialize(
  settings: initializationSettings,
  onDidReceiveNotificationResponse: (details) {
    // Handle notification tap
  },
);
```

#### Requesting Permissions
Explicitly requests permissions for Android 13+ and iOS.
```dart
Future<void> requestPermissions() async {
  // Android 13+ permission
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // iOS permissions
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<DarwinFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
}
```

#### Showing a Notification
Triggers a notification with specific platform details. Note that the method now takes `title` and `body` as required named parameters.

```dart
Future<void> showNotification({
  required String title,
  required String body,
}) async {
  const NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Main channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true, // Required to show notification in foreground on iOS
      presentBadge: true,
      presentSound: true,
    ),
  );

  await flutterLocalNotificationsPlugin.show(
    id: 0,
    title: title,
    body: body,
    notificationDetails: notificationDetails,
    payload: 'item_id_123',
  );
}
```

## Usage

1. **Initialize** in `main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await NotificationService().initNotifications();
     runApp(const MyApp());
   }
   ```
2. **Request Permissions** (usually in `main.dart` or `initState` of your home page).
3. **Trigger Notification**:
   ```dart
   NotificationService().showNotification(
     title: 'Hello!',
     body: 'This is a test notification.',
   );
   ```

## Troubleshooting

- **iOS Notifications not showing in foreground**: Ensure `DarwinNotificationDetails` has `presentAlert: true` and is passed to `NotificationDetails`.
- **Android Build Error (`CheckAarMetadata`)**: Ensure Core Library Desugaring is enabled in `build.gradle.kts`.
- **Compiler Errors on `initialize` or `show`**: This project uses version 20.x, which requires **named parameters** for these methods.
