import 'dart:io';

import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../UILayer/utils/image_helper.dart';
import '../LocalData/local_data_storage.dart';
import '../model/card_details_model.dart';
import '../repository/vcard_repository.dart';
import '../request.dart';

class VCardController extends ChangeNotifier {
  OnVCardVerification? _onVCardVerification;
  OnGetVCardDetails? _onGetVCardDetails;
  OnCreateVCard? _onCreateVCard;
  OnVCardView? _onVCardView;
  PageState pageState = PageState.loaded;
  CardDetailsResponse? cardDetailsResponse;
  File? userImage;
  String? fundAmount;
  String? liquidateAmount;

  setCardVerifyView(v) {
    _onVCardVerification = v;
  }

  setGetCardView(v) {
    _onGetVCardDetails = v;
  }

  setCreateVCardView(v) {
    _onCreateVCard = v;
  }

  setVCardView(v) {
    _onVCardView = v;
  }

  setFundAmount(String amount) {
    if (isEmpty(amount)) {
      fundAmount = "0";
    } else {
      fundAmount =
          (num.parse(amount) * num.parse(cardDetailsResponse?.rate ?? "0"))
              .toString();
    }

    notifyListeners();
  }

  setLiquidateAmount(String amount) {
    if (isEmpty(amount)) {
      liquidateAmount = "0";
    } else {
      liquidateAmount =
          (num.parse(amount) * num.parse(cardDetailsResponse?.wRate ?? "0"))
              .toString();
    }

    notifyListeners();
  }

  clearAmount() {
    fundAmount = null;
    liquidateAmount = null;
  }

  Future<bool> canUserCreateCard() async {
    UserData? userData = await LocalDataStorage.getUserData();
    return isNotEmpty(userData?.cardHolderId);
  }

  String creationFeeNaira() {
    num rate = num.parse(cardDetailsResponse?.creationCharge ?? "0") *
        num.parse(cardDetailsResponse?.rate ?? "0");
    return rate.toString();
  }

  verifyImage() {
    if (userImage == null) {
      _onVCardVerification?.onError("please, provide your image");
      return;
    }
    pageState = PageState.loading;
    notifyListeners();
    List<FileKeyValue>? uploadFile = [];
    uploadFile.add(FileKeyValue("photo", userImage));

    VCardRepository.verifyImage(uploadFile).then((value) {
      if (value.status == true) {
        _onVCardVerification?.onSuccess(value.message ?? "");
      } else {
        _onVCardVerification?.onError(value.message ?? "");
      }
      userImage = null;

      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((error) {
      userImage = null;

      pageState = PageState.loaded;
      notifyListeners();
      _onVCardVerification?.onError(error.toString());
    });
  }

  getCardDetails() {
    pageState = PageState.loading;
    VCardRepository.getCardsDetail().then((value) {
      cardDetailsResponse = value;
      if (value.status == true) {
        navigateLogic(value.cardDetails!);
      } else {
        _onGetVCardDetails?.onError("");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stackTrace) {
      pageState = PageState.loaded;
      _onGetVCardDetails?.onError(error.toString());
    });
  }

  refreshCard() {
    pageState = PageState.loading;
    notifyListeners();
    VCardRepository.getCardsDetail().then((value) {
      if (value.status == true) {
        cardDetailsResponse = value;
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stackTrace) {
      pageState = PageState.loaded;
      _onVCardView?.onError(error.toString());
    });
  }

  navigateLogic(List value) {
    if (value.isEmpty) {
      // no card yet
      _onGetVCardDetails?.noCard("");
    } else {
      _onGetVCardDetails?.onSuccess("");
    }
  }

  createCard() {
    pageState = PageState.loading;
    notifyListeners();
    VCardRepository.createVCard().then((value) {
      if (value.status == true) {
        _onCreateVCard?.onSuccess(value.message ?? "");
      } else {
        _onCreateVCard?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stackTrace) {
      pageState = PageState.loaded;
      notifyListeners();
      _onCreateVCard?.onError(error.toString());
    });
  }

  fundVCard() {
    Map map = {};
    map["amount"] = fundAmount;
    if (isEmpty(fundAmount)) {
      return;
    }
    pageState = PageState.loading;
    notifyListeners();

    VCardRepository.fundCard(map).then((value) {
      if (value.status == true) {
        _onVCardView?.onSuccess(value.message ?? "");
      } else {
        _onVCardView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stackTrace) {
      pageState = PageState.loaded;
      _onVCardView?.onError(error.toString());
    });
  }

  blockWallet() {
    pageState = PageState.loading;
    notifyListeners();
    Map map = {};
    VCardRepository.blockCard(map).then((value) {
      if (value.status == true) {
        _onVCardView?.onSuccess(value.message ?? "");
      } else {
        _onVCardView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stackTrace) {
      pageState = PageState.loaded;
      _onVCardView?.onError(error.toString());
    });
  }

  unblockWallet() {
    pageState = PageState.loading;
    notifyListeners();
    Map map = {};

    VCardRepository.unBlockCard(map).then((value) {
      if (value.status == true) {
        _onVCardView?.onSuccess(value.message ?? "");
      } else {
        _onVCardView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stackTrace) {
      pageState = PageState.loaded;
      _onVCardView?.onError(error.toString());
    });
  }

  liquidateWallet() {
    Map map = {};
    map["amount"] = liquidateAmount;
    if (isEmpty(liquidateAmount)) {
      return;
    }
    pageState = PageState.loading;
    notifyListeners();

    VCardRepository.liquidateCard(map).then((value) {
      if (value.status == true) {
        _onVCardView?.onSuccess(value.message ?? "");
      } else {
        _onVCardView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).onError((error, stackTrace) {
      pageState = PageState.loaded;
      _onVCardView?.onError(error.toString());
    });
  }

  setImageCard() async {
    userImage = await imagePicker();
    notifyListeners();
  }

  Future<File?> imagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    if (image?.path == null) {
      return null;
    }
    return Platform.isAndroid
        ? ImageHelper.compressImage(File(image!.path))
        : Future.value(File(image!.path));
  }
}

abstract class OnVCardVerification {
  onSuccess(String message);
  onError(String message);
}

abstract class OnGetVCardDetails {
  onSuccess(String message);
  noCard(String message);
  onError(String message);
}

abstract class OnCreateVCard {
  onSuccess(String message);
  onError(String message);
}

abstract class OnVCardView {
  onSuccess(String message);
  onError(String message);
}
