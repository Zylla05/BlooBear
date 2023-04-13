import 'dart:convert';

import 'package:bloobear/Screens/isesion.dart';
import 'package:bloobear/Screens/principal.dart';
import 'package:bloobear/Screens/registro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Styles/const.dart' as constantes;

class Network {
  static Future<String?> buscador(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<String?> destino(query) async {
    Uri uri = Uri.https("maps.googleapis.com", 'maps/api/place/details/json',
        {"place_id": query, "key": "AIzaSyCryq-_5ADfOEu86wNim22jXNtMpjLpwdA"});

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("Peto");
    }
    return null;
  }

  static Future<String?> ruta(orila, oriln, desla, desln) async {
    var origin = "$orila,$oriln";
    var des = "$desla,$desln";
    Uri uri = Uri.https("maps.googleapis.com", 'maps/api/directions/json', {
      "origin": origin,
      "destination": des,
      "key": "AIzaSyCryq-_5ADfOEu86wNim22jXNtMpjLpwdA"
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("Peto");
    }
    return null;
  }

  static Future<String?> idAuto(id) async {
    var server = constantes.server;
    final response = await http.get(
      Uri.parse(
        "$server/iot/$id",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    return response.body;
  }

  static Future<String?> renta() async {
    var server = constantes.server;
    var tok = constantes.token;
    var id = constantes.id;
    final response = await http.post(
        Uri.parse(
          "$server/iot/rent",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Bearer $tok'
        },
        body: jsonEncode(<String, String>{
          "id": "$id",
        }));
    var respuesta = response.body;
    print("respuesta = $respuesta");
    if (response.statusCode == 201) {
      constantes.mkey = response.body;
      return response.body;
    } else {
      return null;
    }
  }

  static cambio() async {
    var server = constantes.kata;
    var mink = constantes.mkey;
    final response = await http.post(
        Uri.parse(
          "$server/strikenft",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "mint":"$mink",
        }));
    var respuesta = response.body;
    print("respuesta = $respuesta");
    if (response.statusCode == 201) {
      return response.body;
    } else {
      return null;
    }
  }

  static registro(context) async {
    var server = constantes.server;
    var correo = constantes.correo;
    var nombre = constantes.nombre;
    final response = await http.post(
        Uri.parse(
          "$server/register",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          "name": nombre,
          "email": correo,
        }));
    print(response.body);
    if (response.statusCode == 201) {
      constantes.token = response.body;
      login(context);
    }
  }

  static login(context) async {
    var server = constantes.server;
    var correo = constantes.correo;
    final response = await http.post(
        Uri.parse(
          "$server/login",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          "email": correo,
        }));
    print(response.body);
    if (response.statusCode == 201) {
      constantes.token = response.body;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InicioSesion()));
    }
    if (response.statusCode == 404) {
      constantes.token = response.body;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Registro()));
    }
  }

  static init(context) async {
    var server = constantes.server;
    var code = constantes.code;
    var tok = constantes.token;
    var mail = constantes.correo;
    print(tok);
    final response = await http.post(
        Uri.parse(
          "$server/init",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Bearer $tok'
        },
        body: jsonEncode(<String, String>{
          "email": mail,
          "code": code,
        }));
    print(response.body);
    if (response.statusCode == 201) {
      constantes.token = response.body;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Mapa()));
    } else {
      print(response.body);
    }
  }
}
