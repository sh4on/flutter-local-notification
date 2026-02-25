import 'package:flutter/material.dart';
import 'package:local_notification_p/servies/notification_service.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init notification service
  await NotificationService().initNotifications();

  // request permissions
  NotificationService().requestPermissions();

  runApp(const MyApp());
}
