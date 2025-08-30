import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/themes/light_mode.dart';

class OrdersScreen extends StatelessWidget {
  final CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('orders');

   OrdersScreen({super.key});

  Future<void> deleteOrder(String docId) async {
    try {
      await ordersCollection.doc(docId).delete();
      print('Order deleted');
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightMode,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Orders List',
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
          stream:
          ordersCollection.orderBy('date', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading orders'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No orders found'));
            }

            final orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final orderDoc = orders[index];
                final orderData = orderDoc.data() as Map<String, dynamic>;

                final orderId = orderData['orderId'] ?? orderDoc.id;
                final totalPrice = orderData['totalPrice']?.toString() ?? '0';
                final receipt = orderData['receipt'] ?? 'No Receipt';
                final userEmail = orderData['userEmail'] ?? 'No Email';

                // Format date
                String formattedDate = 'No Date';
                if (orderData['date'] != null) {
                  final timestamp = orderData['date'];
                  if (timestamp is Timestamp) {
                    final dt = timestamp.toDate();
                    formattedDate =
                    '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}';
                  } else if (orderData['date'] is String) {
                    formattedDate = orderData['date'];
                  }
                }

                return Card(
                  shadowColor: Colors.black54.withOpacity(0.7),
                  margin: const EdgeInsets.only(top: 50, right: 15, left: 15),
                  child: ListTile(
                    title: Text('Order ID: $orderId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Email: $userEmail'),
                        Text('Receipt: $receipt'),
                        Text('Date: $formattedDate'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Order'),
                            content: const Text(
                                'Are you sure you want to delete this order?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  deleteOrder(orderDoc.id);
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
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
