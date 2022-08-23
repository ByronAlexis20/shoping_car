import 'package:flutter/material.dart';
import 'package:shopping_cart_flutter/src/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart_flutter/src/presentation/app.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int _cartItemsCounter;

  MyAppBar(this._cartItemsCounter, {Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; //

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Productos"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            cerrarSesion(context);
          },
          child: Text("Salir", style: TextStyle(color: Colors.white)),
        ),
        shoppingCartIcon(context),
      ],
    );
  }

  Widget shoppingCartIcon(BuildContext context) {
    final badge = _cartItemsCounter != 0 ? counterBadge() : Container();

    // Using Stack to show Notification Badge
    return Stack(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
        badge
      ],
    );
  }

  Widget counterBadge() {
    return Positioned(
      right: 5,
      top: 5,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: const BoxConstraints(
          minWidth: 18,
          minHeight: 18,
        ),
        child: Text(
          '$_cartItemsCounter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  cerrarSesion(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }
}
