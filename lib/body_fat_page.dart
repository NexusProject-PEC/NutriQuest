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
        "Body Fat Percentange",style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/body_fat.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button size
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 5, // Shadow effect
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add,color:Colors.white,size: 24),
                    SizedBox(width: 10),
                    Text("New Entry",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ],
                )),
            SizedBox(height: 10,),
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
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button size
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 5, // Shadow effect
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.show_chart,color:Colors.white,size: 24),
                    SizedBox(width: 10),
                    Text("View Progress",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ],
                )),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed: () async {
                  resetProgress();
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button size
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 5, // Shadow effect
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh,color:Colors.white,size: 24),
                    SizedBox(width: 10),
                    Text("Reset Progress",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ],
                )),
          ],
        )),
      ),
    );
  }
}
