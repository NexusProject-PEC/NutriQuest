import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'storage_helper.dart'; // Your helper for saving scanned products

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

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
  bool _isLoading = false;

  /// Rounds a nutrient value to three decimal places.
  String _roundValue(dynamic value) {
    double? numValue = double.tryParse(value.toString());
    if (numValue != null) {
      return numValue.toStringAsFixed(3);
    } else {
      return value.toString();
    }
  }

  /// Fetch nutritional info from the Open Food Facts API and round the nutrient values.
  Future<void> fetchNutritionalInfo(String barcode) async {
    final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final product = data['product'];
        if (product != null) {
          final nutriments = product['nutriments'] ?? {};
          final energyKcal = nutriments['energy-kcal'];
          final proteins = nutriments['proteins'];
          final carbohydrates = nutriments['carbohydrates'];
          final fat = nutriments['fat'];

          setState(() {
            _productName = product['product_name'] ?? 'Unknown Product';
            _calories = energyKcal != null ? _roundValue(energyKcal) : 'No calorie data';
            _protein = proteins != null ? _roundValue(proteins) : 'No protein data';
            _carbohydrates = carbohydrates != null ? _roundValue(carbohydrates) : 'No carbohydrate data';
            _fat = fat != null ? _roundValue(fat) : 'No fat data';
          });

          // Save the scanned product to history.
          saveScannedProduct(_productName);
        } else {
          setState(() {
            _productName = 'Product not found.';
            _calories = 'Nutritional information not available.';
            _protein = 'Nutritional information not available.';
            _carbohydrates = 'Nutritional information not available';
            _fat = 'Nutritional information not available';
          });
        }
      } else {
        setState(() {
          _productName = 'Failed to fetch product data.';
          _calories = '';
          _protein = '';
          _fat = '';
          _carbohydrates = '';
        });
      }
    } catch (e) {
      setState(() {
        _productName = 'Failed to fetch product data. Error: $e';
        _calories = '';
        _protein = '';
        _fat = '';
        _carbohydrates = '';
      });
      print('Error fetching data: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  /// Launch the scanner screen and wait for a scanned barcode.
  Future<void> _startScan() async {
    final scannedCode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerScreen(),
      ),
    );
    if (scannedCode != null && scannedCode is String) {
      setState(() {
        _barcode = scannedCode;
        _isLoading = true;
      });
      await fetchNutritionalInfo(scannedCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startScan,
                child: const Text('Scan Barcode'),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_barcode.isNotEmpty) ...[
                Text('Scanned Barcode: $_barcode', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Product Name: $_productName', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                // Display nutrient values in a DataTable.
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Nutrient')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Calories (kcal)')),
                      DataCell(Text(_calories)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Protein (g)')),
                      DataCell(Text(_protein)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Carbohydrates (g)')),
                      DataCell(Text(_carbohydrates)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Fat (g)')),
                      DataCell(Text(_fat)),
                    ]),
                  ],
                ),
              ] else
                const Text('Scan a barcode to get data', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 300.0).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Called when a barcode is detected.
  void _onDetect(BarcodeCapture barcodeCapture) {
    if (_hasScanned) return;
    final barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && code.isNotEmpty) {
        _hasScanned = true;
        // Show a confirmation dialog so the user can verify the code.
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Barcode Detected"),
              content: Text("Code: $code"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog.
                    setState(() {
                      _hasScanned = false;
                    });
                  },
                  child: const Text("Scan Again"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog.
                    Navigator.of(context).pop(code); // Return the scanned code.
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Barcode Scanner"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // The camera view.
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Scanning overlay with a frame and animated scanning line.
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: Colors.greenAccent.withOpacity(0.8),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Instruction text at the bottom.
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Align the barcode within the frame",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

