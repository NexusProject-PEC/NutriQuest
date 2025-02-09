import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

class WaterTrackerPage extends StatefulWidget {
  @override
  _WaterTrackerPageState createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  int water = 0;
  int dailyGoal = 3000;
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _customWaterController = TextEditingController();
  final List<String> waterQuotes = [
    "Water is the driving force of all nature. – Leonardo da Vinci",
    "Thousands have lived without love, not one without water. – W. H. Auden",
    "We forget that the water cycle and the life cycle are one. – Jacques Cousteau",
    "Pure water is the world’s first and foremost medicine. – Slovakian Proverb",
    "No water, no life. No blue, no green. – Sylvia Earle",
    "Water is life, and clean water means health. – Audrey Hepburn",
    "Nothing is softer or more flexible than water, yet nothing can resist it. – Lao Tzu"
  ];
  String dailyQuote = "";

  @override
  void initState() {
    super.initState();
    _loadWaterIntake();
    _resetAtMidnight();
    _setDailyQuote();
  }

  Future<void> _loadWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      water = prefs.getInt('waterIntake') ?? 0;
      dailyGoal = prefs.getInt('dailyGoal') ?? 3000;
    });
  }

  Future<void> _saveWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('waterIntake', water);
  }

  Future<void> _saveDailyGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dailyGoal', dailyGoal);
  }

  void _resetAtMidnight() {
    Timer.periodic(Duration(minutes: 1), (timer) async {
      DateTime now = DateTime.now();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? lastReset = prefs.getString('lastReset');
      if (lastReset == null || DateTime.parse(lastReset).day != now.day) {
        setState(() {
          water = 0;
          _setDailyQuote();
        });
        prefs.setInt('waterIntake', 0);
        prefs.setString('lastReset', now.toIso8601String());
      }
    });
  }

  void _setDailyQuote() {
    setState(() {
      dailyQuote = waterQuotes[Random().nextInt(waterQuotes.length)];
    });
  }

  void addWater(int amount) {
    setState(() {
      water = (water + amount).clamp(0, dailyGoal);
    });
    _saveWaterIntake();
  }

  void _setCustomGoal() {
    int newGoal = int.tryParse(_goalController.text) ?? dailyGoal;
    setState(() {
      dailyGoal = newGoal;
    });
    _saveDailyGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          'Water Intake Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // When this widget is pushed onto the stack, Flutter automatically shows a default back button.
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      dailyQuote,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: water / dailyGoal,
                      minHeight: 15,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$water ml / $dailyGoal ml',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Set Daily Goal (ml)",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: _setCustomGoal,
              child: Text("Set Goal"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _customWaterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Water Amount (ml)",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int customAmount =
                    int.tryParse(_customWaterController.text) ?? 0;
                if (customAmount > 0) {
                  addWater(customAmount);
                }
              },
              child: Text("Add Water"),
            ),
          ],
        ),
      ),
    );
  }
}

