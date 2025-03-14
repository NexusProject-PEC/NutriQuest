import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math';
import 'package:NutriQuest/main.dart'; // Adjust the path if needed

void main() {
  runApp(WaterTrackerApp());
}

Future<void> resetWaterIntake() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('waterIntake', 0);
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: WaterTracker(),
    );
  }
}

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  _WaterTrackerState createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  int water = 0;
  int dailyGoal = 2000;
  final Map<String, int> waterIntakeMap = {
    "Children 4–8": 1200,
    "Children 9–13": 1800,
    "Children 14–18": 2200,
    "Men 19+": 3000,
    "Women 19+": 2400,
    "Pregnant Women": 2400,
    "Breastfeeding Women": 3000,
  };
  String selectedCategory = "Men 19+";
  final List<String> waterQuotes = [
    "Water is the driving force of all nature. – Leonardo da Vinci",
    "Thousands have lived without love, not one without water. – W. H. Auden",
    "Water is life, and clean water means health. – Audrey Hepburn",
  ];
  String dailyQuote = "";

  @override
  void initState() {
    super.initState();
    _loadWaterIntake();
    _setDailyQuote();
  }

  Future<void> _loadWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      water = prefs.getInt('waterIntake') ?? 0;
      dailyGoal = waterIntakeMap[selectedCategory] ?? 2000;
    });
  }

  Future<void> _saveWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('waterIntake', water);
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

  void resetWater() {
    setState(() {
      water = 0;
    });
    _saveWaterIntake();
  }

  void setCategory(String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Change"),
          content: Text(
              "Are you sure you want to change the category? This will reset your progress."),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                setState(() {
                  selectedCategory = category;
                  dailyGoal = waterIntakeMap[category] ?? 2000;
                  water = 0;
                });
                _saveWaterIntake();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        title: Text('Water Intake Tracker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NutrientApp()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetWater,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(dailyQuote,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey)),
            SizedBox(height: 20),
            Text('Selected: $selectedCategory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            LinearProgressIndicator(
              value: water / dailyGoal,
              minHeight: 15,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Text('$water ml / $dailyGoal ml',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: waterIntakeMap.entries.map((entry) {
                  return Card(
                    child: ListTile(
                      title: Text('${entry.key} - ${entry.value} ml'),
                      trailing: ElevatedButton(
                        onPressed: () => setCategory(entry.key),
                        child: Text('Choose'),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => addWater(250),
                  child: Text("+250ml"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => addWater(500),
                  child: Text("+500ml"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
