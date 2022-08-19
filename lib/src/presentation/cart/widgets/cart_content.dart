import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart_flutter/src/presentation/cart/cart_state.dart';
import 'package:shopping_cart_flutter/src/presentation/cart/widgets/cart_content_item.dart';
import 'package:http/http.dart' as http;

class CartContent extends StatelessWidget {
  final CartState _cartState;
  final void Function(CartItemState cartItemState, int quantity)
      _editQuantityOfCartItemCallback;
  final void Function(CartItemState cartItemState, int tipo)
      _removeItemFromCartCallback;

  const CartContent(this._cartState, this._editQuantityOfCartItemCallback,
      this._removeItemFromCartCallback);

  @override
  Widget build(BuildContext context) {
    final totalPrice = () => Column(children: <Widget>[
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('total'),
              Text(_cartState.totalPrice),
            ],
          ),
          Divider(height: 15.0),
          RaisedButton(
            hoverColor: Colors.lightBlue,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Text(
                'Pedir',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20.0,
                ),
              ),
            ),
            color: Colors.lightBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirmar'),
                content: const Text('Desea realizar el pedido'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => {enviarPedido(context)},
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            ),
          )
        ]);

    final cartItems = () => ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _cartState.items.length + 1,
        itemBuilder: (context, index) {
          if (index < _cartState.items.length) {
            final CartItemState cartItemState = _cartState.items[index];

            return CartContentItem(cartItemState,
                _editQuantityOfCartItemCallback, _removeItemFromCartCallback);
          } else {
            return totalPrice();
          }
        });

    final emptyCartItems = () => Padding(
        padding: const EdgeInsets.all(16.0), child: Text('Carrito vacío!'));

    final content =
        _cartState.items.isNotEmpty ? (cartItems()) : emptyCartItems();

    return content;
  }

  enviarPedido(context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String data = "[ ";
    for (var prod in _cartState.items) {
      data = data +
          "{ \"idProducto\": " +
          prod.id +
          ", \"cantidad\": " +
          prod.quantity.toString() +
          " },";
    }
    data = data.substring(0, data.length - 1);
    data = data + " ] ";

    final dataEnviar = json.decode(data);
    var idcliente = sharedPreferences.getString("idCliente");
    var response = await http.post(
        Uri.parse(
            "http://localhost:4042/mff-administracion/pedido/generarPedido/$idcliente"),
        body: data);
    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Correcto'),
          content: const Text('Se realizó el pedido con éxito'),
          actions: <Widget>[
            TextButton(
              onPressed: () => {Navigator.of(context).pop()},
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      _removeItemFromCartCallback(null, 0);
    }
  }
}
