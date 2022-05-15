bool validateMobile(String value) {
  String pattern = value.contains("+")
      ? r'(^(?:[+0]234)?[0-9]{10}$)'
      : r'(^(?:[+0]234)?[0-9]{11}$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

////
