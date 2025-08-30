import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/components/my_receipt.dart';
import 'package:full_project_1/models/restaurant.dart';
import 'package:full_project_1/services/database/firestore.dart';
import 'package:provider/provider.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  final FirestoreService db = FirestoreService();


  @override
  void initState() {
    super.initState();

    final restaurant = context.read<Restaurant>();

    String receipt = restaurant.displayCartReceipt();
    String email = FirebaseAuth.instance.currentUser?.email ?? "No email";
    String address = restaurant.deliveryAddress;


    db.saveOrderToDatabase(receipt, email, address);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
      ),
      body:  const Column(
        children: [
          MyReceipt(),
        ],
      ),
    );
  }

}
