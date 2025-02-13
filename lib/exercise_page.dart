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
          Text(
            "Choose your body type:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
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

  Widget _buildWeightOption(
      BuildContext context, String label, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FullExercisePlanPage(weightCategory: label)),
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

class FullExercisePlanPage extends StatelessWidget {
  final String weightCategory;
  const FullExercisePlanPage({super.key, required this.weightCategory});

  @override
  Widget build(BuildContext context) {
    final exercisePlans = {
      "Underweight": [
        {
          "title": "Workout Plan (Strength Focus)",
          "description": "Focus on weight lifting with progressive overload.",
          "exercises": [
            {
              "name": "Squats",
              "image": "assets/squats.jpg",
              "sets": "4",
              "reps": "8-12"
            },
            {
              "name": "Deadlifts",
              "image": "assets/deadlift.jpg",
              "sets": "3",
              "reps": "6-10"
            },
            {
              "name": "Bench Press",
              "image": "assets/benchpress.jpg",
              "sets": "4",
              "reps": "8-12"
            },
            {
              "name": "Pull-ups",
              "image": "assets/pullups.jpg",
              "sets": "3",
              "reps": "8-10"
            },
            {
              "name": "Shoulder Press",
              "image": "assets/shoulder press.webp",
              "sets": "3",
              "reps": "10-12"
            },
          ]
        }
      ],
      "Normal": [
        {
          "title": "Balanced Strength & Cardio",
          "description": "A mix of strength and endurance training.",
          "exercises": [
            {
              "name": "Push-ups",
              "image": "assets/push up.jpg",
              "sets": "3",
              "reps": "12-15"
            },
            {
              "name": "Lunges",
              "image": "assets/lunges.png",
              "sets": "3",
              "reps": "10-12"
            },
            {
              "name": "Plank",
              "image": "assets/planks.jpg",
              "sets": "3",
              "reps": "Hold for 30 sec"
            },
            {
              "name": "Jump Rope",
              "image": "assets/jumpropes.webp",
              "sets": "3",
              "reps": "1 min"
            },
            {
              "name": "Burpees",
              "image": "assets/burpees.jpg",
              "sets": "3",
              "reps": "10"
            },
          ]
        }
      ],
      "Overweight": [
        {
          "title": "Fat Loss Focus",
          "description": "High-intensity workouts focusing on weight loss.",
          "exercises": [
            {
              "name": "Jumping Jacks",
              "image": "assets/jumping jacks.jpg",
              "sets": "3",
              "reps": "30 sec"
            },
            {
              "name": "Plank",
              "image": "assets/planks.jpg",
              "sets": "3",
              "reps": "Hold for 40 sec"
            },
            {
              "name": "Mountain Climbers",
              "image": "assets/mountain climbers.jpg",
              "sets": "3",
              "reps": "40 sec"
            },
            {
              "name": "Squats",
              "image": "assets/squats.jpg",
              "sets": "3",
              "reps": "15"
            },
            {
              "name": "High Knees",
              "image": "assets/high knees.jpg",
              "sets": "3",
              "reps": "30 sec"
            },
          ]
        }
      ]
    };

    final plan = exercisePlans[weightCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Plan for $weightCategory"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: plan.map((item) {
            return _buildPlanCard(context, item);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item["title"],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 8),
            Text(item["description"], style: TextStyle(fontSize: 16)),
            if (item["exercises"] != null) ...[SizedBox(height: 12)],
            Column(
              children: item["exercises"].map<Widget>((exercise) {
                return _buildExerciseTile(exercise);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTile(Map<String, String> exercise) {
    return ExpansionTile(
      title: Row(
        children: [
          Image.asset(exercise["image"]!, width: 40, height: 40),
          SizedBox(width: 10),
          Text(exercise["name"]!, style: TextStyle(fontSize: 16)),
        ],
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, bottom: 10),
          child: Text("${exercise["sets"]} sets × ${exercise["reps"]} reps",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        )
      ],
    );
  }
}
