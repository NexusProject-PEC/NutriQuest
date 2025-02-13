import 'package:flutter/material.dart';
import 'storage_helper.dart'; // Import storage helper
// Import State class

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

  void _showNutrientDialog(Map<String, String> product) {
    showDialog(
      context: context,
      builder: (context) => NutrientDetailsDialog(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
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

class NutrientDetailsDialog extends StatelessWidget {
  final Map<String, String> product;

  const NutrientDetailsDialog({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        product['name'] ?? 'Unknown Product',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Table(
            border: TableBorder.all(color: Colors.blueAccent, width: 1),
            columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
            children: _buildTableRows(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> rows = [
      TableRow(
        children: [
          _buildTableCell("Nutrient", isHeader: true),
          _buildTableCell("Value", isHeader: true),
        ],
      ),
    ];

    if (product['nutrients'] != null) {
      List<String> nutrients = product['nutrients']!.split(', ');
      for (String nutrient in nutrients) {
        List<String> parts = nutrient.split(': ');
        if (parts.length == 2) {
          rows.add(TableRow(
            children: [
              _buildTableCell(parts[0]),
              _buildTableCell(parts[1]),
            ],
          ));
        }
      }
    }
    return rows;
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(8), // ✅ Move padding inside Container
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 18 : 16,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
