import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'app_storage_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static final AppStorageService _storage = AppStorageService();

  static Future<void> initialize() async {
    try {
      tz_data.initializeTimeZones();
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const settings = InitializationSettings(android: androidSettings);
      await _notifications.initialize(settings);
    } catch (_) {}
  }

  static Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    await _storage.setInt('reminder_hour', hour);
    await _storage.setInt('reminder_minute', minute);
    await _storage.setBool('reminder_enabled', true);

    try {
      await _notifications.zonedSchedule(
        1,
        'Racha de estudio',
        'Es un buen momento para practicar CCSE o DELE.',
        _nextInstanceOfTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'study_reminder_channel',
            'Recordatorios de estudio',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {}
  }

  static Future<void> cancelReminder() async {
    await _storage.setBool('reminder_enabled', false);
    try {
      await _notifications.cancel(1);
    } catch (_) {}
  }

  static Future<Map<String, dynamic>> getReminderSettings() async {
    return {
      'enabled': await _storage.getBool('reminder_enabled') ?? false,
      'hour': await _storage.getInt('reminder_hour') ?? 20,
      'minute': await _storage.getInt('reminder_minute') ?? 0,
    };
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Madrid'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
