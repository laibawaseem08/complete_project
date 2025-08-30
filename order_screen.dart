import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatelessWidget {
  final CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  Future<void> deleteOrder(String docId) async {
    try {
      await ordersCollection.doc(docId).delete();
      print('Order deleted');
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  Future<void> editOrderStatus(BuildContext context, String docId, String currentStatus, String currentPaymentStatus) async {
    final TextEditingController statusController = TextEditingController(text: currentStatus);
    String selectedPaymentStatus = currentPaymentStatus;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Order & Payment Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: statusController,
              decoration: InputDecoration(labelText: 'Order Status'),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: 'Paid',
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Payment Status',
                border: OutlineInputBorder(),
              ),
            ),

          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ordersCollection.doc(docId).update({
                  'status': statusController.text.trim(),
                  'paymentStatus': selectedPaymentStatus,
                });
                Navigator.of(ctx).pop();
              } catch (e) {
                print('Error updating order: $e');
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Orders List',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        leading: IconButton(
          icon: Icon(
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
        stream: ordersCollection.orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDoc = orders[index];
              final orderData = orderDoc.data() as Map<String, dynamic>;

              final orderId = orderData['orderId'] ?? orderDoc.id;
              final status = orderData['status'] ?? 'Unknown';
              final totalPrice = orderData['totalPrice']?.toString() ?? '0';
              final address = orderData['address'] ?? 'No Address';
              final receipt = orderData['receipt'] ?? 'No Receipt';
              final userEmail = orderData['userEmail'] ?? 'No Email';
              final paymentStatus = orderData['paymentStatus'] ?? 'Paid';

              // Format date
              String formattedDate = 'No Date';
              if (orderData['date'] != null) {
                final timestamp = orderData['date'];
                if (timestamp is Timestamp) {
                  final dt = timestamp.toDate();
                  formattedDate = '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}';
                } else if (orderData['date'] is String) {
                  formattedDate = orderData['date'];
                }
              }

              return Card(
                margin: EdgeInsets.only(top: 50, right: 15, left: 15),
                child: ListTile(
                  title: Text('Order ID: $orderId'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: $status'),
                      Text('Payment: $paymentStatus'),
                      Text('User Email: $userEmail'),
                      Text('Address: $address'),
                      Text('Receipt: $receipt'),
                      Text('Date: $formattedDate'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          editOrderStatus(
                            context,
                            orderDoc.id,
                            status,
                            paymentStatus,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Delete Order'),
                              content: Text('Are you sure you want to delete this order?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    deleteOrder(orderDoc.id);
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
