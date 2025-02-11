import 'package:flutter/material.dart';
import 'package:medapp/pages/payment.dart';
import 'package:medapp/pages/addresspage.dart'; // Import the AddressPage

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialCartItems;

  const CartPage({Key? key, required this.initialCartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> cartItems;
  Map<String, dynamic>? selectedAddress; // Stores the selected delivery address

  @override
  void initState() {
    super.initState();
    cartItems = widget.initialCartItems.map((item) {
      return {
        'id': item['id'] ?? item['name'].hashCode,
        'name': item['name'],
        'price': item['price'] ?? 0.0,
        'quantity': item['quantity'] ?? 1,
        'color': item['color'] ?? 'Gold',
      };
    }).toList();
  }

  void deleteItem(int id) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == id);
    });
  }

  void incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity'] += 1;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity'] -= 1;
      }
    });
  }

  double calculateSubtotal() {
    return cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double calculateDiscount() {
    return 0.0;
  }

  double calculateTotal() {
    return calculateSubtotal() - calculateDiscount();
  }

  void navigateToAddressPage() async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressPage()),
    );

    if (newAddress != null) {
      setState(() {
        selectedAddress = newAddress;
      });
    }
  }

  Widget _buildAddressContainer() {
    if (selectedAddress == null) {
      return const Text('No address added yet. Please add a delivery address.');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedAddress!['name']}, ${selectedAddress!['house']}, ${selectedAddress!['road']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text('${selectedAddress!['city']}, ${selectedAddress!['state']} - ${selectedAddress!['pincode']}'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: navigateToAddressPage,
                child: const Text('Update', style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedAddress = null;
                  });
                },
                child: const Text('Remove', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item['name'],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'COLOR: ${item['color']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.orange),
                                onPressed: () => decrementQuantity(index),
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.green),
                                onPressed: () => incrementQuantity(index),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () => deleteItem(item['id']),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text('Remove', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade50.withOpacity(0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ORDER SUMMARY',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text('₹${calculateSubtotal().toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount'),
                      Text('- ₹${calculateDiscount().toStringAsFixed(2)}'),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${calculateTotal().toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildAddressContainer(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: navigateToAddressPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Add/Update Delivery Address'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: selectedAddress != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  totalAmount: calculateTotal(),
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedAddress != null ? Colors.green : Colors.grey,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('PLACE ORDER'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
