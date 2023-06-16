class CardDetailsResponse {
  bool? status;
  String? creationCharge;
  String? rate;
  String? wRate;
  List<CardTransaction>? cardTransaction;
  List<CardDetails>? cardDetails;

  CardDetailsResponse(
      {this.status,
      this.creationCharge,
      this.rate,
      this.wRate,
      this.cardTransaction,
      this.cardDetails});

  CardDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    creationCharge = json['creation_charge'];
    rate = json['rate'];
    wRate = json['w_rate'];
    if (json['card_transaction'] != null) {
      cardTransaction = <CardTransaction>[];
      json['card_transaction'].forEach((v) {
        cardTransaction!.add(CardTransaction.fromJson(v));
      });
    }
    if (json['card_details'] != null) {
      cardDetails = <CardDetails>[];
      json['card_details'].forEach((v) {
        cardDetails!.add(CardDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['creation_charge'] = creationCharge;
    data['rate'] = rate;
    data['w_rate'] = wRate;
    if (cardTransaction != null) {
      data['card_transaction'] =
          cardTransaction!.map((v) => v.toJson()).toList();
    }
    if (cardDetails != null) {
      data['card_details'] = cardDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CardTransaction {
  String? amount;
  String? bridgecardTransactionReference;
  String? cardId;
  String? cardTransactionType;
  String? cardholderId;
  String? clientTransactionReference;
  String? currency;
  String? description;
  String? issuingAppId;
  bool? livemode;
  String? transactionDate;
  int? transactionTimestamp;

  CardTransaction(
      {this.amount,
      this.bridgecardTransactionReference,
      this.cardId,
      this.cardTransactionType,
      this.cardholderId,
      this.clientTransactionReference,
      this.currency,
      this.description,
      this.issuingAppId,
      this.livemode,
      this.transactionDate,
      this.transactionTimestamp});

  CardTransaction.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    bridgecardTransactionReference = json['bridgecard_transaction_reference'];
    cardId = json['card_id'];
    cardTransactionType = json['card_transaction_type'];
    cardholderId = json['cardholder_id'];
    clientTransactionReference = json['client_transaction_reference'];
    currency = json['currency'];
    description = json['description'];
    issuingAppId = json['issuing_app_id'];
    livemode = json['livemode'];
    transactionDate = json['transaction_date'];
    transactionTimestamp = json['transaction_timestamp'];
  }

  isDebit() => "Debit".toLowerCase() == cardTransactionType?.toLowerCase();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amount'] = amount;
    data['bridgecard_transaction_reference'] = bridgecardTransactionReference;
    data['card_id'] = cardId;
    data['card_transaction_type'] = cardTransactionType;
    data['cardholder_id'] = cardholderId;
    data['client_transaction_reference'] = clientTransactionReference;
    data['currency'] = currency;
    data['description'] = description;
    data['issuing_app_id'] = issuingAppId;
    data['livemode'] = livemode;
    data['transaction_date'] = transactionDate;
    data['transaction_timestamp'] = transactionTimestamp;
    return data;
  }
}

class CardDetails {
  String? cardNumber;
  String? cvv;
  String? expiration;
  String? cardType;
  String? nameOnCard;
  String? amount;
  String? city;
  String? state;
  String? address;
  String? zipCode;

  CardDetails(
      {this.cardNumber,
      this.cvv,
      this.expiration,
      this.cardType,
      this.nameOnCard,
      this.amount,
      this.city,
      this.state,
      this.address,
      this.zipCode});

  CardDetails.fromJson(Map<String, dynamic> json) {
    cardNumber = json['card_number'];
    cvv = json['cvv'];
    expiration = json['expiration'];
    cardType = json['card_type'];
    nameOnCard = json['name_on_card'];
    amount = json['amount'];
    city = json['city'];
    state = json['state'];
    address = json['address'];
    zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['card_number'] = cardNumber;
    data['cvv'] = cvv;
    data['expiration'] = expiration;
    data['card_type'] = cardType;
    data['name_on_card'] = nameOnCard;
    data['amount'] = amount;
    data['city'] = city;
    data['state'] = state;
    data['address'] = address;
    data['zip_code'] = zipCode;
    return data;
  }
}
