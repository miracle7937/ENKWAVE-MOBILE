import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/repository/tid_config_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/material.dart';

class TerminalConfigController extends ChangeNotifier {
  final _repo = TidConfigRepository();

  PageState pageState = PageState.loaded;
  TerminalConfig? config;

  final ipController = TextEditingController();
  final portController = TextEditingController();
  final sslController = TextEditingController();
  final compKey1Controller = TextEditingController();
  final compKey2Controller = TextEditingController();
  final baseUrlController = TextEditingController();
  final logoUrlController = TextEditingController();

  Future<void> load() async {
    pageState = PageState.loading;
    notifyListeners();
    try {
      config = await LocalDataStorage.getTerminalConfig();
      config ??= await _repo.fetch();
      _bindControllers();
    } finally {
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  Future<bool> save() async {
    pageState = PageState.loading;
    notifyListeners();
    try {
      final payload = TerminalConfig(
        ip: ipController.text.trim(),
        port: portController.text.trim(),
        ssl: sslController.text.trim(),
        compKey1: compKey1Controller.text.trim(),
        compKey2: compKey2Controller.text.trim(),
        baseUrl: baseUrlController.text.trim(),
        logoUrl: logoUrlController.text.trim(),
      );
      config = await _repo.save(payload);
      await LocalDataStorage.saveTerminalConfig(config);
      return true;
    } catch (_) {
      return false;
    } finally {
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  void _bindControllers() {
    ipController.text = config?.ip ?? '';
    portController.text = config?.port ?? '';
    sslController.text = config?.ssl ?? '';
    compKey1Controller.text = config?.compKey1 ?? '';
    compKey2Controller.text = config?.compKey2 ?? '';
    baseUrlController.text = config?.baseUrl ?? '';
    logoUrlController.text = config?.logoUrl ?? '';
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    sslController.dispose();
    compKey1Controller.dispose();
    compKey2Controller.dispose();
    baseUrlController.dispose();
    logoUrlController.dispose();
    super.dispose();
  }
}
