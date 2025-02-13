import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'storage_helper.dart'; // Helper for saving scanned products

Future<void> fetchProductData(
    BuildContext context, String barcode, bool isScanPage) async {
  final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final product = data['product'];
      if (product != null) {
        // Extract product details
        final productName = product['product_name'] ?? 'Unknown Product';
        final nutriments = product['nutriments'] ?? {};
        final energyKcal = nutriments['energy-kcal']?.toString() ?? 'No data';
        final fat = nutriments['fat']?.toString() ?? 'No data';
        final saturatedFat =
            nutriments['saturated-fat']?.toString() ?? 'No data';
        final carbohydrates =
            nutriments['carbohydrates']?.toString() ?? 'No data';
        final sugars = nutriments['sugars']?.toString() ?? 'No data';
        final proteins = nutriments['proteins']?.toString() ?? 'No data';
        final salt = nutriments['salt']?.toString() ?? 'No data';

        // Parse allergens
        List<String> allergens = [];
        if (product['allergens_tags'] != null &&
            product['allergens_tags'] is List) {
          allergens = List<String>.from(product['allergens_tags'])
              .map((e) => e.replaceAll("en:", "").replaceAll("fr:", ""))
              .toList();
        }

        // Fetch Nutri-Score
        String nutriScore = '';
        if (product['nutriscore_2023_tags'] != null &&
            product['nutriscore_2023_tags'] is List &&
            product['nutriscore_2023_tags'].isNotEmpty) {
          nutriScore =
              product['nutriscore_2023_tags'][0].toString().toUpperCase();
        }

        // Save product to history
        if (isScanPage) {
          saveScannedProduct(productName, barcode);
        }
        // Navigate to ProductDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              barcode: barcode,
              productName: productName,
              energyKcal: energyKcal,
              fat: fat,
              saturatedFat: saturatedFat,
              carbohydrates: carbohydrates,
              sugars: sugars,
              proteins: proteins,
              salt: salt,
              allergens: allergens,
              nutriScore: nutriScore,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Product not found.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch product data.")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error fetching data: $e")));
  }
}

// -------------------- ProductDetailScreen --------------------
class ProductDetailScreen extends StatelessWidget {
  final String barcode;
  final String productName;
  final String energyKcal;
  final String fat;
  final String saturatedFat;
  final String carbohydrates;
  final String sugars;
  final String proteins;
  final String salt;
  final List<String> allergens;
  final String nutriScore;

  const ProductDetailScreen({
    Key? key,
    required this.barcode,
    required this.productName,
    required this.energyKcal,
    required this.fat,
    required this.saturatedFat,
    required this.carbohydrates,
    required this.sugars,
    required this.proteins,
    required this.salt,
    required this.allergens,
    required this.nutriScore,
  }) : super(key: key);

  /// Returns a color corresponding to the Nutri-Score grade.
  Color _getNutriScoreColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar now displays the product name.
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product header card showing name and Nutri-Score (if available).
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (nutriScore.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getNutriScoreColor(nutriScore),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Nutri-Score: $nutriScore',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nutrient Data Table card.
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nutrient')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Energy (kcal)')),
                      DataCell(Text(energyKcal)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Fat (g)')),
                      DataCell(Text(fat)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Saturated Fat (g)')),
                      DataCell(Text(saturatedFat)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Carbohydrates (g)')),
                      DataCell(Text(carbohydrates)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Sugars (g)')),
                      DataCell(Text(sugars)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Proteins (g)')),
                      DataCell(Text(proteins)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Salt (g)')),
                      DataCell(Text(salt)),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Allergen Information card.
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Allergen Information",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    allergens.isNotEmpty
                        ? Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: allergens
                                .map((allergen) => Chip(
                                      label: Text(allergen),
                                      backgroundColor: Colors.red[100],
                                    ))
                                .toList(),
                          )
                        : const Text("No allergen information available."),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Display the barcode at the bottom.
            Text(
              "Barcode: $barcode",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
