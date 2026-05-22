class DisputeMessageItem {
  int? id;
  String? authorRole;
  String? authorName;
  String? body;
  String? createdAt;

  DisputeMessageItem({
    this.id,
    this.authorRole,
    this.authorName,
    this.body,
    this.createdAt,
  });

  factory DisputeMessageItem.fromJson(Map<String, dynamic> json) {
    return DisputeMessageItem(
      id: DisputeItem._toInt(json['id']),
      authorRole: json['author_role']?.toString(),
      authorName: json['author_name']?.toString(),
      body: json['body']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  bool get isFromCustomer =>
      (authorRole ?? '').toLowerCase() == 'customer';
}

class DisputeItem {
  int? id;
  int? transactionId;
  String? reference;
  num? amount;
  String? reason;
  String? status;
  String? openedAt;
  String? resolvedAt;
  String? notes;
  String? rrn;
  String? terminalSerial;
  bool canReply;
  List<DisputeMessageItem> messages;

  DisputeItem({
    this.id,
    this.transactionId,
    this.reference,
    this.amount,
    this.reason,
    this.status,
    this.openedAt,
    this.resolvedAt,
    this.notes,
    this.rrn,
    this.terminalSerial,
    this.canReply = true,
    this.messages = const [],
  });

  factory DisputeItem.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];
    final messages = <DisputeMessageItem>[];
    if (rawMessages is List) {
      for (final item in rawMessages) {
        if (item is Map<String, dynamic>) {
          messages.add(DisputeMessageItem.fromJson(item));
        } else if (item is Map) {
          messages.add(
            DisputeMessageItem.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return DisputeItem(
      id: _toInt(json['id']),
      transactionId: _toInt(json['transaction_id']),
      reference: json['reference']?.toString(),
      amount: json['amount'] is num
          ? json['amount']
          : num.tryParse(json['amount']?.toString() ?? ''),
      reason: json['reason']?.toString(),
      status: json['status']?.toString(),
      openedAt: json['opened_at']?.toString(),
      resolvedAt: json['resolved_at']?.toString(),
      notes: json['notes']?.toString(),
      rrn: json['rrn']?.toString(),
      terminalSerial: json['terminal_serial']?.toString(),
      canReply: json['can_reply'] == true ||
          json['can_reply']?.toString() == 'true' ||
          json['can_reply'] == null,
      messages: messages,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class DisputeDetailResponse {
  bool status;
  DisputeItem? dispute;
  String? message;

  DisputeDetailResponse({
    required this.status,
    this.dispute,
    this.message,
  });

  factory DisputeDetailResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    DisputeItem? dispute;
    if (data is Map<String, dynamic>) {
      dispute = DisputeItem.fromJson(data);
    } else if (data is Map) {
      dispute = DisputeItem.fromJson(Map<String, dynamic>.from(data));
    }

    return DisputeDetailResponse(
      status: json['status'] == true || json['status'].toString() == 'true',
      dispute: dispute,
      message: json['message']?.toString(),
    );
  }
}

class DisputesListResponse {
  bool status;
  List<DisputeItem> disputes;
  String? message;

  DisputesListResponse({
    required this.status,
    required this.disputes,
    this.message,
  });

  factory DisputesListResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = <DisputeItem>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          list.add(DisputeItem.fromJson(item));
        } else if (item is Map) {
          list.add(DisputeItem.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return DisputesListResponse(
      status: json['status'] == true || json['status'].toString() == 'true',
      disputes: list,
      message: json['message']?.toString(),
    );
  }
}
