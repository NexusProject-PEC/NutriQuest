import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:workmanager/workmanager.dart'; // WorkManager import
import 'scan_page.dart';
import 'history_page.dart';
import 'exercise_page.dart';
import 'feedback.dart';
import 'help_page.dart';
import 'about_us.dart';
import 'water.dart';
import 'search_page.dart';
import 'user_info_page.dart'; // Import WaterPage

// WorkManager callback function
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Background task executed: $task");
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in production
  );

  // Register a simple background task
  await Workmanager().registerOneOffTask(
    "uniqueTaskId",
    "simpleTask",
  );

  runApp(NutrientApp());
}

class NutrientApp extends StatelessWidget {
  const NutrientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NutrientHomePage(),
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(child: Text("Login Page")),
    );
  }
}

class NutrientHomePage extends StatelessWidget {
  NutrientHomePage({super.key});

  // Random nutrient tips
  final List<String> nutrientTips = [
    "Drink plenty of water to stay hydrated throughout the day.",
    "Include healthy fats like avocados and nuts in your diet.",
    "Regular exercise helps maintain a healthy lifestyle.",
    "Balance your meals with a mix of proteins, carbs, and fats.",
    "Avoid processed foods for better nutrition.",
  ];

  String getRandomTip() {
    return nutrientTips[
        (nutrientTips.length * math.Random().nextDouble()).floor()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nutrient Checker"),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Nutrient Checker",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: Text("Stay Healthy!",
                  style: GoogleFonts.poppins(fontSize: 14)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.health_and_safety,
                    size: 40, color: Colors.green),
              ),
              decoration: BoxDecoration(color: Colors.green),
            ),
            _buildDrawerItem(Icons.feedback, "Feedback", () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FeedBack()));
            }),
            _buildDrawerItem(Icons.help, "Help", () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HelpPage()));
            }),
            _buildDrawerItem(Icons.info_outline, "About Us", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()));
            }),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              color: Colors.green[100],
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Welcome to Nutrient Checker",
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Scan barcodes to check nutrition facts and make healthier choices!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Aligned Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAction(
                    context, Icons.qr_code_scanner, "Scan Now", ScanPage()),
                _buildQuickAction(
                    context, Icons.history, "Scan History", HistoryPage()),
                _buildQuickAction(
                    context, Icons.food_bank_rounded, "Intake", SearchPage()),
              ],
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Nutrient Tip",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      getRandomTip(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Explore Nutrients",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildNutrientCard(
                  Icons.local_drink,
                  "Water",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WaterTrackerApp()));
                  },
                ),
                _buildNutrientCard(
                  Icons.favorite,
                  "Fats",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserInfoPage()),
                    );
                  },
                ),
                _buildNutrientCard(
                  Icons.fitness_center,
                  "Exercise",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExercisePage()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String label, Function() onTapCallback) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(label, style: GoogleFonts.poppins(fontSize: 16)),
      onTap: onTapCallback,
    );
  }

  Widget _buildQuickAction(
      BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        width: 100, // Fixed width for all buttons
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[300],
              radius: 30,
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard(IconData icon, String title, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.green[700]),
              SizedBox(height: 8),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
