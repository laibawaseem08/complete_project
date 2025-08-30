import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'all_items.dart';  // Import your AllItems screen here

class AddProductScreen extends StatefulWidget {
  final String restaurantId;
  AddProductScreen({required this.restaurantId});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String selectedCategory = 'burgers';
  final List<String> categories = ['burgers', 'dessert', 'drinks', 'salads', 'sides'];

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  bool isLoading = false;

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.restaurantId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restaurant ID missing!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Use ImageKit public URL example or your image picker upload link
    final String imageUrl = imageUrlController.text.trim().isNotEmpty
        ? imageUrlController.text.trim()
        : 'https://ik.imagekit.io/pvvh0budd/path/to/myimage.jpg';

    Map<String, dynamic> productData = {
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0.0,
      'imageUrl': imageUrl,
    };

    try {
      await FirebaseFirestore.instance
          .collection('restaurant')
          .doc(widget.restaurantId)
          .collection(selectedCategory)
          .add(productData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );

      // Navigate to AllItems page after adding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AllItems()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Add Items',
          style: TextStyle(color: Colors.blue, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                    ),
                ),

                items: categories
                    .map((cat) => DropdownMenuItem(
                    value: cat, child: Text(cat,style: TextStyle(fontSize: 18),)
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name', labelStyle: TextStyle(color: Colors.black, fontSize: 19)),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Enter product name' : null,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: Colors.black, fontSize: 19)),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price', labelStyle: TextStyle(color: Colors.black, fontSize: 19)),
                keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: false),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Enter price';
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null) return 'Enter valid number';
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL', labelStyle: TextStyle(color: Colors.black, fontSize: 19)
                ),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(160, 50)),
                onPressed: addProduct,
                child: Text(
                  'Add Item',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20
                  ),
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
