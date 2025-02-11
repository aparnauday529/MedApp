import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;

  final String cloudinaryUrl = 'https://api.cloudinary.com/v1_1/medicine/image/upload';
  final String presetName = 'medicine';

  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? _addedMedicine;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = presetName;
      request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var data = json.decode(responseBody.body);
        return data['secure_url'];
      } else {
        throw Exception('Failed to upload image: ${responseBody.body}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String medicineName = _medicineNameController.text;
      String price = _priceController.text;
      String description = _descriptionController.text;

      String? imageUrl = await _uploadImage();

      try {
        DocumentReference docRef = await FirebaseFirestore.instance.collection('medicine').add({
          'medicineName': medicineName,
          'price': price,
          'description': description,
          'imageUrl': imageUrl ?? '',
          'createdAt': Timestamp.now(),
        });

        DocumentSnapshot doc = await docRef.get();

        setState(() {
          _addedMedicine = doc.data() as Map<String, dynamic>?;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Medicine added successfully!')),
        );

        _medicineNameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() {
          _imageFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add medicine: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/icons/no_history_ilustration.png', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _medicineNameController,
                          decoration: InputDecoration(
                            labelText: 'Medicine Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the medicine name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the price';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: Text('Pick Image'),
                            ),
                            SizedBox(width: 16),
                            if (_imageFile != null)
                              Text('Image selected: ${_imageFile!.path.split('/').last}'),
                          ],
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_addedMedicine != null) ...[
                Container(
                  color: Colors.white, // Background for better visibility
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medicine Name: ${_addedMedicine!['medicineName']}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Price: ${_addedMedicine!['price']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Description: ${_addedMedicine!['description']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      if (_addedMedicine!['imageUrl'] != '')
                        Center(
                          child: Image.network(
                            _addedMedicine!['imageUrl'],
                            height: 200, // Adjust height
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
