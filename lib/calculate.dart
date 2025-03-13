import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CalculatePage extends StatelessWidget {
  final List<dynamic> selectedProducts;

  const CalculatePage({super.key, required this.selectedProducts});

  @override
  Widget build(BuildContext context) {
    double totalCalories = selectedProducts.fold(0, (sum, item) =>
        sum + (((item['calories'] ?? 0).toDouble()) / 100) * double.parse(item['amount'] ?? "0"));

    double totalProteins = selectedProducts.fold(0, (sum, item) =>
        sum + (((item['protein'] ?? 0).toDouble()) / 100) * double.parse(item['amount'] ?? "0"));

    double totalCarbs = selectedProducts.fold(0, (sum, item) =>
        sum + (((item['carbs'] ?? 0).toDouble()) / 100) * double.parse(item['amount'] ?? "0"));

    double totalFat = selectedProducts.fold(0, (sum, item) =>
        sum + (((item['fat'] ?? 0).toDouble()) / 100) * double.parse(item['amount'] ?? "0"));

    double totalConsumption = totalProteins+totalCarbs+totalFat;

    Map<String, double> pieElements = {
      'proteins': (totalProteins/totalConsumption)*100,
      'carbs': (totalCarbs/totalConsumption)*100, 
      'fat': (totalFat/totalConsumption)*100      
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Breakdown"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Today's Calorie Intake",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: _generateChartSections(pieElements), // ✅ Ensure this is correct
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Total Calorie Intake: $totalCalories kcal",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Total protein Intake: $totalProteins g",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                var product = selectedProducts[index];

                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text(
                      "Calories: $totalCalories kcal | "
                      "Proteins: $totalProteins g | " // ✅ Fixed
                      "Carbs: $totalCarbs g |"
                      "Fats: $totalFat"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
List<PieChartSectionData> _generateChartSections(Map<String, double> pieElements) {
  if (pieElements.isEmpty) {
    return [
      PieChartSectionData(
        color: Colors.grey,
        value: 1, // Avoid division by zero
        title: "No Data",
        radius: 60,
        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      )
    ];
  }

  List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.orange];
  int colorIndex = 0;

  return pieElements.entries.map((entry) {
    return PieChartSectionData(
      color: colors[(colorIndex++) % colors.length],
      value: entry.value,
      title: entry.key,
      radius: 60,
      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }).toList();
  }
}