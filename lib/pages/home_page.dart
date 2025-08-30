import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/components/my_current_location.dart';
import 'package:full_project_1/components/my_description_box.dart';
import 'package:full_project_1/components/my_drawer.dart';
import 'package:full_project_1/components/my_food_tile.dart';
import 'package:full_project_1/components/my_silver_app_bar.dart';
import 'package:full_project_1/components/my_tabbar.dart';
import 'package:full_project_1/models/food.dart';
import 'package:full_project_1/pages/food_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String restaurantId = 'cSXoUxJHxZbHpO8OvEgL';

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String categoryToString(FoodCategory category) {
    return category.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySilverAppBar(
            title: MyTabBar(tabController: _tabController),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                MyCurrentLocation(),
                const MyDescriptionBox(),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: FoodCategory.values.map((category) {
            String categoryName = categoryToString(category);

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('restaurant')
                  .doc(restaurantId)
                  .collection(categoryName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                      child: Text('No items in this category.'));
                }

                List<Food> foods = docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Food(
                    name: data['name'] ?? '',
                    price: (data['price'] ?? 0).toDouble(),
                    description: data['description'] ?? '',
                    imagePath: data['imageUrl'] ?? '',
                    category: category,
                  );
                }).toList();

                return ListView.builder(
                  itemCount: foods.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final food = foods[index];

                    return FoodTile(
                      food: food,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FoodPage(food: food)),
                      ),
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

