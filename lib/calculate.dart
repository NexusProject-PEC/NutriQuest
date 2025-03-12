import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CalculatePage extends StatelessWidget {
  final List<dynamic> selectedProducts;

  const CalculatePage({super.key, required this.selectedProducts});
  
  @override
  Widget build(BuildContext context) {
    double totalCalories =
        selectedProducts.fold(0, (sum, item) => sum + (item['calories']/100)*double.parse(item['amount']));

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
            height: 250, // Size of the graph
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50, // Makes it a ring instead of a full pie
                sections: _generateChartSections(selectedProducts),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Total Calorie Intake: $totalCalories",
            style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                var product = selectedProducts[index];
                double amt = double.parse(product['amount']);
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text("Calories: ${(product['calories']/100)*amt} kcal | Proteins: ${(product['protein']/100)*amt} g | Carbs: ${(product['carbs']/100)*amt}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateChartSections(List<dynamic> products) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      const Color.fromARGB(255, 115, 74, 74),
      Colors.pink
    ];

    return products.asMap().entries.map((entry) {
      int index = entry.key;
      var product = entry.value;
      return PieChartSectionData(
        color: colors[index % colors.length], // Cycle through colors
        value: product['calories'].toDouble(),
        title: "${(product['calories']/100) * double.parse(product['amount'])} kcal",
        radius: 60, // Ring thickness
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }
}
