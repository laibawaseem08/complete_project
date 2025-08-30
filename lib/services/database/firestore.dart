import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference orders = FirebaseFirestore.instance.collection(
      'orders');


  Future<void> saveOrderToDatabase(
      String receipt,
      String email,
      String address,

      ) async {
    await orders.add({
      'receipt': receipt,
      'address': address,
      'date': DateTime.now(),
      'order': receipt,
      'userEmail': email,

      // add more fields as necessary..
    });
  }
}