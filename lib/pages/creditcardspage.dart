import 'package:flutter/material.dart';

class CreditCardsPage extends StatefulWidget {
  final double totalPrice;

  const CreditCardsPage({Key? key, required this.totalPrice}) : super(key: key);

  @override
  _CreditCardsPageState createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default values for dummy card data
    _cardNumberController.text = '4111 1111 1111 1111'; // Dummy card number
    _cvvController.text = '123'; // Dummy CVV
    _expiryDateController.text = '12/25'; // Dummy Expiry Date
  }

  void _submitPayment() {
    // Here, you'd typically send the data to the backend for processing
    // For now, we can print it to simulate the process

    print('Card Number: ${_cardNumberController.text}');
    print('CVV: ${_cvvController.text}');
    print('Expiry Date: ${_expiryDateController.text}');
    print('Total Price: ₹${widget.totalPrice.toStringAsFixed(2)}');

    // Simulate payment confirmation
    Navigator.pop(context); // Close the page after payment submission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Card Payment'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method: Credit Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Card Number field
            TextField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // CVV field
            TextField(
              controller: _cvvController,
              decoration: const InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Expiry Date field
            TextField(
              controller: _expiryDateController,
              decoration: const InputDecoration(
                labelText: 'Expiry Date (MM/YY)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            // Total Amount
            Text(
              'Total Amount: ₹${widget.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Submit button
            ElevatedButton(
              onPressed: _submitPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Complete Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
