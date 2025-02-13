import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'progress_page.dart'; // Import progress tracking page

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? gender;

  void proceed() async {
    if (ageController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        gender != null) {
      int age = int.parse(ageController.text);
      double height =
          double.parse(heightController.text) / 100; // Convert cm to meters
      double weight = double.parse(weightController.text);
      double bmi = weight / (height * height);
      double genderFactor = (gender == "Male") ? 1 : 0;

      // Calculate Body Fat Percentage
      double bfp = (1.20 * bmi) + (0.23 * age) - (10.8 * genderFactor) - 5.4;

      // Save progress
      await saveBFP(bfp);

      // Navigate to Progress Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProgressPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  Future<void> saveBFP(double bfp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('bfp_history') ?? [];

    String entry =
        jsonEncode({"date": DateTime.now().toIso8601String(), "bfp": bfp});

    history.add(entry);
    await prefs.setStringList('bfp_history', history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Body Fat Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.cake),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: gender,
              onChanged: (value) => setState(() => gender = value),
              items: ["Male", "Female", "Other"].map((String gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              decoration: InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Height (cm)",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.height),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Weight (kg)",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.fitness_center),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: proceed,
                child: Text("Proceed"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
