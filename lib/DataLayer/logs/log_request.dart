import 'dart:convert';

import 'package:http/http.dart' as http;

class LogRequest {
  Future sendMessage(Map map) async {
    final String apiUrl =
        'https://api.telegram.org/bot6275619836:AAElrl6c-_PU2mTRy9HnoCdUkUTroSvZOXw/sendMessage';
    final Map<String, dynamic> requestData = {
      'chat_id': '1432168622',
      'text': jsonEncode(map),
      'disable_notification': true,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message. Error: ${response.statusCode}');
    }
  }
}
