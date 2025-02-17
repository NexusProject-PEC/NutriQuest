import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'progress_graph_page.dart'; // Ensure this file exists and contains the ProgressGraphPage class

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> bfpHistory = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('bfp_history') ?? [];

    setState(() {
      bfpHistory = history
          .map((entry) {
            return jsonDecode(entry) as Map<String, dynamic>;
          })
          .toList()
          .cast<Map<String, dynamic>>();
    });
  }

  void resetProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('bfp_history');
    setState(() {
      bfpHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BFP Progress",style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Body Fat Percentage Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bfpHistory.length,
                itemBuilder: (context, index) {
                  final entry = bfpHistory[index];
                  return ListTile(
                    title: Text(
                        "BFP: ${(entry['bfp'] as num).toStringAsFixed(2)}%"),
                    subtitle: Text("Date: ${entry['date']}"),
                    leading: Icon(Icons.fitness_center, color: Colors.blue),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BodyFatProgressPage(progressData: bfpHistory),
                  ),
                );
              },
              child: Text("View Progress Graph"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: resetProgress,
              child: Text("Reset Progress"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
