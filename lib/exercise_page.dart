import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  String? selectedGender;
  String? selectedBodyPart;
  String? selectedGoal;
  String? selectedActivityLevel;
  String name = '';
  String reps = '';
  String targetMuscle = '';
  List<dynamic> exercises = [];

  final Map<String, String> bodyParts = {
    'Upper Body': 'Upper Body',
    'Lower Body': 'Lower Body',
    'Full Body': 'Full Body',
  };

  final Map<String, String> goals = {
    'Lose Weight': 'Lose Weight',
    'Gain Weight': 'Gain Weight',
    'Maintain Weight': 'Maintain Weight   ',
  };

  final Map<String, String> activityLevels = {
    'Less Active': 'Less Active',
    'Moderate Active': 'Moderate Active',
    'High Active': 'High Active',
  };

  Future<void> loadExercises() async {
    // Load the appropriate JSON file based on gender
    String jsonFile = selectedGender == 'Male'
        ? 'male_exercise.json'
        : 'female_exercise.json';
    String data = await rootBundle.loadString(jsonFile);
    List<dynamic> jsonData = json.decode(data);

    // Filter exercises based on user inputs
    setState(() {
      exercises = jsonData
          .where((exercise) =>
              exercise['target_area'] == selectedBodyPart &&
              exercise['fitness_goal'] == selectedGoal &&
              exercise['activity_level'] == selectedActivityLevel)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gender Selection
            DropdownButton<String>(
              value: selectedGender,
              hint: Text('Select Gender'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
              items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Body Part Selection
            DropdownButton<String>(
              value: selectedBodyPart,
              hint: Text('Select Body Part'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedBodyPart = newValue;
                });
              },
              items:
                  bodyParts.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Fitness Goal Selection
            DropdownButton<String>(
              value: selectedGoal,
              hint: Text('Select Fitness Goal'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGoal = newValue;
                });
              },
              items: goals.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Activity Level Selection
            DropdownButton<String>(
              value: selectedActivityLevel,
              hint: Text('Select Activity Level'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivityLevel = newValue;
                });
              },
              items: activityLevels.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (selectedGender != null &&
                    selectedBodyPart != null &&
                    selectedGoal != null &&
                    selectedActivityLevel != null) {
                  loadExercises();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text('Get Exercises'),
            ),
            SizedBox(height: 20),

            // Display Exercises
            Expanded(
              child: exercises.isEmpty
                  ? Center(
                      child: Text(
                          'No exercises found. Please select options and click "Get Exercises".'))
                  : ListView.builder(
                      itemCount: exercises
                          .expand((exercise) => exercise['exercises'])
                          .length,
                      itemBuilder: (context, index) {
                        var allExercise = exercises
                            .expand((exercise) => exercise['exercises'])
                            .toList();
                        var exercise = allExercise[index];
                        return Card(
                          child: ListTile(
                            title: Text(exercise['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reps: ${exercise['reps']}'),
                                Text('Target: ${exercise['target_muscle']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
