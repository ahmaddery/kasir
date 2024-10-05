import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:kasir/Api/produk_api.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController(); // Added for manual input

  String scannedBarcode = ''; // Store the scanned barcode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Button to scan the barcode
            ElevatedButton(
              onPressed: () async {
                scannedBarcode = await scanBarcode(); // Scan barcode
                if (scannedBarcode.isNotEmpty) {
                  barcodeController.text = scannedBarcode; // Set the scanned barcode in the text field
                  setState(() {}); // Update UI to reflect scanned barcode
                }
              },
              child: Text(scannedBarcode.isEmpty ? 'Scan Barcode' : 'Barcode: $scannedBarcode'),
            ),
            SizedBox(height: 20),
            // TextField for manual barcode input
            TextField(
              controller: barcodeController,
              decoration: InputDecoration(labelText: 'Manual Barcode Input'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Use scanned barcode if available; otherwise, use manual input
                String barcode = scannedBarcode.isNotEmpty ? scannedBarcode : barcodeController.text;

                if (barcode.isNotEmpty) {
                  try {
                    final response = await ProdukApi().createProduct(
                      nameController.text,
                      descriptionController.text,
                      priceController.text,
                      int.parse(stockController.text),
                      barcode,
                    );

                    // Show success message
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: Text('Product created successfully: ${response['name']}'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    // Show error message
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to create product: $e'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // Show error if no barcode is provided
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please provide a barcode.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Create Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      return result.rawContent; // Return the scanned barcode result
    } catch (e) {
      print('Error: $e');
      return ''; // Return empty string if an error occurs
    }
  }
}
