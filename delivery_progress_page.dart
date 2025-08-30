import 'package:final_year_project/components/my_receipt.dart';
import 'package:final_year_project/models/restaurant.dart';
import 'package:final_year_project/services/database/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
 final FirestoreService db = FirestoreService();


  // get access to db
  

  @override
  void initState() {
    super.initState();

    // if we get to this page, submit order to firestore db
    final restaurant = context.read<Restaurant>();

    String receipt = restaurant.displayCartReceipt();
    String email = FirebaseAuth.instance.currentUser?.email ?? "No email";
    String address = restaurant.deliveryAddress;
    String status = restaurant.status;


    db.saveOrderToDatabase(receipt, email, address, status);
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
