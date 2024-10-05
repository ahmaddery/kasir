// lib/screens/home/settings.dart
import 'package:flutter/material.dart';
import 'package:kasir/screens/produk/display_screen.dart'; // Import DisplayScreen

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Settings Screen',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                // Navigate to DisplayScreen when pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayScreen()),
                );
              },
              child: Text('View Products'), // Button label
            ),
          ],
        ),
      ),
    );
  }
}
