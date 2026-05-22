import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

class DisputeStatusUi {
  static String label(String? status) {
    final key = (status ?? '').toLowerCase().trim();
    switch (key) {
      case 'open':
        return 'Open';
      case 'pending':
        return 'Pending';
      case 'under_review':
      case 'investigating':
        return 'Under review';
      case 'won':
      case 'resolved_won':
      case 'success':
        return 'Resolved — won';
      case 'lost':
      case 'resolved_lost':
      case 'failed':
        return 'Resolved — lost';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      default:
        if (key.isEmpty) return 'Unknown';
        return key.replaceAll('_', ' ');
    }
  }

  static Color color(String? status) {
    final key = (status ?? '').toLowerCase().trim();
    if (['won', 'resolved_won', 'success', 'resolved'].contains(key)) {
      return EPColors.appSuccess;
    }
    if (['lost', 'resolved_lost', 'failed'].contains(key)) {
      return EPColors.appDanger;
    }
    if (['open', 'pending', 'under_review', 'investigating', '0'].contains(key)) {
      return EPColors.appWarning;
    }
    return EPColors.appMuted;
  }

  static IconData icon(String? status) {
    final key = (status ?? '').toLowerCase().trim();
    if (['won', 'resolved_won', 'success'].contains(key)) {
      return Icons.check_circle_rounded;
    }
    if (['lost', 'resolved_lost', 'failed'].contains(key)) {
      return Icons.cancel_rounded;
    }
    if (['under_review', 'investigating'].contains(key)) {
      return Icons.manage_search_rounded;
    }
    return Icons.hourglass_top_rounded;
  }

  static bool isOpen(String? status) {
    final key = (status ?? '').toLowerCase().trim();
    return ['open', 'pending', 'under_review', 'investigating', '0', '0'].contains(key);
  }
}
