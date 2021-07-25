import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final String url;

  NetworkHelper({@required this.url});

  Future getCoinDataFromURL() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      if (decodedData != null) {
        return decodedData;
      }
    } else {
      print(response.statusCode);
    }
  }
}
