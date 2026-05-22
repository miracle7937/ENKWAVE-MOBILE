import 'dart:io';

/// User-facing message for HTTP / socket failures.
String apiErrorMessage(Object error) {
  if (error is SocketException) {
    return 'Cannot reach the server. Check your internet connection and try again.';
  }
  if (error is HttpException) {
    return 'Server error. Please try again in a moment.';
  }
  if (error is FormatException) {
    return 'Invalid response from server. Contact support if this continues.';
  }

  var text = error.toString();
  if (text.startsWith('Exception: ')) {
    text = text.substring(11);
  }

  final lower = text.toLowerCase();
  if (lower.contains('connection refused') ||
      lower.contains('failed host lookup') ||
      lower.contains('network is unreachable') ||
      lower.contains('connection timed out') ||
      lower.contains('software caused connection abort')) {
    return 'Cannot reach the server. Check your internet connection and try again.';
  }

  return text;
}
