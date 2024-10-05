import 'package:flutter/material.dart';
import 'package:kasir/screens/auth/auth_screen.dart';  // Import AuthScreen
import 'package:kasir/screens/produk/product_screen.dart';  // Import ProductScreen
import 'package:kasir/screens/home_screen.dart';  // Import HomeScreen
import 'package:kasir/screens/home/settings.dart';  // Import SettingsScreen
import 'package:kasir/Api/service_api.dart';  // Import ApiService

class BottomNavBar extends StatelessWidget {
  final ApiService _apiService = ApiService();  // Instance of ApiService

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Home Button
            IconButton(
              icon: Icon(Icons.home, size: 30),  // Home icon
              onPressed: () {
                // Navigate to the HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            // Products Button
            IconButton(
              icon: Icon(Icons.list, size: 30),  // List icon for products
              onPressed: () {
                // Navigate to the ProductScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductScreen()),
                );
              },
            ),
            // Settings Button
            IconButton(
              icon: Icon(Icons.settings, size: 30),  // Settings icon
              onPressed: () {
                // Navigate to the SettingsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            // Logout Button
            IconButton(
              icon: Icon(Icons.logout, size: 30),  // Logout icon
              onPressed: () async {
                // Show confirmation dialog before logging out
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to show logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Perform logout
                await _apiService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
