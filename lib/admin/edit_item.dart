import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/admin/all_items.dart';


class EditItems extends StatefulWidget {
  final String restaurantId;
  final String category;
  final String docId;
  final Map<String, dynamic> data;

  const EditItems({
    super.key,
    required this.restaurantId,
    required this.category,
    required this.docId,
    required this.data,
  });

  @override
  _EditItemsState createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController imageUrlController;

  late Stream<DocumentSnapshot> _productStream;
  late StreamSubscription<DocumentSnapshot> _subscription;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.data['name']);
    descriptionController =
        TextEditingController(text: widget.data['description']);
    priceController =
        TextEditingController(text: widget.data['price']?.toString() ?? '');
    imageUrlController = TextEditingController(text: widget.data['imageUrl']);

    _productStream = FirebaseFirestore.instance
        .collection('restaurant')
        .doc(widget.restaurantId)
        .collection(widget.category)
        .doc(widget.docId)
        .snapshots();

    _subscription = _productStream.listen((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        if (nameController.text != (data['name'] ?? '')) {
          nameController.text = data['name'] ?? '';
        }
        if (descriptionController.text != (data['description'] ?? '')) {
          descriptionController.text = data['description'] ?? '';
        }
        String priceStr = (data['price'] ?? 0).toString();
        if (priceController.text != priceStr) {
          priceController.text = priceStr;
        }
        if (imageUrlController.text != (data['imageUrl'] ?? '')) {
          imageUrlController.text = data['imageUrl'] ?? '';
        }
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void updateItem() {
    final updatedData = {
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0.0,
      'imageUrl': imageUrlController.text.trim(),
    };

    FirebaseFirestore.instance
        .collection('restaurant')
        .doc(widget.restaurantId)
        .collection(widget.category)
        .doc(widget.docId)
        .update(updatedData)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated')),
      );
      Navigator.pop(context);
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Edit Item',
            style: TextStyle(color: Colors.blue, fontSize: 25),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 24, color: Colors.blue),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => AllItems()),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 70, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Item Name',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 20)),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                      labelText: 'Image URL',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                const SizedBox(height: 20),
                imageUrlController.text.isNotEmpty
                    ? Image.network(
                  imageUrlController.text,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                )
                    : const Placeholder(
                    fallbackHeight: 150, fallbackWidth: 150),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 50)),
                  onPressed: updateItem,
                  child: const Text(
                    'Update Item',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
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
