import 'package:flutter/material.dart';
import 'package:full_project_1/components/my_quatity_selector.dart';
import 'package:full_project_1/models/cart_item.dart';
import 'package:full_project_1/models/restaurant.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // food image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6, top: 6),
                      child: Image.network(
                        cartItem.food.imagePath,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 100);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // food details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.food.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\$${cartItem.food.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        QuantitySelector(
                          quantity: cartItem.quantity,
                          food: cartItem.food,
                          onDecrement: () {
                            restaurant.removeFromcart(cartItem);
                          },
                          onIncrement: () {
                            restaurant.addToCart(
                              cartItem.food,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      restaurant.removeWholeItem(cartItem);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
