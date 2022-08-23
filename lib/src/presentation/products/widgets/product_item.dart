import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_cart_flutter/src/presentation/products/products_state.dart';

class ProductItem extends StatelessWidget {
  final ProductItemState _productItem;

  final void Function(ProductItemState productItemState)
      _addProductToCartCallback;

  const ProductItem(this._productItem, this._addProductToCartCallback);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              showDialog(
                  context: context, builder: (context) => _onTapImage(context)),
            },
        child: Card(
            child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Image.memory(base64Decode(_productItem.image)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _productItem.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                //style: Theme.of(context).textTheme.body1,
              ),
            ),
            Text(
              _productItem.price,
              //style: Theme.of(context).textTheme.headline
            ),
            RawMaterialButton(
              child: Text(
                'Agregar'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => _addProductToCartCallback(_productItem),
            )
          ],
        )));
  }

  _onTapImage(BuildContext context) {
    return Card(
        child: Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Image.memory(base64Decode(_productItem.image)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _productItem.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            //style: Theme.of(context).textTheme.body1,
          ),
        ),
        Text(
          "Incluye",
        ),
        Text(
          _productItem.descripcion,
        ),
        Text(
          "Precio: " + _productItem.price,
          //style: Theme.of(context).textTheme.headline
        ),
        RawMaterialButton(
          child: Text(
            'Salir'.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ));
  }
}
