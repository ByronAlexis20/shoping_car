import 'dart:convert';
import 'package:shopping_cart_flutter/dependencies_provider.dart' as di;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_cart_flutter/src/presentation/app.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController claveController = new TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => App()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Login',
              style: TextStyle(fontFamily: 'NerkoOne', fontSize: 50.0),
            ),
            CircleAvatar(
              radius: 100.0,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('images/logomff.png'),
            ),
            SizedBox(
              height: 15.0,
            ),
            _emailTextField(),
            SizedBox(
              height: 15.0,
            ),
            _claveTextField(),
            SizedBox(
              height: 15.0,
            ),
            _buttonLogin(),
          ],
        ),
      ),
    ));
  }

  Widget _emailTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: TextField(
          controller: emailController,
          autofocus: true,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            hintText: 'alguien@correo.com',
            labelText: 'Ingrese su correo',
            suffixIcon: Icon(Icons.email),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
      );
    });
  }

  Widget _claveTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: TextField(
          controller: claveController,
          enableInteractiveSelection: false,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Ingrese su clave',
            labelText: 'Clave',
            suffixIcon: Icon(Icons.lock_outline),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
      );
    });
  }

  Widget _buttonLogin() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return RaisedButton(
        hoverColor: Colors.lightBlue,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: Text(
            'Iniciar sesión',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20.0,
            ),
          ),
        ),
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          signIn(emailController.text, claveController.text);
        },
      );
    });
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'usuario': email, 'password': pass};
    var jsonResponse = null;

    var response = await http.post(
        Uri.parse("http://localhost:4040/api/authcliente/login"),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        var codigoUsuario = jsonResponse['codUsuario'];
        sharedPreferences.setString("token", jsonResponse['token']);
        sharedPreferences.setString("idCliente", codigoUsuario.toString());
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => App()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Email o clave incorrecto",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.blue);
    }
  }
}
