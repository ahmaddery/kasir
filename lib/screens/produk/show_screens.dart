import 'package:flutter/material.dart';
import 'package:kasir/Api/produk_api.dart';

class ShowScreen extends StatefulWidget {
  final String productId;

  ShowScreen({required this.productId}); // Menerima ID produk

  @override
  _ShowScreenState createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  final ProdukApi _apiService = ProdukApi();
  dynamic _product;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProductDetails(); // Ambil detail produk saat inisialisasi
  }

  /// Fungsi untuk mengambil detail produk berdasarkan ID
  Future<void> _fetchProductDetails() async {
    try {
      final product = await _apiService.getProductById(widget.productId); // Ambil produk berdasarkan ID
      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load product details';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tampilkan gambar produk
                      Image.network(
                        _product['image'] != null
                            ? '${ProdukApi().imageUrl}${_product['image']}'
                            : 'https://cdn-icons-png.flaticon.com/512/2331/2331970.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _product['name'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _product['description'] ?? 'No description available',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text('Harga: ${_product['price']}', style: TextStyle(fontSize: 20, color: Colors.green)),
                      SizedBox(height: 8),
                      Text('Stok: ${_product['stock']}', style: TextStyle(fontSize: 20, color: Colors.red)),
                    ],
                  ),
                ),
    );
  }
}
