import 'package:final_year_project/models/food.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;
  const MyTabBar({
    super.key,
    required this.tabController
  });

  List<Tab> _buildCategoryTabs(){
    return FoodCategory.values.map((cateogory){
      return Tab(
        text: cateogory.toString().split('.').last,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        dividerColor: Theme.of(context).colorScheme.secondary,
        controller: tabController,
        tabs: _buildCategoryTabs(),
      ),
    );
  }
}