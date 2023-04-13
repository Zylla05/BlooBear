import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Network{
  static Future<String?> isesion(String correo, String contrasena) async {
    print(correo);
    print(contrasena);
    final response = await http.post(
        Uri.parse(
          "http://192.168.100.24:3000/login",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          "email": correo,
          "password": contrasena,
        }));
    if (response.statusCode >= 200 && response.statusCode <300) {
      return response.body;
    }
    if (response.statusCode >= 400) {
      return response.body;
    }
    
  }
}