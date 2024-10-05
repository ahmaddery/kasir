import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProdukApi {
  final String baseUrl = 'https://working-marmoset-hideously.ngrok-free.app/api';
  final String imageUrl = 'https://working-marmoset-hideously.ngrok-free.app';


   /// Fungsi untuk memeriksa apakah pengguna sudah terautentikasi
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final expiryDate = prefs.getString('expiryDate');

    // Memeriksa keberadaan token dan tanggal kedaluwarsa
    if (token != null && expiryDate != null) {
      DateTime expiry = DateTime.parse(expiryDate);
      if (DateTime.now().isBefore(expiry)) {
        return true; // Token masih valid
      } else {
        // Token expired, hapus dari session
        await prefs.remove('token');
        await prefs.remove('expiryDate');
        return false; // Token sudah kedaluwarsa
      }
    }
    return false; // Tidak ada token
  }

  /// Fungsi untuk mendapatkan data produk
  Future<List<dynamic>> getProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Memeriksa apakah token tersedia
    if (token != null) {
      final url = Uri.parse('$baseUrl/product');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Memeriksa status kode dari respons
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Ambil daftar produk dari respons
      } else {
        throw Exception('Failed to load product'); // Menangani kesalahan
      }
    } else {
      throw Exception('No token found'); // Jika tidak ada token
    }
  }

  /// Fungsi untuk mendapatkan data produk berdasarkan ID
  Future<dynamic> getProductById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Memeriksa apakah token tersedia
    if (token != null) {
      final url = Uri.parse('$baseUrl/product/$id');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Memeriksa status kode dari respons
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Ambil detail produk dari respons
      } else if (response.statusCode == 404) {
        throw Exception('Product not found'); // Menangani kesalahan jika produk tidak ditemukan
      } else {
        throw Exception('Failed to load product'); // Menangani kesalahan lain
      }
    } else {
      throw Exception('No token found'); // Jika tidak ada token
    }
  }
    /// Fungsi untuk mencari produk berdasarkan query
  Future<List<dynamic>> searchProducts(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Memeriksa apakah token tersedia
    if (token != null) {
      final url = Uri.parse('$baseUrl/products/search?query=$query');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Memeriksa status kode dari respons
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Ambil daftar produk dari respons
      } else {
        throw Exception('Failed to search products'); // Menangani kesalahan
      }
    } else {
      throw Exception('No token found'); // Jika tidak ada token
    }
  }

  /// Fungsi untuk mengecek harga produk berdasarkan barcode
Future<Map<String, dynamic>> checkPriceByBarcode(String barcode) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  // Memeriksa apakah token tersedia
  if (token != null) {
    final url = Uri.parse('$baseUrl/products/barcode/$barcode');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Memeriksa status kode dari respons
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Mengembalikan informasi lengkap produk
      return {
        'name': data['data']['name'],       // Nama produk
        'price': data['data']['price'],     // Harga produk
        'barcode': data['data']['barcode'], // Barcode produk
      }; 
    } else if (response.statusCode == 404) {
      throw Exception('Product not found'); // Menangani kesalahan jika produk tidak ditemukan
    } else {
      throw Exception('Failed to check price'); // Menangani kesalahan lain
    }
  } else {
    throw Exception('No token found'); // Jika tidak ada token
  }
}

  /// Fungsi untuk membuat produk baru
  Future<Map<String, dynamic>> createProduct(String name, String description, String price, int stock, String barcode) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Memeriksa apakah token tersedia
    if (token != null) {
      final url = Uri.parse('$baseUrl/products');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'stock': stock,
          'barcode': barcode,
        }),
      );

      // Memeriksa status kode dari respons
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data; // Kembalikan data produk yang baru dibuat
      } else {
        throw Exception('Failed to create product'); // Menangani kesalahan
      }
    } else {
      throw Exception('No token found'); // Jika tidak ada token
    }
  }

}
