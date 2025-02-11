// ignore_for_file: non_constant_identifier_names, use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'providers/cart_provider.dart'; // Import CartProvider
import 'pages/homepage2.dart';
import 'pages/splash.dart';
import 'pages/fronthomepage.dart'; // Import FrontHomePage
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/adminlogin.dart';
import 'pages/prescription.dart';
import 'firebase_options.dart'; // Ensure this file is generated using `flutterfire configure`

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Medicinal App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/front_home', // Set FrontHomePage as the initial route
      routes: {
        '/front_home': (context) => FrontHomePage(), // Add the route for FrontHomePage
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/medicines': (context) => HomePage2(),
        '/admin': (context) => AdminLoginPage(),
        '/prescription': (context) => UploadPrescriptionScreen(),
      },
    );
  }
}
