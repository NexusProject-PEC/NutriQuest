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
      String getAgeGroup(int age) {
        if (age < 16) return "U16";
        if (age >= 17 && age <= 29) return "17-29";
        if (age >= 30 && age <= 39) return "30-39";
        if (age >= 40 && age <= 49) return "40-49";
        if (age >= 50 && age <= 65) return "50-65";
        if (age > 65) return "A65";
        return "Unknown";
      }     

      String ageGroup = getAgeGroup(age);
      String getFatCat(String ageGroup,String ? gender,double bfp){
        final Map<String, Map<String, List<int>>> bodyFatRanges = {
        'U16': {
          'Male': [5, 12, 18, 25, 30],  // Essential, Athletic, Average, Overweight, Obese
          'Female': [10, 18, 24, 30, 35]
        },
        '17-29': {
          'Male': [6, 14, 20, 26, 32],
          'Female': [14, 22, 28, 34, 40]
        },
        '30-39': {
          'Male': [8, 16, 22, 28, 34],
          'Female': [16, 24, 30, 36, 42]
        },
        '40-49': {
          'Male': [10, 18, 24, 30, 36],
          'Female': [18, 26, 32, 38, 44]
        },
        '50-65': {
          'Male': [12, 20, 26, 32, 38],
          'Female': [20, 28, 34, 40, 46]
        },
        'A65': {
          'Male': [14, 22, 28, 34, 40],
          'Female': [22, 30, 36, 42, 48]
        }
      };
      List<int> ranges= bodyFatRanges[ageGroup]![gender]!;
      if (bfp < ranges[0]) return 'Essential Fat';
      if (bfp < ranges[1]) return 'Athletic';
      if (bfp < ranges[2]) return 'Average';
      if (bfp < ranges[3]) return 'Overweight';
      return 'Obese';
      }


      // Calculate Body Fat Percentage
      double bfp = (1.20 * bmi) + (0.23 * age) - (10.8 * genderFactor) - 5.4;

      // Save progress
      await saveBFP(bfp,getFatCat(ageGroup, gender, bfp));

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

  Future<void> saveBFP(double bfp , String fatCategory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('bfp_history') ?? [];

    String entry =
        jsonEncode({"date": DateTime.now().toIso8601String(), "bfp": bfp , "category": fatCategory});
    history.add(entry);
    await prefs.setStringList('bfp_history', history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Body Fat Calculator",style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,),
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
