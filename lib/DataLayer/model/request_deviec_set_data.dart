import 'package:enk_pay_project/Constant/string_values.dart';

class RequestDevicePerson {
  String? fullname;
  String? address;
  String? state;
  String? phone;

  RequestDevicePerson({
    fullname,
    address,
    state,
    phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'address': address,
      'state': state,
      'phone_no': phone,
    };
  }

  isValid() =>
      isNotEmpty(fullname) &&
      isNotEmpty(address) &&
      isNotEmpty(state) &&
      isNotEmpty(phone);
}
