import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailsFull extends StatefulWidget {
  @override
  _UserDetailsFullState createState() => _UserDetailsFullState();
}

class _UserDetailsFullState extends State<UserDetailsFull> {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _deleteUser(String userId) async {
    await _usersCollection.doc(userId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User deleted successfully!')));
  }

  Future<void> _editUser(String userId, String fieldName, String updatedValue) async {
    await _usersCollection.doc(userId).update({fieldName: updatedValue});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: _usersCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Name', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Email', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
              ],
              rows: snapshot.data!.docs.map((doc) {
                final userData = doc.data() as Map<String, dynamic>;
                final userId = doc.id;

                return DataRow(cells: [
                  DataCell(Text(userId)),
                  DataCell(
                    Container(
                      color: Colors.green.shade50,
                      child: Text(userData['name'] ?? ''),
                    ),
                    onTap: () {
                      _showEditDialog(userId, 'name', userData['name'] ?? '');
                    },
                  ),
                  DataCell(
                    Container(
                      color: Colors.green.shade50,
                      child: Text(userData['email'] ?? ''),
                    ),
                    onTap: () {
                      _showEditDialog(userId, 'email', userData['email'] ?? '');
                    },
                  ),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(userId, 'name', userData['name'] ?? '');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteUser(userId);
                        },
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(String userId, String fieldName, String currentValue) {
    final TextEditingController _controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new $fieldName'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editUser(userId, fieldName, _controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

