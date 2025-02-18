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
    String data = await rootBundle.loadString('assets/products_1.json');
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

  void _toggleSelection(dynamic product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${product['name']} removed"),
            duration: Duration(milliseconds: 500),
          ),
        );
      } else {
        _selectedProducts.add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${product['name']} added"),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Products",style: TextStyle(fontWeight: FontWeight.bold),),
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
                      bool isSelected = _selectedProducts.contains(product);
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
