import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BodyFatProgressPage extends StatelessWidget {
  final List<Map<String, dynamic>> progressData;

  BodyFatProgressPage({required this.progressData});

  @override
  Widget build(BuildContext context) {
    if (progressData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Body Fat Progress",style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,),
        body: Center(
          child: Text(
            "No progress data available.\nPlease add data first.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Extract dates and body fat values
    List<DateTime> dates =
        progressData.map((entry) => DateTime.parse(entry['date'])).toList();
    List<double> bodyFatValues =
        progressData.map((entry) => (entry['bfp'] as num).toDouble()).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Body Fat Progress")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Body Fat Percentage Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < dates.length) {
                            return Transform.rotate(
                              angle: -0.5, // Rotate labels for readability
                              child: Text(
                                DateFormat("MMM d").format(dates[index]),
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return Container();
                        },
                        reservedSize: 30,
                        interval: 1, // Ensures consistent spacing
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50, // Increased for better alignment
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1), // Show one decimal place
                            style: TextStyle(fontSize: 12),
                          );
                        },
                        interval: 1, // Ensures correct spacing on Y-axis
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  minX: 0,
                  maxX: (dates.length - 1).toDouble(),
                  minY: bodyFatValues.reduce((a, b) => a < b ? a : b) - 1,
                  maxY: bodyFatValues.reduce((a, b) => a > b ? a : b) + 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        bodyFatValues.length,
                        (index) =>
                            FlSpot(index.toDouble(), bodyFatValues[index]),
                      ),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
