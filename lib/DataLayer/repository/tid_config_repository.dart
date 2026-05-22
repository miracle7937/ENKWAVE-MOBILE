import 'dart:convert';

import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/request.dart';
import 'package:http/http.dart' as http;

class TidConfigRepository {
  Future<TerminalConfig?> fetch() async {
    final response = await ServerRequest().getData(path: AppRoute.tidConfig);
    final map = response.data as Map<String, dynamic>;
    if (map['status'] != true || map['data'] == null) return null;
    return TerminalConfig.fromJson(map['data'] as Map<String, dynamic>);
  }

  Future<TerminalConfig> save(TerminalConfig config) async {
    final headers = await getHeader();
    final res = await http.put(
      Uri.parse(AppRoute.tidConfig),
      headers: headers,
      body: jsonEncode(config.toJson()),
    );
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200 || map['status'] != true) {
      throw Exception(map['message']?.toString() ?? 'Save failed');
    }
    return TerminalConfig.fromJson(map['data'] as Map<String, dynamic>);
  }
}
