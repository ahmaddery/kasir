// lib/screens/produk/display_screen.dart
import 'package:flutter/material.dart';
import 'package:kasir/Api/produk_api.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProdukApi().getProduct(); // Fetch products when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Display error message
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found')); // Message for empty list
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              // Set the image URL; use the default if null
              String imageUrl = product['image'] != null
                  ? 'https://working-marmoset-hideously.ngrok-free.app${product['image']}'
                  : 'https://img.freepik.com/free-photo/elegant-skin-care-banner-design_23-2149480137.jpg?t=st=1727936175~exp=1727939775~hmac=22f87ad154fee8b5727d42432dbc94b9fd6a62c1fb839c5d2f95c8b8b4e4f136&w=1380';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Image.network(
                        imageUrl, // Use the resolved image URL
                        height: 150, // Adjust height as needed
                        fit: BoxFit.cover, // Cover to maintain aspect ratio
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description: ${product['description']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Price: ${product['price']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Stock: ${product['stock']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Barcode: ${product['barcode']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
