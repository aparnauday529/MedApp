import 'dart:convert';
// ignore: unused_import
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  @override
  _UploadPrescriptionScreenState createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  String? _imagePath; // Path for the selected image
  String? _medicineName; // Simulated medicine name
  bool _isUploaded = false; // If file is uploaded

  // Function to pick a file using file_picker
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      // Handle file for Flutter Web
      if (result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        setState(() {
          _imagePath =
              "data:image/jpeg;base64,${base64Encode(bytes)}"; // Convert file to Base64 string
        });
      } else if (result.files.single.path != null) {
        setState(() {
          _imagePath = result.files.single.path; // Local file path
        });
      }
    }
  }

  // Function to simulate file upload and display the medicine name
  void _uploadFile() {
    setState(() {
      _isUploaded = true; // Mark as uploaded
      _medicineName = "Paracetamol 500mg"; // Simulated medicine name
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Prescription"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Prescription Illustration
                Image.asset(
                  'assets/icons/prescription.png', // Replace with your local asset
                  height: 150,
                ),
                const SizedBox(height: 16),
                // File Picker Button
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Attach Prescription"),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
                const SizedBox(height: 12),
                // Upload Button (Enabled only when an image is selected)
                if (_imagePath != null)
                  ElevatedButton.icon(
                    onPressed: _uploadFile,
                    icon: const Icon(Icons.upload),
                    label: const Text("Upload"),
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                  ),
                const SizedBox(height: 16),
                // Display Uploaded Success Message
                if (_isUploaded)
                  Text(
                    "Uploaded successfully!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                const SizedBox(height: 16),
                // Medicine Name Display
                if (_medicineName != null)
                  Text(
                    "Medicine Name: $_medicineName",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 24),
                // Prescription Guide
                const Text(
                  "Prescription Guide",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("• Do not crop out any part of prescription"),
                const Text("• Avoid blurred images"),
                const Text("• Include details of doctor & patient"),
                const Text("• Medicine will be delivered as per prescription"),
                const SizedBox(height: 24),
                // Selected Image Display
                if (_imagePath != null)
                  Container(
                    width: 200, // Width of the image container
                    height: 200, // Height of the image container
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imagePath!.startsWith("data:image")
                        ? Image.network(_imagePath!) // Base64 image for Web
                        : Image.file( // Local file for mobile/desktop
                            File(_imagePath!),
                            fit: BoxFit.cover,
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UploadPrescriptionScreen(),
  ));
}
