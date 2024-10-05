import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apiusers {
  final String baseUrl = 'https://working-marmoset-hideously.ngrok-free.app/api';

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
        // Token kedaluwarsa, hapus dari session
        await prefs.remove('token');
        await prefs.remove('expiryDate');
        return false; // Token sudah kedaluwarsa
      }
    }
    return false; // Tidak ada token
  }

  /// Fungsi untuk mengambil data pengguna yang sedang login
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Authorization': 'Bearer $token', // Menyertakan token dalam permintaan
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['data']; // Mengembalikan data pengguna dari respons
      } else if (response.statusCode == 401) {
        // Token tidak valid atau sudah kadaluwarsa
        await prefs.remove('token');
        await prefs.remove('expiryDate');
        return null; // Kembalikan null jika terjadi unauthorized
      } else {
        // Menangani kesalahan lainnya
        throw Exception('Gagal memuat data pengguna: ${response.reasonPhrase}');
      }
    }
    return null; // Tidak ada token, pengguna tidak terautentikasi
  }
}
