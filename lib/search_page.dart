import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'calculate.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> _products = [];
  List<dynamic> _filteredProducts = [];
  List<dynamic> _selectedProducts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    String data = await rootBundle.loadString('assets/products.json');
    setState(() {
      _products = json.decode(data);
      _filteredProducts = _products;
    });
  }

  void _searchProduct(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  bool _isNumeric(String str) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(str);
  }

  void _toggleSelection(dynamic product) async {
    if (_selectedProducts.any((p) => p['name'] == product['name'])) {
      setState(() {
        _selectedProducts.removeWhere((p) => p['name'] == product['name']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${product['name']} removed"),
            duration: Duration(milliseconds: 100),
          ),
        );
      });
    } else {
      // Wait for the user to enter an amount
      String? amount = await _showPopup(context);

      if (amount != null && amount.isNotEmpty) {
        setState(() {
          // Create a new object before adding it
          var newProduct = Map<String, dynamic>.from(product);
          newProduct['amount'] = amount;
          _selectedProducts.add(newProduct);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${product['name']} added"),
            duration: Duration(milliseconds: 100),
          ),
        );
      }
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedProducts.clear();
    });
  }

  void _navigateToCalculatePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CalculatePage(selectedProducts: _selectedProducts),
      ),
    );
  }

  Future<String?> _showPopup(BuildContext context) async {
    TextEditingController amtController = TextEditingController();
    bool isValid = false;

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // Prevents user from closing without choosing
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Amount of Consumption"),
              content: TextField(
                controller: amtController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter in grams',
                ),
                onChanged: (value) {
                  setDialogState(() {
                    isValid =
                        _isNumeric(value.trim()) && value.trim().isNotEmpty;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null); // User canceled
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isValid
                      ? () {
                          Navigator.of(context).pop(amtController.text.trim());
                        }
                      : null, // Disable button when invalid
                  child: Text("Enter"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Products",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search for a product",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: _searchProduct,
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(child: Text("No results found"))
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      var product = _filteredProducts[index];
                      bool isSelected = _selectedProducts
                          .any((p) => p['name'] == product['name']);
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(product['name'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            "Calories: ${product['calories']} kcal\n"
                            "Fat: ${product['fat']} g | Protein: ${product['protein']} g | Carbs: ${product['carbs']} g",
                          ),
                          trailing: Icon(
                            isSelected ? Icons.check_circle : Icons.add_circle,
                            color: isSelected ? Colors.green : Colors.grey,
                          ),
                          onTap: () => _toggleSelection(product),
                        ),
                      );
                    },
                  ),
          ),
          if (_selectedProducts.isNotEmpty)
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected (${_selectedProducts.length})",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _clearSelection,
                        child: Text("Clear Selection"),
                      ),
                      ElevatedButton(
                        onPressed: _navigateToCalculatePage,
                        child: Text("Calculate"),
                      ),
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
