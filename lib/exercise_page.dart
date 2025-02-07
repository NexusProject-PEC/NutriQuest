import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your Weight Level"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Choose your body type:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),

          // Weight Level Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeightOption(
                  context, "Underweight", "assets/underweight.png"),
              _buildWeightOption(context, "Normal", "assets/normal.png"),
              _buildWeightOption(
                  context, "Overweight", "assets/overweight.png"),
            ],
          ),
        ],
      ),
    );
  }

  // Weight Selection Button
  Widget _buildWeightOption(
      BuildContext context, String label, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExerciseSuggestionPage(weightType: label)),
        );
      },
      child: Column(
        children: [
          Image.asset(imagePath, width: 80, height: 80),
          SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Exercise Suggestion Page
class ExerciseSuggestionPage extends StatelessWidget {
  final String weightType;
  const ExerciseSuggestionPage({super.key, required this.weightType});

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, dynamic>> exercisePlans = {
      "Underweight": {
        "calorieIntake": {
          "text": "Increase calorie intake by 500-1000 calories per day.",
          "image": "assets/High-Calorie-Foods-2-1.jpg",
        },
        "cardio": {
          "text": "Light cardio (e.g., walking, yoga) 2-3 times a week.",
          "image": "assets/yoga-tree-pose.png",
        },
        "workout": {
          "text":
              "Focus on strength training (e.g., weightlifting) 4-5 times a week.",
          "image": "assets/weight.jpg",
        },
        "healthSuggestions": {
          "text":
              "Eat calorie-dense foods like nuts, avocados, and whole grains. Avoid skipping meals.",
          "image": "assets/nuts.jpg",
        },
      },
      "Normal": {
        "calorieIntake": {
          "text":
              "Maintain a balanced calorie intake based on your activity level.",
          "image": "assets/balanced_diet.jpg",
        },
        "cardio": {
          "text": "Moderate cardio (e.g., jogging, cycling) 3-4 times a week.",
          "image": "assets/cycling.webp",
        },
        "workout": {
          "text":
              "Combine strength training and cardio 3-5 times a week for overall fitness.",
          "image": "assets/fitness-logo-vector.jpg",
        },
        "healthSuggestions": {
          "text":
              "Eat a balanced diet with plenty of fruits, vegetables, and lean proteins. Stay hydrated.",
          "image": "assets/fruits.jpg",
        },
      },
      "Overweight": {
        "calorieIntake": {
          "text": "Reduce calorie intake by 500-750 calories per day.",
          "image": "assets/low_calorie_food.jpg",
        },
        "cardio": {
          "text":
              "High-intensity cardio (e.g., running, swimming) 4-5 times a week.",
          "image": "assets/running.jpg",
        },
        "workout": {
          "text":
              "Focus on cardio and full-body workouts (e.g., HIIT) 5-6 times a week.",
          "image": "assets/hiit.webp",
        },
        "healthSuggestions": {
          "text":
              "Limit processed foods and sugary drinks. Incorporate more fiber-rich foods and lean proteins.",
          "image": "assets/fiber.jpg",
        },
      },
    };

    final plan = exercisePlans[weightType] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Plan for $weightType"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlanCard(
                context,
                "Calorie Intake",
                plan["calorieIntake"]["text"],
                plan["calorieIntake"]["image"],
              ),
              SizedBox(height: 16),
              _buildPlanCard(
                context,
                "Cardio Recommendations",
                plan["cardio"]["text"],
                plan["cardio"]["image"],
              ),
              SizedBox(height: 16),
              _buildPlanCard(
                context,
                "Workout Plan",
                plan["workout"]["text"],
                plan["workout"]["image"],
              ),
              SizedBox(height: 16),
              _buildPlanCard(
                context,
                "Health Suggestions",
                plan["healthSuggestions"]["text"],
                plan["healthSuggestions"]["image"],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a Card for Each Plan Section
  Widget _buildPlanCard(
      BuildContext context, String title, String text, String imagePath) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(imagePath, width: 60, height: 60),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
