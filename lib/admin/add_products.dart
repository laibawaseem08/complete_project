import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/admin/all_items.dart';

class AddProductScreen extends StatefulWidget {
  final String restaurantId;
  const AddProductScreen({super.key, required this.restaurantId});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String selectedCategory = 'burgers';
  final List<String> categories = [
    'burgers',
    'dessert',
    'drinks',
    'salads',
    'sides'
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  bool isLoading = false;

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.restaurantId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restaurant ID missing!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

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
        const SnackBar(content: Text('Product added successfully!')),
      );

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
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Add Items',
            style: TextStyle(color: Colors.blue, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  items: categories
                      .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(
                        cat,
                        style: const TextStyle(fontSize: 18),
                      )))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Product Name',
                      labelStyle:
                      TextStyle(color: Colors.black, fontSize: 19)),
                  validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter product name'
                      : null,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle:
                      TextStyle(color: Colors.black, fontSize: 19)),
                  validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter description'
                      : null,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                      labelText: 'Price',
                      labelStyle:
                      TextStyle(color: Colors.black, fontSize: 19)),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter price';
                    }
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null) return 'Enter valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                      labelText: 'Image URL',
                      labelStyle:
                      TextStyle(color: Colors.black, fontSize: 19)),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 50)),
                  onPressed: addProduct,
                  child: const Text(
                    'Add Item',
                    style:
                    TextStyle(color: Colors.blueGrey, fontSize: 20),
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
