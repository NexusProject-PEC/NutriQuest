import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class WaterPage extends StatefulWidget {
  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  // Variables for water tracking
  double _dailyGoal = 2000; // Default daily goal in milliliters
  double _currentIntake = 0; // Track current water intake
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    tz.initializeTimeZones();
    _initializeNotifications();
    super.initState();
    _setReminders();
  }

  // Initialize notifications
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    bool? initializationSuccess =
        await _notificationsPlugin.initialize(initializationSettings);
    if (!initializationSuccess!) {
      print('Notification initialization failed');
    } else {
      print('Notification initialization succeeded');
    }
  }

  // Set hydration reminders
  void _setReminders() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'hydration_reminder',
      'Hydration Reminder',
      channelDescription: 'Reminds you to drink water',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    for (int i = 8; i <= 20; i += 2) {
      final nextTime = _nextInstanceOfTime(i);
      print('Scheduling reminder at $nextTime'); // Debug log
      await _notificationsPlugin.zonedSchedule(
        i,
        'Time to Hydrate!',
        'Drink a glass of water to stay hydrated.',
        nextTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // Calculate the next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Update daily water goal
  void _updateDailyGoal(double newGoal) {
    setState(() {
      _dailyGoal = newGoal;
    });
  }

  // Add water intake
  void _addWater(double amount) {
    setState(() {
      _currentIntake += amount;
    });
  }

  // Test notification (for troubleshooting)
  void _testNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('test_channel', 'Test',
            importance: Importance.high);
    const NotificationDetails details =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
        0, 'Test Notification', 'This is a test', details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Water Intake Progress
            Text(
              'Daily Water Intake',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: _currentIntake / _dailyGoal,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 10),
            Text(
              '${_currentIntake.toInt()}ml / ${_dailyGoal.toInt()}ml',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Add Water Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWaterButton(250),
                _buildWaterButton(500),
                _buildWaterButton(1000),
              ],
            ),
            SizedBox(height: 20),

            // Personalized Water Goal
            Text(
              'Set Your Daily Goal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Slider(
              value: _dailyGoal,
              min: 1000,
              max: 5000,
              divisions: 40,
              label: '${_dailyGoal.toInt()}ml',
              onChanged: (value) {
                _updateDailyGoal(value);
              },
            ),
            SizedBox(height: 20),

            // Hydration Reminders
            Text(
              'Hydration Reminders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You will receive reminders every 2 hours to drink water.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Test Notification Button
            ElevatedButton(
              onPressed: _testNotification,
              child: Text('Test Notification'),
            ),
          ],
        ),
      ),
    );
  }

  // Build a button to add water
  Widget _buildWaterButton(double amount) {
    return ElevatedButton(
      onPressed: () => _addWater(amount),
      child: Text('+${amount.toInt()}ml'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
