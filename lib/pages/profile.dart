import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    print('Current user email: ${_currentUser?.email}');
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    if (_currentUser == null) {
      // If the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return null;
    }

    try {
      // Fetch the user data from Firestore using the current user's uid
      final userDoc = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data();
      } else {
        // If no data found for this user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user data found in Firestore')),
        );
        return null;
      }
    } catch (e) {
      // Error fetching data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
      return null;
    }
  }

  Future<void> _updateUserField(String field, String newValue) async {
    if (_currentUser == null || newValue.isEmpty) return;

    try {
      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .update({field: newValue});
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$field updated to $newValue')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating $field: $e')),
      );
    }
  }

  void _showEditDialog(String title, String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'New $title',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                await _updateUserField(field, newValue);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(  
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final userData = snapshot.data;
          if (userData == null) {
            return const Center(child: Text('No user data found.'));
          }

          final name = userData['name'] ?? 'N/A';
          final email = userData['email'] ?? 'N/A';
          final phoneNumber = userData['phone'] ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.teal),
                  title: const Text('Name'),
                  subtitle: Text(name),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.teal),
                    onPressed: () =>
                        _showEditDialog('Name', 'name', name),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.teal),
                  title: const Text('Email'),
                  subtitle: Text(email),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.teal),
                  title: const Text('Phone Number'),
                  subtitle: Text(phoneNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.teal),
                    onPressed: () => _showEditDialog(
                        'Phone Number', 'phone', phoneNumber),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
