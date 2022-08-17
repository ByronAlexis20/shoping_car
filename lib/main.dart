import 'package:flutter/material.dart';
import 'package:shopping_cart_flutter/dependencies_provider.dart' as di;
import 'package:shopping_cart_flutter/src/login_page.dart';
import 'package:shopping_cart_flutter/src/presentation/app.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mariscal fast food',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
      },
    );
  }
}
