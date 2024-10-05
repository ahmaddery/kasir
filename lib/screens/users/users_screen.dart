import 'package:flutter/material.dart';
import 'package:kasir/Api/apiusers.dart'; // Mengimpor layanan API

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final Apiusers apiUsers = Apiusers();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

Future<void> fetchUserData() async {
  final isAuthenticated = await apiUsers.isAuthenticated();
  if (isAuthenticated) {
    final data = await apiUsers.getUserData(); // Mengambil data pengguna
    if (data != null) {
      setState(() {
        userData = data;
      });
    } else {
      // Tangani situasi jika data null
      print('Data pengguna tidak ditemukan.');
    }
  } else {
    // Arahkan ke halaman login jika tidak terautentikasi
    // Navigator.pushReplacementNamed(context, '/login');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pengguna'),
      ),
      body: userData != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${userData!['id']}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Nama: ${userData!['name']}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Email: ${userData!['email']}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Email Terverifikasi: ${userData!['email_verified_at'] ?? "Belum Terverifikasi"}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Dibuat pada: ${userData!['created_at']}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Diperbarui pada: ${userData!['updated_at']}', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()), // Menampilkan loading
    );
  }
}
