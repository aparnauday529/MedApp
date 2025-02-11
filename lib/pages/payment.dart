import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;

  const PaymentPage({Key? key, required this.totalAmount}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = 'Credit Card';
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  void _placeOrder() async {
    if (selectedPaymentMethod == 'Credit Card' || selectedPaymentMethod == 'Debit Card') {
      if (cardNumberController.text.isEmpty || expiryDateController.text.isEmpty || cvvController.text.isEmpty) {
        _showErrorDialog('Please enter valid card details.');
        return;
      }
    }

    // Save payment details to Firebase
    final paymentId = FirebaseFirestore.instance.collection('payments').doc().id;
    await FirebaseFirestore.instance.collection('payments').doc(paymentId).set({
      'amount': widget.totalAmount,
      'paymentMethod': selectedPaymentMethod,
      'timestamp': FieldValue.serverTimestamp(),
      'cardNumber': selectedPaymentMethod != 'Cash on Delivery' ? cardNumberController.text : null,
      'expiryDate': selectedPaymentMethod != 'Cash on Delivery' ? expiryDateController.text : null,
      'cvv': selectedPaymentMethod != 'Cash on Delivery' ? cvvController.text : null,
    });

    _showSuccessDialog();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Payment has been successfully processed!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              trailing: Radio<String>(
                value: 'Credit Card',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() => selectedPaymentMethod = value!);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Debit Card'),
              trailing: Radio<String>(
                value: 'Debit Card',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() => selectedPaymentMethod = value!);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cash on Delivery'),
              trailing: Radio<String>(
                value: 'Cash on Delivery',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() => selectedPaymentMethod = value!);
                },
              ),
            ),
            const SizedBox(height: 20),
            if (selectedPaymentMethod != 'Cash on Delivery')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Card Number', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: cardNumberController,
                    decoration: const InputDecoration(hintText: 'Enter Card Number'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  const Text('Expiry Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: expiryDateController,
                    decoration: const InputDecoration(hintText: 'MM/YY'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  const Text('CVV', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: cvvController,
                    decoration: const InputDecoration(hintText: 'Enter CVV'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Text(
              'Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _placeOrder,
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
