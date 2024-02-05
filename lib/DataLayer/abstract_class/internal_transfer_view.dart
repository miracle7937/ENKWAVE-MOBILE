abstract class InternalTransferView {
  onSuccess(String message);
  onError(String message);
  onPinVerification();
  onPreview();
  onTransfer();
  onFailNumberVerify(String message);
}

abstract class APIServiceView {
  onSuccess(String message);
  onError(String message);
  onPinVerification();
  onPreview();
  onTransfer();
  onFailNumberVerify(String message);
}
