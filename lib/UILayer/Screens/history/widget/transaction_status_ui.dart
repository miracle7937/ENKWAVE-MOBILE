import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

class TransactionStatusUi {
  static String label(num? status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Successful';
      case 3:
        return 'Reversed';
      default:
        return 'Failed';
    }
  }

  static Color color(num? status) {
    switch (status) {
      case 0:
        return EPColors.appWarning;
      case 1:
        return EPColors.appSuccess;
      case 3:
        return EPColors.appWarning;
      default:
        return EPColors.appDanger;
    }
  }

  static IconData icon(num? status) {
    switch (status) {
      case 0:
        return Icons.schedule_rounded;
      case 1:
        return Icons.check_circle_rounded;
      case 3:
        return Icons.undo_rounded;
      default:
        return Icons.cancel_rounded;
    }
  }
}
