import 'dart:convert';

import 'package:shopping_cart_flutter/src/domain/cart/Cart.dart';
import 'package:shopping_cart_flutter/src/domain/cart/CartItem.dart';
import 'package:shopping_cart_flutter/src/domain/cart/cart_repository.dart';

const jsonCart = '''[
  
  ]''';

class CartInMemoryRepository implements CartRepository {
  Cart cart = Cart.createEmpty();

  CartInMemoryRepository() {
    cart = _parse(jsonDecode(jsonCart));
  }

  @override
  Future<Cart> get() async {
    return Future.delayed(const Duration(milliseconds: 100), () => cart);
  }

  @override
  Future<bool> save(Cart cart) async {
    return Future.delayed(const Duration(milliseconds: 100), () {
      this.cart = cart;
      return true;
    });
  }

  Cart _parse(List<dynamic> json) {
    return Cart(json
        .map((jsonItem) => CartItem(jsonItem['id'], jsonItem['image'],
            jsonItem['title'], jsonItem['price'], jsonItem['quantity']))
        .toList());
  }
}
