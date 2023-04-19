import 'dart:io';

import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../repository/setting_repository.dart';
import '../request.dart';

class AccountVerificationController with ChangeNotifier {
  String? setVerificationValue;
  PageState pageState = PageState.loaded;
  VerificationType? verificationType;
  VerificationView? _view;
  IdentityView? _identityView;
  File? billImage, govIDCard, yourImage;
  setView(v) {
    _view = v;
  }

  setIdentityView(v) {
    _identityView = v;
  }

  setVerificationType(v) {
    verificationType = v;
  }

  setUtilityBill() async {
    billImage = await imagePicker();
    notifyListeners();
  }

  setGovIDCard() async {
    govIDCard = await imagePicker();
    notifyListeners();
  }

  setYourImage() async {
    yourImage = await imagePicker();
    notifyListeners();
  }

  uploadImages() {
    if (billImage == null || govIDCard == null || yourImage == null) {
      _identityView
          ?.onError("Please provide all doc required for the process..");
      return;
    }
    List<FileKeyValue>? uploadFile = [];
    uploadFile.add(FileKeyValue("utility_bill", billImage));
    uploadFile.add(FileKeyValue("identification_image", govIDCard));
    uploadFile.add(FileKeyValue("selfie", yourImage));
    pageState = PageState.loading;
    notifyListeners();
    SettingRepository().uploadIdentity(uploadFile).then((value) {
      if (value.status == true) {
        _identityView?.onSuccess(value.message ?? "");
      } else {
        _identityView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      _identityView?.onError(onError.toString() ?? "");
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  onSummit() {
    if (isEmpty(setVerificationValue)) {
      _view?.onError("Please provide a valid data");
    } else {
      _view?.onFormVerify();
    }
  }

  verifyData() {
    Map data = {};

    data["identity_type"] = "bvn";
    data["identity_number"] = setVerificationValue;

    pageState = PageState.loading;
    notifyListeners();
    SettingRepository().bvnAndNINVerification(data).then((value) {
      if (value.status == true) {
        _view?.onSuccess(value.message ?? "");
      } else {
        _view?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      _view?.onError(onError.toString() ?? "");
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  Future<File?> imagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image?.path == null) {
      return null;
    }
    return compressImage(File(image!.path));
  }

  Future<File> compressImage(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 60,
    );
    if (result != null) {
      var compressedFile = await file.writeAsBytes(result);
      return compressedFile;
    } else {
      return file;
    }
  }

  clearImage() {
    yourImage = null;
    govIDCard = null;
    billImage = null;
  }

  clear() {
    setVerificationValue = null;
    verificationType = null;
  }
}

abstract class VerificationView {
  onFormVerify();
  onSuccess(String message);
  onError(String message);
}

abstract class IdentityView {
  onSuccess(String message);
  onError(String message);
}

enum VerificationType { bvn, nin }
