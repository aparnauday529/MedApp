import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medapp/pages/addmedicine.dart';
import 'package:medapp/pages/home_page.dart';
import 'package:medapp/pages/userdetailsfull.dart';
import 'package:medapp/pages/viewmedicines.dart';
import 'fronthomepage.dart'; // Import FrontHomePage

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FrontHomePage()), // Redirect to FrontHomePage
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: const Color.fromARGB(255, 28, 85, 112),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: const Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FrontHomePage()), // Navigate to FrontHomePage
                );
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 3, // Set to 3 containers per row
        crossAxisSpacing: 12, // Spacing between columns
        mainAxisSpacing: 12, // Spacing between rows
        padding: const EdgeInsets.all(12), // Grid padding
        children: [
          _buildDashboardCard(
            context,
            title: "Add Medicine",
            icon: Icons.add_box,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMedicinePage()),
              );
            },
          ),
          _buildDashboardCard(
            context,
            title: "View Medicines",
            icon: Icons.medication,
            color: const Color.fromARGB(255, 243, 82, 136),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewMedicines()),
              );
            },
          ),
          _buildDashboardCard(
            context,
            title: "Visit Homepage",
            icon: Icons.home,
            color: const Color.fromARGB(255, 114, 62, 99),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          _buildDashboardCard(
            context,
            title: "User Details",
            icon: Icons.people,
            color: const Color.fromARGB(255, 113, 72, 120),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Center(child: UserDetailsFull())),
              );
            },
          ),
          _buildDashboardCard(
            context,
            title: "Logout",
            icon: Icons.logout,
            color: const Color.fromARGB(255, 204, 116, 163),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Adjusted width for medium-sized cards
        height: 100, // Adjusted height for medium-sized cards
        child: Card(
          elevation: 4,
          color: color.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white), // Adjusted icon size
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14, // Medium font size
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
