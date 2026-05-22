/// Returns [true] if [s] is a not null or empty string.
bool isNotEmpty(String? s) => s != null && s.isNotEmpty && s != 'null';
bool isEmpty(String? s) => s == null || s == 'null' || s.trim().isEmpty;
