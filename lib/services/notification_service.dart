import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  NotificationService._init();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
  }

  Future<void> showScanCompleteNotification(String diseaseName, double confidence) async {
    const androidDetails = AndroidNotificationDetails(
      'scan_complete',
      'Scan Complete',
      channelDescription: 'Notifications for completed scans',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      'Scan Complete! 🍌',
      'Detected: $diseaseName (${(confidence * 100).toStringAsFixed(0)}% confidence)',
      details,
      payload: 'scan_complete',
    );
  }

  Future<void> showDiseaseAlertNotification(String diseaseName, String severity) async {
    if (severity == 'None') return;

    const androidDetails = AndroidNotificationDetails(
      'disease_alert',
      'Disease Alerts',
      channelDescription: 'Alerts for detected diseases',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final emoji = severity == 'Critical' ? '🚨' : severity == 'High' ? '⚠️' : '📋';

    await _notifications.show(
      1,
      '$emoji Disease Detected',
      '$diseaseName - $severity severity. Check treatment recommendations.',
      details,
      payload: 'disease_alert',
    );
  }

  Future<void> showReminderNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'Daily scan reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      2,
      'Time to Check Your Plants! 🌱',
      'Regular monitoring helps catch diseases early.',
      details,
      payload: 'reminder',
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
