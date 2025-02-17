import 'package:flutter/material.dart';
import 'user_info_page.dart';
import 'progress_graph_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<Map<String, dynamic>>> getBFP() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('bfp_history') ?? [];
  List<Map<String, dynamic>> bfpHistory = history
      .map((entry) {
        return jsonDecode(entry) as Map<String, dynamic>;
      })
      .toList()
      .cast<Map<String, dynamic>>();
  return bfpHistory;
}
void resetProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('bfp_history');
  }
class BodyFatLander extends StatelessWidget {
  const BodyFatLander({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Body Fat Percentange",
      )),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(),
                  ),
                );
              },
              child: Text("New Entry")),
          ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>> bfpData = await getBFP();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BodyFatProgressPage(progressData: bfpData),
                  ),
                );
              },
              child: Text("View Progress")),
          ElevatedButton(
              onPressed: () async {
                resetProgress();
              },
              child: Text("Reset Progress")),
        ],
      )),
    );
  }
}
