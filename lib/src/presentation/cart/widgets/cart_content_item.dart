import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_cart_flutter/src/presentation/cart/cart_state.dart';
import 'dart:convert';

class CartContentItem extends StatelessWidget {
  final CartItemState _cartItemState;
  final TextEditingController _quantityController = TextEditingController();
  final void Function(CartItemState cartItemState, int tipo)
      _removeItemFromCartCallback;
  final void Function(CartItemState cartItemState, int quantity)
      _editQuantityOfCartItemCallback;

  CartContentItem(
    this._cartItemState,
    this._editQuantityOfCartItemCallback,
    this._removeItemFromCartCallback,
  );

  @override
  Widget build(BuildContext context) {
    _quantityController.text = _cartItemState.quantity.toString();

    _quantityController.addListener(() {
      final int quantity = int.tryParse(_quantityController.text) ?? 0;
      if (quantity > _cartItemState.stock) {
        _quantityController.text = '1';
        _editQuantityOfCartItemCallback(_cartItemState, 1);
        return;
      }
      if (quantity != _cartItemState.quantity) {
        _editQuantityOfCartItemCallback(_cartItemState, quantity);
      }
    });

    final imageWidget = Image.memory(base64Decode(_cartItemState.image));

    final descriptionWidget = Column(children: <Widget>[
      Text(
        _cartItemState.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      Row(
        children: <Widget>[
          Expanded(
              child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [])),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _cartItemState.price,
                  ))),
        ],
      )
    ]);

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 16.0, right: 8.0, bottom: 16.0),
                      child: imageWidget)),
              Expanded(flex: 3, child: descriptionWidget),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => _removeItemFromCartCallback(_cartItemState, 1),
              )
            ],
          ),
        ));
  }
}
