import 'package:flutter/material.dart';

class MedicinesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medicines')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.medical_services),
            title: Text('Paracetamol'),
            subtitle: Text('₹10.00'),
            trailing: ElevatedButton(onPressed: () {}, child: Text('Add to Cart')),
          ),
          ListTile(
            leading: Icon(Icons.medical_services),
            title: Text('Ibuprofen'),
            subtitle: Text('₹20.00'),
            trailing: ElevatedButton(onPressed: () {}, child: Text('Add to Cart')),
          ),
        ],
      ),
    );
  }
}
