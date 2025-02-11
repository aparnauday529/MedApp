import 'package:flutter/material.dart';
 // Make sure to import AdminLoginPage

class FrontHomePage extends StatelessWidget {
  const FrontHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image (adjust path as needed)
          Positioned.fill(
            child: Image.asset(
              'assets/icons/i2.jpg', // Add the background image to your assets
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background image
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to the App",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // User Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navigate to User Login Page
                },
                child: const Text("Get Started"),
              ),
              
              
            ],
          ),
        ],
      ),
    );
  }
}
