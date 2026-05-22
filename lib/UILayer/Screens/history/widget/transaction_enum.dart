enum TransactionEnum {
  all,
  billsPayment,
  bankTransfer,
  enkPayTransfer,
  selfCashOutTransfer,
  virtualFundWallet,
  cashOut,
}

// POS Transaction - CashOut
// Inapp transfer
// Virtual account cash in - VirtualFundWallet
// Bank Transfer - BankTransfer
// Cable - VasCable
// Eletriccity - VasEletric
// Data - VasData
// Airtime - VasAirtime
// Education - VasEducation
// Insurance - VasEducation
// Terminal Vas Transaction - VasfromTerminal

String _normalizeTransactionTypeKey(String transactionType) {
  return transactionType.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}

TransactionEnum getTransactionEnum(String transactionType) {
  TransactionEnum? value;
  final key = _normalizeTransactionTypeKey(transactionType);
  if (transactionType.toLowerCase() ==
      TransactionEnum.selfCashOutTransfer.name.toLowerCase()) {
    value = TransactionEnum.selfCashOutTransfer;
  } else if (key == 'enkpaytransfer' ||
      key == 'inapptransfer' ||
      key == TransactionEnum.enkPayTransfer.name.toLowerCase()) {
    value = TransactionEnum.enkPayTransfer;
  } else if (transactionType.toLowerCase() ==
      TransactionEnum.cashOut.name.toLowerCase()) {
    value = TransactionEnum.cashOut;
  } else if (transactionType.toLowerCase() ==
      TransactionEnum.bankTransfer.name.toLowerCase()) {
    value = TransactionEnum.bankTransfer;
  } else if (transactionType.toLowerCase() ==
      TransactionEnum.billsPayment.name.toLowerCase()) {
    value = TransactionEnum.billsPayment;
  } else if (transactionType.toLowerCase() ==
      TransactionEnum.virtualFundWallet.name.toLowerCase()) {
    value = TransactionEnum.virtualFundWallet;
  } else {
    value = TransactionEnum.all;
  }
  return value;
}

String getEnumName(TransactionEnum transactionType) {
  String? value;
  switch (transactionType) {
    case TransactionEnum.cashOut:
      value = "POS TRANSACTION";
      break;
    case TransactionEnum.billsPayment:
      value = "BILLS";
      break;
    case TransactionEnum.virtualFundWallet:
      value = "FUND WALLET";
      break;
    case TransactionEnum.selfCashOutTransfer:
      value = "CASH OUT";
      break;
    case TransactionEnum.enkPayTransfer:
      value = "INAPP TRANSFER";
      break;

    case TransactionEnum.bankTransfer:
      value = "BANK TRANSFER";
      break;

    default:
      value = "ALL";
  }

  return value;
}

/// Maps legacy API titles (e.g. Enkpay Transfer) to the current label.
String formatTransactionTitle(String? title) {
  if (title == null || title.trim().isEmpty) return '';
  final key = _normalizeTransactionTypeKey(title);
  if (key == 'enkpaytransfer' || key == 'inapptransfer') {
    return 'Inapp Transfer';
  }
  return title;
}
