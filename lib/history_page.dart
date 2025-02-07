import 'package:flutter/material.dart';
import 'storage_helper.dart'; // Import storage helper

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, String>> _scannedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    List<Map<String, String>> history = await loadScannedHistory();
    setState(() {
      _scannedProducts = history;
    });
  }

  Future<void> _clearHistory() async {
    await clearScannedHistory();
    setState(() {
      _scannedProducts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan History")),
      body: _scannedProducts.isEmpty
          ? Center(child: Text("No history available"))
          : ListView.builder(
              itemCount: _scannedProducts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      _scannedProducts[index]['name'] ?? 'Unknown Product'),
                  subtitle:
                      Text("Scanned on: ${_scannedProducts[index]['time']}"),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearHistory,
        child: Icon(Icons.delete),
      ),
    );
  }
}
