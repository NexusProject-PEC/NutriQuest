import 'package:flutter/material.dart';
import 'storage_helper.dart'; // Import storage helper
import 'product_service.dart';

// Import State class

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, String>> _scannedProducts = [];
  bool isScanPage = false;
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

  void _showNutrientDialog(
    Map<String, String> product,
  ) {
    fetchProductData(context, product['barcode']!, isScanPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _scannedProducts.isEmpty
          ? const Center(
              child: Text(
                "No history available",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _scannedProducts.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(
                      _scannedProducts[index]['name'] ?? 'Unknown Product',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      "Scanned on: ${_scannedProducts[index]['time']}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                    onTap: () => _showNutrientDialog(_scannedProducts[index]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearHistory,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }
}
