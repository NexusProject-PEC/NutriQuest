import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Function to save a scanned product with timestamp
Future<void> saveScannedProduct(String productName) async {
  final prefs = await SharedPreferences.getInstance();
  final String currentTime = DateTime.now().toLocal().toString();

  // Create product entry
  Map<String, String> newEntry = {
    'name': productName,
    'time': currentTime,
  };

  // Load existing history
  List<String> historyList = prefs.getStringList('scan_history') ?? [];

  // Add new entry
  historyList.add(jsonEncode(newEntry));

  // Save updated history
  await prefs.setStringList('scan_history', historyList);
}

// Function to load scan history
Future<List<Map<String, String>>> loadScannedHistory() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> historyList = prefs.getStringList('scan_history') ?? [];

  // Convert JSON strings back to List<Map>
  return historyList
      .map((item) => Map<String, String>.from(jsonDecode(item)))
      .toList();
}

// Function to clear history
Future<void> clearScannedHistory() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('scan_history');
}
