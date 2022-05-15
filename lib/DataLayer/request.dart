import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'LocalData/local_data_storage.dart';

final String baseUrl = '';

Future<Map<String, String>> getHeader() async {
  var token = await LocalDataStorage.getToken() ??
      "37|V6esZWpEjprIn87Wv2VxtlIajOVYubiRzFbJozTo";
  print("APP Token  $token");
  var header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  return header;
}

class ServerRequest {
  String? deviceId;

  Future<HttpResponse> getData({
    String? path,
  }) async {
    var header = await getHeader();
    var url = Uri.parse(path!);

    try {
      var response = await http.get(url, headers: header);
      var data = jsonDecode(response.body);
      print("$data  route: $path");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpData(data);
      } else {
        return HttpData(data);
      }
    } catch (e) {
      print('exception get $e');
      return HttpException('Something wrong happened');
    }
  }

  Future<HttpResponse> postData(
      {String? path, Map? body, List<Map>? bodyII}) async {
    debugPrint(path! + body.toString());
    var header = await getHeader();

    try {
      var url = Uri.parse(path);

      var response = await http
          .post(
        url,
        body: json.encode(body ?? bodyII),
        headers: header,
      )
          .timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('process time out');
        },
      );
      var data = jsonDecode(response.body);
      print("${response.statusCode} status code");
      print("${response.body} MIMI");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpData(data);
      } else {
        return HttpData(data);
      }
    } catch (e) {
      debugPrint('exception post ${e.toString()}');

      if (e is SocketException) {
        throw HttpException(
            {"message": 'No Internet connection', "error": true});
      }
      if (e is FormatException) {
        throw HttpException({"message": 'Bad response format', "error": true});
      }
      if (e is HandshakeException) {
        throw HttpException({"message": 'Handshake exception', "error": true});
      }
      if (e is TimeoutException) {
        throw HttpException(
            {"message": 'This process has been timed out', "error": true});
      }
      throw HttpException(
          {"message": 'Something wrong happened', "error": true});
    }
  }

  Future putData(BuildContext context,
      {String? path, Map? body, List<Map>? bodyII}) async {
    var header = await getHeader();
    debugPrint(path);

    try {
      var url = Uri.parse(path!);

      var response = await http.put(url,
          body: json.encode(body ?? bodyII), headers: header);
      debugPrint(body.toString());

      var data = jsonDecode(response.body);

      // print("$data  route: $path");
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpData(data);
      } else {
        return HttpData(data);
      }
    } catch (e) {
      return HttpException(
          {"message": 'something wrong happened', "error": true});
    }
  }

  Future uploadNoFile(
    BuildContext context, {
    String? path,
    Map? body,
  }) async {
    final header = await getHeader();
    var postUri = Uri.parse('$baseUrl$path');
    var request = http.MultipartRequest(
      "POST",
      postUri,
    );
    request.headers.addAll(header);

    body!.forEach((key, value) {
      // print('$key $value');
      request.fields['$key'] = value.toString();
    });

    var response = await request.send();

    var data = jsonDecode(await response.stream.bytesToString());

    debugPrint(response.toString());
    if (response.statusCode == 401) {}
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('successful');
      return HttpData(data["data"]);
      // return true;
    } else {
      debugPrint('fails');
      return HttpException(null);
    }
  }
  //

  Future uploadFile(BuildContext context,
      {String? path, Map? body, File? file, imageKey}) async {
    var stream = http.ByteStream(DelegatingStream.typed(file!.openRead()));
    var length = await file.length();
    final header = await getHeader();
    var postUri = Uri.parse('$baseUrl$path');
    var request = http.MultipartRequest(
      "POST",
      postUri,
    );
    request.headers.addAll(header);

    body!.forEach((key, value) {
      request.fields['$key'] = value.toString();
    });
    var multipartFileSign = http.MultipartFile(imageKey, stream, length,
        filename: basename(file.path));
    request.files.add(multipartFileSign);

    var response = await request.send();

    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 401) {}

    print(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('successful');
      return HttpData(data["data"]);
      // return true;
    } else {
      debugPrint('fails');
      return HttpException(null);
    }
  }

  Future<HttpResponse> deleteData(
    BuildContext context, {
    String? path,
  }) async {
    var header = await getHeader();

    try {
      var url = Uri.parse('$path');

      var response = await http.delete(url, headers: header);
      var data = jsonDecode(response.body);
      debugPrint("$data  route: $path");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpData(data);
      } else {
        return HttpData(data);
      }
    } catch (e) {
      debugPrint('exception get $e');
      return HttpException('something wrong happened');
    }
  }
}

//request  http request

abstract class HttpResponse {
  dynamic data;
}

class HttpException extends HttpResponse {
  final data;

  HttpException(this.data);
  get getMessage => data["message"];
}

class HttpData extends HttpResponse {
  final data;
  HttpData(this.data);
}
