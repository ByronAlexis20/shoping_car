import 'package:shopping_cart_flutter/src/domain/cart/CartItem.dart';

class Cart {
  final List<CartItem> items;

  final double totalPrice;
  final int totalItems;

  Cart(this.items)
      : totalPrice = _calculateTotalPrice(items),
        totalItems = _calculateTotalItems(items);

  factory Cart.createEmpty() {
    return Cart([]);
  }

  Cart addItem(CartItem item) {
    final existedItem =
        items.firstWhere((i) => i.id == item.id, orElse: () => null);

    if (existedItem != null) {
      final newItems = items.map((oldItem) {
        if (oldItem.id == item.id) {
          if (oldItem.quantity < oldItem.stock) {
            return CartItem(oldItem.id, oldItem.image, oldItem.title,
                oldItem.price, oldItem.quantity + item.quantity, oldItem.stock);
          }
          return oldItem;
        } else {
          return oldItem;
        }
      }).toList();

      return Cart(newItems);
    } else {
      final newItems = List.of(items);
      newItems.add(item);
      return Cart(newItems);
    }
  }

  Cart removeItem(CartItem itemToRemove, int tipo) {
    var newItems;
    if (tipo == 0) {
      print("es cero");
      newItems = items.where((item) => item.id == tipo).toList();
    } else {
      print("no es cero");
      newItems = items.where((item) => item.id != itemToRemove.id).toList();
    }
    return Cart(newItems);
  }

  Cart editItem(CartItem item, int quantity) {
    final newItems = items.map((oldItem) {
      if (oldItem.id == item.id) {
        return CartItem(oldItem.id, oldItem.image, oldItem.title, oldItem.price,
            quantity, oldItem.stock);
      } else {
        return oldItem;
      }
    }).toList();

    return Cart(newItems);
  }

  static double _calculateTotalPrice(List<CartItem> items) {
    final double price = items.fold(
        0, (accumulator, item) => accumulator + (item.quantity * item.price));

    return double.parse(price.toStringAsFixed(2));
  }

  static int _calculateTotalItems(List<CartItem> items) {
    return items.fold(0, (accumulator, item) => accumulator + item.quantity);
  }
}
