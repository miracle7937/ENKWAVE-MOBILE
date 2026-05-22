import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class APIRequest {
  var headers = {'Content-Type': 'application/json'};
  bool realDevice = true;

  String baseUrl = "http://test.enkpay.com/api";

  Future getRequest({String? path}) async {
    var url = Uri.parse('$path');
    var response = await http.get(url, headers: headers);
    debugPrint("MIMI ${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      debugPrint("MIMI error");
      throw Exception();
    }
  }

  Future postRequest({required Map body, required String route}) async {
    var url = Uri.parse(route);
    var response =
        await http.post(url, body: json.encode(body), headers: headers);
    print(route.toString());
    print(body.toString());
    print("${response.statusCode} ${response.body}");
    if (response.statusCode == 200) {
      log("response body: ${response.body}");
      return json.decode(response.body);
    } else {
      throw Exception();
    }
  }
}
