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
// Inapp transfer - EnkPayTransfer
// Virtual account cash in - VirtualFundWallet
// Bank Transfer - BankTransfer
// Cable - VasCable
// Eletriccity - VasEletric
// Data - VasData
// Airtime - VasAirtime
// Education - VasEducation
// Insurance - VasEducation
// Terminal Vas Transaction - VasfromTerminal

TransactionEnum getTransactionEnum(String transactionType) {
  TransactionEnum? value;
  if (transactionType.toLowerCase() ==
      TransactionEnum.selfCashOutTransfer.name.toLowerCase()) {
    value = TransactionEnum.selfCashOutTransfer;
  } else if (transactionType.toLowerCase() ==
      TransactionEnum.enkPayTransfer.name.toLowerCase()) {
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
      value = "ENKPAY TRANSFER";
      break;

    case TransactionEnum.bankTransfer:
      value = "BANK TRANSFER";
      break;

    default:
      value = "ALL";
  }

  return value;
}
