import 'package:flutter/material.dart';

import '../servies/notification_service.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Notifications')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotificationService().showNotification(
              title: 'Hello!',
              body: 'This is a test notification.',
            );
          },
          child: const Text('Show Simple Notification'),
        ),
      ),
    );
  }
}
