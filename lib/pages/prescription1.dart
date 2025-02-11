import 'package:flutter/material.dart';

class PrescriptionDetailsPage extends StatefulWidget {
  @override
  _PrescriptionDetailsPageState createState() => _PrescriptionDetailsPageState();
}

class _PrescriptionDetailsPageState extends State<PrescriptionDetailsPage> {
  bool isPrescriptionDeleted = false;
  final String prescriptionImagePath = 'assets/icons/prescription_sample.png'; // Replace with your prescription image path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Prescription'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isPrescriptionDeleted
                ? Center(
                    child: Text(
                      'No prescription attached.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        'Prescription attached by you',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            Image.asset(
                              prescriptionImagePath, // Replace with network image URL if required
                              height: 250.0,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              bottom: 8.0,
                              right: 8.0,
                              child: IconButton(
                                onPressed: () {
                                  // Handle delete action
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Prescription'),
                                      content: Text('Are you sure you want to delete this prescription?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isPrescriptionDeleted = true;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            ElevatedButton(
              onPressed: isPrescriptionDeleted
                  ? null
                  : () {
                      // Navigate to the next screen
                      Navigator.pushNamed(context, '/nextScreen');
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: isPrescriptionDeleted ? Colors.grey : Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                textStyle: TextStyle(fontSize: 18.0),
              ),
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PrescriptionDetailsPage(),
    routes: {
      '/nextScreen': (context) => NextScreen(), // Replace with your next screen widget
    },
  ));
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text(
          'This is the next screen.',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
