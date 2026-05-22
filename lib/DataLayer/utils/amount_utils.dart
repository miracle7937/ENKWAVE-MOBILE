/// Strips display formatting so APIs receive plain digits.
String parseAmountDigits(String? value) {
  if (value == null || value.trim().isEmpty) return '';
  return value.replaceAll(RegExp(r'[^\d]'), '');
}
