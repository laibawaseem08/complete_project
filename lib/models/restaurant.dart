import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/models/cart_item.dart';
import 'package:full_project_1/models/food.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier {
  String _deliveryAddress = '';

  String get deliveryAddress => _deliveryAddress;

  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  // list of food menu
  final List<Food> _menu = [
    // burgers
    Food(
      name: "Classic Cheeseburger",
      description:
      "A juicy beef patty with melted chedder,lettuce,tomato,and a hint of onion and pickle.",
      imagePath: "lib/images/burgers/cheese_burger.jpg",
      price: 0.99,
      category: FoodCategory.burgers,
    ),

    Food(
      name: "BBQ Bacon Burger",
      description:
      "Smoky BBQ sauce,crispy bacon,and onion rings make this beef burger a savory delight.",
      imagePath: "lib/images/burgers/bbq bacon_burger.jpg",
      price: 10.99,
      category: FoodCategory.burgers,
    ),

    Food(
      name: "Veggie Burger",
      description:
      "A hearty veggie patty topped with fresh avocado,lettuce and a tomato,served on a whole grain bun.",
      imagePath: "lib/images/burgers/veggie_burger.jpg",
      price: 9.49,
      category: FoodCategory.burgers,
    ),
    Food(
      name: "Aloha Burger",
      description:
      "A char-grilled chicken breast topped with a slice of grilled pineapple,Swiss cheese,and fresh lettuce.",
      imagePath: "lib/images/burgers/aloha_burger.jpg",
      price: 9.49,
      category: FoodCategory.burgers,
    ),

    Food(
      name: "Blue Moon Burger",
      description:
      "This burger is a blue cheese lover's dress. It features a succulent ground beef patty,crumbled blue cheese.",
      imagePath: "lib/images/burgers/bluemoon_burger.jpg",
      price: 9.49,
      category: FoodCategory.burgers,
    ),

    // salads
    Food(
      name: "Caesar Salad",
      description:
      "Crisp romaine lettuce,parmesan cheese,croutons,and Caeasr dressing",
      imagePath: "lib/images/salads/caesar_salad.jpg",
      price: 7.49,
      category: FoodCategory.salads,
    ),

    Food(
      name: "Greek Salad",
      description:
      "Tomatoes,cucumbers,red onions,olives,feta cheese with olive oil and herbs.",
      imagePath: "lib/images/salads/greek_salad.jpg",
      price: 8.49,
      category: FoodCategory.salads,
    ),

    Food(
      name: "Quinoa Salad",
      description:
      "Quinoa mixed with cucumbers,tomatoes,bell peppers,and a lemon vinaigrette.",
      imagePath: "lib/images/salads/quinoa_salad.jpg",
      price: 9.99,
      category: FoodCategory.salads,
    ),

    Food(
      name: "Asian Sesame Salad",
      description:
      "Delight in the flowers of the East with this sesame-infused salad. It includes mixed.",
      imagePath: "lib/images/salads/asiansesame_salad.jpg",
      price: 9.99,
      category: FoodCategory.salads,
    ),

    Food(
      name: "South West Chicken Salad",
      description:
      "This colorful salad combines the zesty flavors of the Southwest. It's loaded with mixed",
      imagePath: "lib/images/salads/south west_salad.jpg",
      price: 9.99,
      category: FoodCategory.salads,
    ),

    // sides

    Food(
      name: "Sweet Potato Fries",
      description: "Crispy sweet potato fries with a touch of salts.",
      imagePath: "lib/images/sides/sweet potato_side.jpg",
      price: 4.99,
      category: FoodCategory.sides,
    ),
    Food(
      name: "Onion Rings",
      description: "Golden and crispy onion rings,perfect for dipping.",
      imagePath: "lib/images/sides/onion rings_side.jpg",
      price: 3.99,
      category: FoodCategory.sides,
    ),
    Food(
      name: "Garlic Bread",
      description:
      "Warm and toasty garlic bread,topped with melted butter and parsley.",
      imagePath: "lib/images/sides/garlic bread_side.jpg",
      price: 9.99,
      category: FoodCategory.sides,
    ),
    Food(
      name: "Loaded Sweet Potato Fries",
      description:
      "Savory sweet potato fries loaded with melted cheese,smoky bacon bits,and a dollop of sour cream.",
      imagePath: "lib/images/sides/loaded sweet potato_side.jpg",
      price: 4.99,
      category: FoodCategory.sides,
    ),
    Food(
      name: "Crispy Mac & Cheese Bites",
      description:
      "Golden brown, bite-sized mac and cheese balls,perfect for on-the-go snacking.Served with creamy ranch dipping sauce.",
      imagePath: "lib/images/sides/crispy mac_side.jpg",
      price: 4.99,
      category: FoodCategory.sides,
    ),

    // dessert

    Food(
      name: "Chocolate Brownie",
      description: "Rich and fudgy chocolate brownie,with chunks of chocolate.",
      imagePath: "lib/images/desserts/chocolate brownie_desserts.jpg",
      price: 5.99,
      category: FoodCategory.dessert,
    ),
    Food(
      name: "Cheesecake",
      description:
      "Creamy cheesecake on a graham cracker crust,with a berry compote.",
      imagePath: "lib/images/desserts/cheesecake_desserts.jpg",
      price: 6.99,
      category: FoodCategory.dessert,
    ),
    Food(
      name: "Apple Pie",
      description:
      "Classic apple pie with a flaky crust and a cinnamon-spiced apple filling.",
      imagePath: "lib/images/desserts/apple pie_desserts.jpg",
      price: 5.49,
      category: FoodCategory.dessert,
    ),
    Food(
      name: "Red Velvet Lava Cake",
      description:
      "A scoop of your choice of vanilla, chocolate, or strawberry.",
      imagePath: "lib/images/desserts/red velvet_desserts.jpg",
      price: 5.49,
      category: FoodCategory.dessert,
    ),
    Food(
      name: "Pear Pie",
      description:
      "A tangy and sweet key pear pie with a rich,creamy filling and a crumbly graham cracker crust.",
      imagePath: "lib/images/desserts/pear pie_desserts.jpg",
      price: 5.49,
      category: FoodCategory.dessert,
    ),

    //drinks

    Food(
      name: "Lemonade",
      description:
      "Refreshing lemonade made with real lemons and a touch of sweetness.",
      imagePath: "lib/images/drinks/lemonade_drink.jpg",
      price: 2.99,
      category: FoodCategory.drinks,
    ),
    Food(
      name: "Iced Tea",
      description: "Chilled iced tea with a hint of lemon, served over ice.",
      imagePath: "lib/images/drinks/iced tea_drink.jpg",
      price: 2.99,
      category: FoodCategory.drinks,
    ),
    Food(
      name: "Smoothie",
      description:
      "A blend of fresh fruits and yogurt, perfect for a healthy boost.",
      imagePath: "lib/images/drinks/smoothie_drink.jpg",
      price: 4.99,
      category: FoodCategory.drinks,
    ),
    Food(
      name: "Mojito",
      description:
      "A classic Cuban cocktail with muddled lime and mint, sweetened with sugar.",
      imagePath: "lib/images/drinks/mojito_drink.jpg",
      price: 4.99,
      category: FoodCategory.drinks,
    ),
    Food(
      name: "Caramel Macchiato",
      description:
      "A layered coffee drink with steamed milk, espresso, and vanilla syrup.",
      imagePath: "lib/images/drinks/cramel macchiato_drink.jpg",
      price: 4.99,
      category: FoodCategory.drinks,
    ),
  ];

          // user cart

  final List<CartItem> _cart = [];

  List<Food> get menu => _menu;

  List<CartItem> get cart => _cart;
   // add to cart
  void addToCart(Food food) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      //check if the food item are the same
      bool isSameFood = item.food == food;

      return isSameFood;
    });

    // if the item already exists, increase it's quantity
    if (cartItem != null) {
      cartItem.quantity++;
    }
    // otherwise, add a new cart item to the cart
    else {
      _cart.add(
        CartItem(
          food: food,
        ),
      );
    }
    notifyListeners();
  }

   // remove from cart

  void removeFromcart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  void removeWholeItem(CartItem item) {
    _cart.removeWhere((cartItem) => cartItem.food == item.food);
    notifyListeners();
  }

   // get total price of cart

  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      total += cartItem.food.price * cartItem.quantity;
    }

    return total;
  }

// get total number of items in cart
  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }

 // clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

// generate a receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt.");
    receipt.writeln();

    // format the date to include up to seconds only
    String formattedDate =
    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("__________");

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} * ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      receipt.writeln();
    }

    receipt.writeln("________");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln();
    receipt.writeln("Delivering to: $deliveryAddress");
    receipt.writeln();
    receipt.writeln("Payment: Paid ");

    return receipt.toString();
  }

// format double value into money
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }
}
