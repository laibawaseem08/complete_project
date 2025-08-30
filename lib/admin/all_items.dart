import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/admin/edit_item.dart';

class AllItems extends StatefulWidget {
  const AllItems({super.key});

  @override
  _AllItemsState createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  String selectedCategory = 'burgers';
  final String restaurantId = 'cSXoUxJHxZbHpO8OvEgL';
  final List<String> categories = [
    'burgers',
    'dessert',
    'drinks',
    'salads',
    'sides'
  ];

  void deleteItem(String docId) {
    FirebaseFirestore.instance
        .collection('restaurant')
        .doc(restaurantId)
        .collection(selectedCategory)
        .doc(docId)
        .delete()
        .then((_) => print('Item deleted'))
        .catchError((e) => print('Delete error: $e'));
  }

  void editItem(String docId, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItems(
          restaurantId: restaurantId,
          category: selectedCategory,
          docId: docId,
          data: data,
        ),
      ),
    );
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
            'All Items',
            style: TextStyle(color: Colors.blue, fontSize: 25),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: DropdownButton<String>(
                iconDisabledColor: Colors.tealAccent,
                iconEnabledColor: Colors.purpleAccent,
                iconSize: 30,
                elevation: 2,
                dropdownColor: Colors.white54,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurant')
                    .doc(restaurantId)
                    .collection(selectedCategory)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                        child: Text('No items in this category.'));
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var doc = docs[index];
                      var data = doc.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: Image.network(
                          data['imageUrl'],
                          width: 50,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          data['name'] ?? 'No name',
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(data['description'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => editItem(doc.id, data),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteItem(doc.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
