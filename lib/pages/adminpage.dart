import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/images.jpg'), // Background image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dashboard content
          SafeArea(
            child: Center(
              child: Container(
                width: 400, // Medium-sized width
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Slight transparency
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Welcome text
                    Text(
                      'Welcome, Admin!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Green color for text
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'admin@example.com', // Replace with dynamic email if required
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Dashboard options
                    ..._buildDashboardOptions(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDashboardOptions(BuildContext context) {
    final options = [
      {'icon': Icons.upload_file, 'title': 'Upload Prescription', 'page': UploadPrescriptionPage()},
      {'icon': Icons.shopping_cart, 'title': 'My Orders', 'page': MyOrdersPage()},
      {'icon': Icons.person, 'title': 'My Profile', 'page': MyProfilePage()},
      {'icon': Icons.local_offer, 'title': 'Offers & Discounts', 'page': OffersAndDiscountsPage()},
      {'icon': Icons.help_outline, 'title': 'Help & Support', 'page': HelpAndSupportPage()},
    ];

    return options
        .map(
          (option) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => option['page'] as Widget),
              );
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  option['icon'] as IconData,
                  color: Colors.blue,
                  size: 30,
                ),
                title: Text(
                  option['title'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              ),
            ),
          ),
        )
        .toList();
  }
}

// Placeholder pages for navigation
class UploadPrescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Prescription')),
      body: Center(child: Text('Upload Prescription Page')),
    );
  }
}

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      body: Center(child: Text('My Orders Page')),
    );
  }
}

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Center(child: Text('My Profile Page')),
    );
  }
}

class OffersAndDiscountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offers & Discounts')),
      body: Center(child: Text('Offers & Discounts Page')),
    );
  }
}

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & Support')),
      body: Center(child: Text('Help & Support Page')),
    );
  }
}

// Entry point for admin login navigation
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminLogin(), // Replace with your admin login page
    routes: {
      '/dashboard': (context) => AdminDashboard(),
    },
  ));
}

class AdminLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/dashboard');
          },
          child: Text('Login as Admin'),
        ),
      ),
    );
  }
}
