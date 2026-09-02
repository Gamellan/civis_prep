import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:civis_prep/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('NotificationService', () {
    test('guarda la configuración del recordatorio', () async {
      await NotificationService.scheduleDailyReminder(hour: 21, minute: 30);
      final settings = await NotificationService.getReminderSettings();

      expect(settings['enabled'], isTrue);
      expect(settings['hour'], 21);
      expect(settings['minute'], 30);
    });
  });
}
