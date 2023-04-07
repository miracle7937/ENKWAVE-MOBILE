import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/model/user_credential_model.dart';
import 'package:local_auth/local_auth.dart';

class BiometricController {
  static LocalAuthentication auth = LocalAuthentication();
  // ···
  static Future<bool> isBiometricEnable() async {
    UserCredentialModel? userCredentialModel =
        await LocalDataStorage.getUserCredential();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.face)) {
      return true && canAuthenticate && userCredentialModel != null;
    }
    return false;
  }

  static Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to access application',
          biometricOnly: true);
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
