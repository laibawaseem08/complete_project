import 'package:flutter/material.dart';
import 'package:full_project_1/models/food.dart';
import 'package:full_project_1/models/restaurant.dart';
import 'package:provider/provider.dart';


class FoodPage extends StatefulWidget {
  final Food food;

  const FoodPage({
    super.key,
    required this.food,
  });

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  void addToCart(Food food) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // scaffold UI

        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // food image
                Image.network(
                  widget.food.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),

                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // food name
                      Text(
                        widget.food.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),

                      //food price
                      Text(
                        '\$${widget.food.price}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      //food description
                      Text(
                        widget.food.description,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 100,
                ),
                // button-> add to cart
                ElevatedButton(
                  onPressed: () {
                    context.read<Restaurant>().addToCart(widget.food);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 70),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ),

        //back button
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              margin: const EdgeInsets.only(left: 25, top: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}