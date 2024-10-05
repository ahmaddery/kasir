import 'package:flutter/material.dart';
import 'package:kasir/icons/navigasi.dart';  // Import BottomNavBar
import 'package:barcode_scan2/barcode_scan2.dart';  // Import barcode_scan2
import 'package:kasir/Api/produk_api.dart';
import 'package:kasir/screens/produk/create_screen.dart'; // Import the CreateProductScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Select an option below to navigate.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String barcode = await scanBarcode();
                if (barcode.isNotEmpty) {
                  try {
                    // Panggil fungsi untuk memeriksa harga berdasarkan barcode
                    final priceInfo = await ProdukApi().checkPriceByBarcode(barcode);
                    
                    // Tampilkan harga produk
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('DETAIL PRODUK'),
                          content: Text('Produk: ${priceInfo['name']}\nHarga: ${priceInfo['price']}'), // Menampilkan detail produk
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
                    // Menampilkan dialog jika produk tidak ditemukan
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('UPSS'),
                          content: Text('Produk tidak ditemukan.'),
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
                }
              },
              child: Text('Scan Barcode'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to CreateProductScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProductScreen()),
                );
              },
              child: Text('Create Product'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Future<String> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      return result.rawContent; // Mengembalikan hasil barcode yang dipindai
    } catch (e) {
      print('Error: $e');
      return ''; // Mengembalikan string kosong jika terjadi kesalahan
    }
  }
}
