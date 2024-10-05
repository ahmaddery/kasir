import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://working-marmoset-hideously.ngrok-free.app/api';

  /// Fungsi untuk melakukan login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    // Memeriksa status kode dari respons
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Simpan token ke session menggunakan SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Menyimpan token selama 30 hari
      DateTime expiryDate = DateTime.now().add(Duration(days: 30));
      await prefs.setString('expiryDate', expiryDate.toIso8601String());

      return data; // Kembalikan data pengguna
    } else {
      throw Exception('Login failed'); // Menangani kesalahan
    }
  }

  /// Fungsi untuk melakukan logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Memeriksa apakah token tersedia
    if (token != null) {
      final url = Uri.parse('$baseUrl/logout');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Memeriksa status kode dari respons
      if (response.statusCode == 200) {
        // Hapus token dari session
        await prefs.remove('token');
        await prefs.remove('expiryDate');
      } else {
        throw Exception('Logout failed'); // Menangani kesalahan
      }
    } else {
      throw Exception('No token found'); // Jika tidak ada token
    }
  }

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

  /// Metode untuk registrasi pengguna baru
  Future<Map<String, dynamic>> register(String name, String email, String password, String confirmPassword) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword, // Harus sesuai dengan nama parameter di backend
      }),
    );

    // Memeriksa status kode dari respons
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // Kembalikan data pengguna
    } else {
      throw Exception('Registration failed'); // Menangani kesalahan
    }
  }

  /// Metode untuk mengirim tautan reset password
  Future<void> resetPassword(String email) async {
    final url = Uri.parse('$baseUrl/password/reset-link');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    // Memeriksa status kode dari respons
    if (response.statusCode == 200) {
      // Tautan reset password berhasil dikirim
      print('Password reset link sent successfully');
    } else {
      throw Exception('Failed to send password reset link'); // Menangani kesalahan
    }
  }
}
