import 'package:flutter/material.dart';
import 'package:medapp/pages/home_page.dart';
import 'package:medapp/pages/profile.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage2()));
}

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final List<Map<String, String>> items = [
    {'name': 'AMOXSAN 500 MG 10 KAPSUL', 'price': '400', 'image': 'assets/icons/amoxsan.jpg', 'type': 'Tablet'},
    {'name': 'ZITROLIN KAPLET 500 MG', 'price': '50', 'image': 'assets/icons/zitrolin.jpg', 'type': 'Tablet'},
    {'name': 'AMOXSAN DRY SYRUP 60 ML', 'price': '300', 'image': 'assets/icons/amoxsan_syrup.jpg', 'type': 'Syrup'},
    {'name': 'AMOXICILLIN 250 MG 10 KAPSUL', 'price': '500', 'image': 'assets/icons/amoxicillin.jpg', 'type': 'Tablet'},
    {'name': 'DETTOL ANTISPECTIC 60 ML', 'price': '300', 'image': 'assets/icons/dettol.jpg', 'type': 'Liquid'},
    {'name': 'SAVLON ANTISPECTIC 100ML', 'price': '500', 'image': 'assets/icons/savlon.jpg', 'type': 'Liquid'},
  ];

  String searchQuery = "";
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.where((item) {
      final matchesSearch = item['name']!.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = selectedFilter == "All" || item['type'] == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Healthcare Items'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.teal, size: 30),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.teal, size: 30),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                  items: ["All", "Tablet", "Syrup", "Liquid"].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search medicine...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 2 / 2.8,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        filteredItems[index]['image']!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        filteredItems[index]['name']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                    'Price: ₹${filteredItems[index]['price']}',

                   style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Image.asset('assets/icons/logo.png', height: 60),
                Text(
                  'MedApp - Your Trusted Healthcare Partner',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _featureCard(Icons.local_shipping, 'Free Delivery', 'On Orders above ₹999/-'),
                    _featureCard(Icons.verified, 'Authentic', 'Hand Picked Products'),
                    _featureCard(Icons.attach_money, 'Affordable', 'Save up-to 30%'),
                    _featureCard(Icons.security, 'Secure', 'Industry Data Security'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal, size: 30),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
