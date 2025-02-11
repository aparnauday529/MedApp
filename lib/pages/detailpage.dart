import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatelessWidget {
  // Sample data for items
  final List<Map<String, String>> items = [
    {
      "name": "Bisolvon Extra Sirup 60 ml",
      "description":
          "BISOLVON EXTRA SIRUP contains Bromhexine HCl and Guaifenesin. It is used to treat dry cough, flu, and respiratory tract infections.",
      "price": "Rp 42,000",
      "image": "assets/bisolvon.jpg",
    },
    {
      "name": "Panadol Cold & Flu 10 Kaplet",
      "description":
          "PANADOL COLD & FLU contains Paracetamol and Pseudoephedrine HCl. It is used to treat mild to moderate pain, including headaches, menstrual pain, and flu symptoms.",
      "price": "Rp 25,000",
      "image": "assets/panadol.jpg",
    },
    {
      "name": "Dettol Antiseptic Liquid 100 ml",
      "description":
          "Dettol Antiseptic Liquid protects against 100 illness-causing germs and is a multipurpose cleaner for personal and home hygiene.",
      "price": "Rp 18,000",
      "image": "assets/dettol.jpg",
    },
    {
      "name": "Savlon Antiseptic Cream 50 g",
      "description":
          "Savlon Antiseptic Cream has a unique formula with Chlorhexidine Gluconate that kills 99.99% of germs and has been trusted for over 50 years.",
      "price": "Rp 22,000",
      "image": "assets/savlon.jpg",
    },
    {
      "name": "Paracetamol Tablet 500 mg (10 Kaplet)",
      "description":
          "Paracetamol Tablet is used to treat fever, headaches, and pain relief from various internal conditions.",
      "price": "Rp 5,000",
      "image": "assets/paracetamol.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.local_pharmacy),
            title: Text(items[index]['name']!),
            subtitle: Text(items[index]['price']!),
            onTap: () {
              // Navigate to the detail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    item: items[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, String> item;

  DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image if available
            item['image'] != null
                ? Image.asset(
                    item['image']!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 16),
            Text(
              item['name']!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              item['description']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Price: ${item['price']!}",
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Set button color to green
                ),
                onPressed: () {
                  // Add to cart logic can go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${item['name']} added to cart!"),
                    ),
                  );
                },
                child: Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
