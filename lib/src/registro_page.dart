import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_flutter/src/login_page.dart';

class RegistroPage extends StatefulWidget {
  @override
  State<RegistroPage> createState() => _RegistroPage();
}

class _RegistroPage extends State<RegistroPage> {
  final TextEditingController cedulaController = new TextEditingController();
  final TextEditingController celularController = new TextEditingController();
  final TextEditingController nombresController = new TextEditingController();
  final TextEditingController apellidosController = new TextEditingController();
  final TextEditingController correoController = new TextEditingController();
  final TextEditingController claveController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrarse"),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _cedula(),
            _celular(),
            _nombres(),
            _apellidos(),
            _correo(),
            _clave(),
            _botonAceptar(),
          ],
        ),
      )),
    );
  }

  Widget _cedula() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: TextField(
          controller: cedulaController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            hintText: 'Ingrese su cédula',
            labelText: 'Cédula',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      );
    });
  }

  Widget _celular() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: TextField(
          controller: celularController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            hintText: 'Ingrese su celular',
            labelText: 'Celular',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      );
    });
  }

  Widget _nombres() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: TextField(
          controller: nombresController,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            hintText: 'Ingrese sus nombres',
            labelText: 'Nombres',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      );
    });
  }

  Widget _apellidos() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: TextField(
          controller: apellidosController,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            hintText: 'Ingrese sus apellidos',
            labelText: 'Apellidos',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      );
    });
  }

  Widget _correo() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.always,
          controller: correoController,
          validator: (value) => validateEmail(value),
          decoration: InputDecoration(
            hintText: 'Ingrese su correo',
            labelText: 'Correo',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      );
    });
  }

  Widget _clave() {
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      );
    });
  }

  Widget _botonAceptar() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return RaisedButton(
        hoverColor: Colors.lightBlue,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: Text(
            'Registrar',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20.0,
            ),
          ),
        ),
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirmar'),
            content: const Text('Registrar cliente?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => {grabarCliente(context)},
                child: const Text('Aceptar'),
              ),
            ],
          ),
        ),
      );
    });
  }

  String validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return 'Ingrese un correo válido';
    else
      return null;
  }

  grabarCliente(context) async {
    if (validateEmail(correoController.text) != null) {
      return;
    }
    var response = await http.post(
      Uri.parse("http://localhost:4041/seguridad/usuariocliente/guardar"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id": null,
        "cedula": cedulaController.text,
        "celular": celularController.text,
        "nombres": nombresController.text,
        "apellidos": apellidosController.text,
        "correo": correoController.text,
        "clave": claveController.text
      }),
    );
    var jsonResponse = null;

    jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: jsonResponse['mensaje'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.blue);
    } else {
      if (response.statusCode == 201) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Correcto'),
            content: const Text('Cliente registrado con exito, inicie sesion!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false),
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    }
  }
}
