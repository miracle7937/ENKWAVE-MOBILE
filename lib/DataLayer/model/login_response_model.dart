import 'package:enk_pay_project/Constant/string_values.dart';

class LoginResponseModel {
  bool? status;
  String? message;
  UserData? data;
  APPPermission? permission;
  AppSettings? appSettings;

  LoginResponseModel({status, message, data, permission, appSettings});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    permission = json['permission'] != null
        ? APPPermission.fromJson(json['permission'])
        : null;

    appSettings =
        json['setting'] != null ? AppSettings.fromJson(json['setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }

    if (appSettings != null) {
      map['setting'] = data!.toJson();
    }
    return map;
  }
}

class UserData {
  String? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? image;
  int? type;
  String? role;
  String? pin;
  int? isPhoneVerified;
  int? isEmailVerified;
  int? isBvnVerified;
  String? createdAt;
  String? updatedAt;
  String? lastActiveAt;
  String? uniqueId;
  String? referralId;
  String? gender;
  String? occupation;
  String? deviceId;
  String? fcmToken;
  int? isActive;
  String? identificationType;
  String? identificationNumber;
  String? identificationImage;
  int? isIdentificationVerified;
  int? isKycVerified;
  String? addressLine1;
  String? city;
  String? state;
  String? lga;
  String? bvn;
  String? bankName;
  String? accountNumber;
  String? accountName;
  num? mainWallet;
  num? bonusWallet;
  String? virtualAccount;
  String? smsCode;
  num? status;
  String? dob;
  String? street;
  String? terminalId;
  String? serialNo;
  String? token;
  String? vAccountNo;
  String? vBankName;
  String? vAccountName;

  UserData(
      {id,
      firstName,
      lastName,
      phone,
      email,
      image,
      type,
      role,
      pin,
      isPhoneVerified,
      isEmailVerified,
      isBvnVerified,
      createdAt,
      updatedAt,
      lastActiveAt,
      uniqueId,
      referralId,
      gender,
      occupation,
      deviceId,
      fcmToken,
      isActive,
      identificationType,
      identificationNumber,
      identificationImage,
      isIdentificationVerified,
      isKycVerified,
      addressLine1,
      city,
      state,
      lga,
      bvn,
      bankName,
      accountNumber,
      accountName,
      mainWallet,
      bonusWallet,
      virtualAccount,
      smsCode,
      status,
      dob,
      street,
      terminalId,
      serialNo,
      token,
      vAccountNo,
      vAccountName,
      vBankName});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    type = json['type'];
    role = json['role'];
    pin = json['pin'];
    isPhoneVerified = json['is_phone_verified'];
    isEmailVerified = json['is_email_verified'];
    isBvnVerified = json['is_bvn_verified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastActiveAt = json['last_active_at'];
    uniqueId = json['unique_id'];
    referralId = json['referral_id'];
    gender = json['gender'];
    occupation = json['occupation'];
    deviceId = json['device_id'];
    fcmToken = json['fcm_token'];
    isActive = json['is_active'];
    identificationType = json['identification_type'];
    identificationNumber = json['identification_number'];
    identificationImage = json['identification_image'];
    isIdentificationVerified = json['is_identification_verified'];
    isKycVerified = json['is_kyc_verified'];
    addressLine1 = json['address_line1'];
    city = json['city'];
    state = json['state'];
    lga = json['lga'];
    bvn = json['bvn'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    mainWallet = json['main_wallet'];
    bonusWallet = json['bonus_wallet'];
    virtualAccount = json['virtual_account'];
    smsCode = json['sms_code'];
    status = json['status'];
    dob = json['dob'];
    street = json['street'];
    terminalId = json['terminal_id'];
    serialNo = json['serial_no'];
    token = json['token'];
    vAccountNo = json['v_account_no'];
    vAccountName = json['v_account_name'];
    vBankName = json['v_bank_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    data['type'] = type;
    data['role'] = role;
    data['pin'] = pin;
    data['is_phone_verified'] = isPhoneVerified;
    data['is_email_verified'] = isEmailVerified;
    data['is_bvn_verified'] = isBvnVerified;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['last_active_at'] = lastActiveAt;
    data['unique_id'] = uniqueId;
    data['referral_id'] = referralId;
    data['gender'] = gender;
    data['occupation'] = occupation;
    data['device_id'] = deviceId;
    data['fcm_token'] = fcmToken;
    data['is_active'] = isActive;
    data['identification_type'] = identificationType;
    data['identification_number'] = identificationNumber;
    data['identification_image'] = identificationImage;
    data['is_identification_verified'] = isIdentificationVerified;
    data['is_kyc_verified'] = isKycVerified;
    data['address_line1'] = addressLine1;
    data['city'] = city;
    data['state'] = state;
    data['lga'] = lga;
    data['bvn'] = bvn;
    data['bank_name'] = bankName;
    data['account_number'] = accountNumber;
    data['account_name'] = accountName;
    data['main_wallet'] = mainWallet;
    data['bonus_wallet'] = bonusWallet;
    data['virtual_account'] = virtualAccount;
    data['sms_code'] = smsCode;
    data['status'] = status;
    data['dob'] = dob;
    data['street'] = street;
    data['terminal_id'] = terminalId;
    data['serial_no'] = serialNo;
    data['token'] = token;
    data['v_account_no'] = vAccountNo;
    data['v_account_name'] = vAccountName;
    data['v_bank_name'] = vBankName;
    return data;
  }

  bool isStatusCompleted() {
    return status == 2;
  }

  bool isEmailVerificationCompleted() {
    return isEmailVerified == 1;
  }

  bool isPhoneVerificationCompleted() {
    return isPhoneVerified == 1;
  }

  bool isIdentificationVerifiedCompleted() {
    return isIdentificationVerified == 1;
  }

  bool isBVNAndNINCompleted() {
    return isKycVerified == 1;
  }

  bool userHaveAccount() {
    return isNotEmpty(vAccountNo);
  }

  get isMale => gender?.toUpperCase() == "MALE";
}

class APPPermission {
  int? id;
  int? pos;
  int? bankTransfer;
  int? bills;
  int? mobileData;
  int? airtime;
  int? insurance;
  int? education;
  int? power;
  int? exchange;
  int? ticket;

  APPPermission(
      {id,
      pos,
      bankTransfer,
      bills,
      mobileData,
      airtime,
      insurance,
      education,
      power,
      exchange,
      ticket});

  APPPermission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pos = json['pos'];
    bankTransfer = json['bank_transfer'];
    bills = json['bills'];
    mobileData = json['data'];
    airtime = json['airtime'];
    insurance = json['insurance'];
    education = json['education'];
    power = json['power'];
    exchange = json['exchange'];
    ticket = json['ticket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pos'] = pos;
    data['bank_transfer'] = bankTransfer;
    data['bills'] = bills;
    data['data'] = mobileData;
    data['airtime'] = airtime;
    data['insurance'] = insurance;
    data['education'] = education;
    data['power'] = power;
    data['exchange'] = exchange;
    data['ticket'] = ticket;
    return data;
  }
}

class AppSettings {
  String? googleUrl;
  String? iosUrl;
  String? version;

  AppSettings({this.googleUrl, this.iosUrl, this.version});

  AppSettings.fromJson(Map<String, dynamic> json) {
    googleUrl = json['google_url'];
    iosUrl = json['ios_url'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['google_url'] = googleUrl;
    data['ios_url'] = iosUrl;
    data['version'] = version;
    return data;
  }
}
