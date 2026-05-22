import 'package:enk_pay_project/DataLayer/utils/amount_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formats integer naira amounts with thousands separators as the user types.
class NairaAmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = parseAmountDigits(newValue.text);
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final n = int.tryParse(digits);
    if (n == null) return oldValue;

    final formatted = NumberFormat('#,###', 'en_US').format(n);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
