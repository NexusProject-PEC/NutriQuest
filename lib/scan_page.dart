import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'storage_helper.dart'; // Import storage helper

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String _barcode = '';
  String _productName = '';
  String _calories = '';
  String _protein = '';
  String _fat = '';
  String _carbohydrates = '';
  bool _isLoading = false; // Track loading state

  // Function to scan barcode and fetch nutritional info
  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);

    if (barcode != '-1') {
      setState(() {
        _barcode = barcode;
        _isLoading = true; // Show loading indicator
      });
      fetchNutritionalInfo(barcode);
    }
  }

  // Function to fetch nutritional info from Open Food Facts API
  Future<void> fetchNutritionalInfo(String barcode) async {
    final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['product'] != null) {
          setState(() {
            _productName = data['product']['product_name'] ?? 'Unknown Product';
            _calories = data['product']['nutriments']['energy-kcal'] != null
                ? data['product']['nutriments']['energy-kcal'].toString()
                : 'No calorie data';
            _protein = data['product']['nutriments']['proteins'] != null
                ? data['product']['nutriments']['proteins'].toString()
                : 'No protein data';
          });

          // Save to history
          saveScannedProduct(_productName);
        } else {
          setState(() {
            _productName = 'Product not found.';
            _calories = 'Nutritional information not available.';
            _protein = 'Nutritional information not available.';
          });
        }
      } else {
        setState(() {
          _productName = 'Failed to fetch product data.';
          _calories = '';
          _protein = '';
          _fat = '';
        });
      }
    } catch (e) {
      setState(() {
        _productName = 'Failed to fetch product data. Error: $e';
        _calories = '';
        _protein = '';
        _fat = '';
      });
      print('Error fetching data: $e');
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Barcode")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scan Barcode'),
            ),
            if (_isLoading)
              CircularProgressIndicator() // Show loading indicator while fetching data
            else if (_barcode.isNotEmpty) ...[
              Text('Scanned Barcode: $_barcode'),
              Text('Product Name: $_productName'),
              Text('Calories: $_calories kcal'),
              Text('Protein: $_protein kcal')
            ] else
              Text('Scan a barcode to get data'), // Fallback message
          ],
        ),
      ),
    );
  }
}
