import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'LocalData/local_data_storage.dart';

Future<Map<String, String>> getHeader() async {
  var token = await LocalDataStorage.getToken() ?? "";
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
      print("$data  route: $path  status: ${response.statusCode}");

      if (data["status_code"] == 401) {
        Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
          '/signInScreen',
          (route) => false,
        );
        //  return  TimeoutException('process time out');
        // return;
        throw HttpException({
          "message": 'Sessions expired',
        });
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpData(data);
      } else {
        return HttpData(data);
      }
    } catch (e) {
      debugPrint('exception post ${e.toString()}');
      if (e is HttpException) {
        throw HttpException({"message": e.toString(), "error": true});
      }

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

  Future<HttpResponse> postData(
      {String? path, Map? body, List<Map>? bodyII}) async {
    log("${path}    ${body.toString()}");
    var header = await getHeader();

    try {
      var url = Uri.parse(path!);

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
      print("${response.body}");
      if (data["status_code"] == 401) {
        Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
          '/signInScreen',
          (route) => false,
        );
        throw HttpException({
          "message": 'Sessions expired',
        });
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HttpData(data);
      } else {
        return HttpException(
            {"message": 'something wrong happened', "error": true});
      }
    } catch (e) {
      debugPrint('exception post ${e.toString()}');
      if (e is HttpException) {
        throw HttpException({"message": e.toString(), "error": true});
      }

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
    log(path.toString());

    try {
      var url = Uri.parse(path!);

      var response = await http.put(url,
          body: json.encode(body ?? bodyII), headers: header);
      debugPrint(body.toString());

      var data = jsonDecode(response.body);

      // print("$data  route: $path");
      log(response.statusCode.toString());

      if (data["status_code"] == 401) {
        Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
          '/signInScreen',
          (route) => false,
        );
        throw HttpException({
          "message": 'Sessions expired',
        });
      }

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
    var postUri = Uri.parse('$path');
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

  Future uploadFile(
      {String? path, Map? body, List<FileKeyValue>? fileKeyValue}) async {
    final header = await getHeader();
    log("BODY: $body");
    log("File: $fileKeyValue");
    var postUri = Uri.parse('$path');
    var request = http.MultipartRequest(
      "POST",
      postUri,
    );
    if (fileKeyValue != null) {
      for (var value in fileKeyValue) {
        request.files.add(
            await http.MultipartFile.fromPath(value.key!, value.file!.path));
      }
    }

    request.headers.addAll(header);

    body!.forEach((key, value) {
      request.fields['$key'] = value.toString();
    });

    var response = await request.send();
    print("MIMI ${response.statusCode}");
    http.Response v = await http.Response.fromStream(response);
    var data = json.decode(v.body);
    print("MIMI2 $data");
    // var data = json.decode(await response.stream.bytesToString());
    // print("MIMI3 $data}");

    if (data["status_code"] == 401) {
      Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
        '/signInScreen',
        (route) => false,
      );
      throw HttpException({"message": 'Sessions expired', "error": true});
    }
    print(data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('successful');
      return HttpData(data);
      // return true;
    } else {
      print('fails');
      throw HttpException(data["message"]);
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

class FileKeyValue {
  final String? key;
  final File? file;
  FileKeyValue(this.key, this.file);
}

abstract class HttpResponse {
  dynamic data;
}

class HttpException extends HttpResponse {
  final data;

  HttpException(this.data);
  get getMessage => data["message"];

  @override
  toString() => data["message"];
}

class HttpData extends HttpResponse {
  final data;
  HttpData(this.data);
}
