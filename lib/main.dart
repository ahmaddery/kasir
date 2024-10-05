import 'package:flutter/material.dart';
import 'package:kasir/screens/auth/auth_screen.dart';
import 'package:kasir/screens/home_screen.dart';
import 'package:kasir/Api/service_api.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: _apiService.isAuthenticated(), // Cek status autentikasi
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jika koneksi sedang menunggu
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // Jika ada error saat memeriksa status autentikasi
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Jika status autentikasi sudah tersedia
            if (snapshot.data == true) {
              // Jika user sudah login, arahkan ke HomeScreen
              return HomeScreen();
            } else {
              // Jika belum login, arahkan ke AuthScreen
              return AuthScreen();
            }
          }
        },
      ),
    );
  }
}
