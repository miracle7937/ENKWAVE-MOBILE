/// Default HTTP timeouts for mobile API calls.
class ApiTimeouts {
  static const Duration standard = Duration(seconds: 45);
  static const Duration bankOperation = Duration(seconds: 60);
}
