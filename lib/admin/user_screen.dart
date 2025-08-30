import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'User Credentials',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!.docs;

            if (users.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index].data() as Map<String, dynamic>;
                var docId = users[index].id;

                return Padding(
                  padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                  child: Card(
                    child: ListTile(
                      title: Text(user['email'] ?? 'No Email'),
                      subtitle: Text('UID: ${user['uid']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete User?'),
                              content: const Text('Are you sure you want to delete this user?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(docId)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User deleted')),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
