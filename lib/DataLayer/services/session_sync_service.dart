import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/DataLayer/repository/dashboard_repository.dart';

/// Keeps local user + POS session aligned with login / user-info API payloads.
class SessionSyncService {
  /// GET /user-info — same shape as login (`data` + `tid_config`).
  static Future<LoginResponseModel> fetchFromServer() {
    return DashboardRepository().fetch();
  }

  /// If API omitted `terminal_info`, derive from legacy user columns when present.
  static UserData? _withTerminalFallback(UserData? user) {
    if (user == null) return null;
    final existing = user.terminalInfo?.terminalNo?.trim();
    if (existing != null && existing.isNotEmpty) return user;

    final terminalNo = (user.terminalId?.trim().isNotEmpty == true)
        ? user.terminalId!.trim()
        : (user.serialNo?.trim().isNotEmpty == true ? user.serialNo!.trim() : null);
    if (terminalNo == null) return user;

    user.terminalInfo = TerminalInfo(
      terminalNo: terminalNo,
      deviceSN: user.serialNo?.trim().isNotEmpty == true
          ? user.serialNo!.trim()
          : terminalNo,
      merchantName:
          '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
    );
    return user;
  }

  /// Persist `data`, `terminal_info`, and root `tid_config` from the API.
  static Future<UserData?> persist(LoginResponseModel result) async {
    UserData? user = _withTerminalFallback(result.data);
    if (user != null) {
      await LocalDataStorage.saveUserData(user);
    }
    if (result.terminalConfig != null) {
      await LocalDataStorage.saveTerminalConfig(result.terminalConfig);
    }
    return user;
  }

  static Future<UserData?> refreshAndPersist() async {
    final result = await fetchFromServer();
    return persist(result);
  }
}
