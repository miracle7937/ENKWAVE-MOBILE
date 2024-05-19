enum TransactionEnum { ALL, BILLS, TRANSFEROUT, TRANSFERIN, REVERSED, POS }

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
  if (transactionType == TransactionEnum.ALL.name) {
    value = TransactionEnum.ALL;
  } else if (transactionType == TransactionEnum.BILLS.name) {
    value = TransactionEnum.BILLS;
  } else if (transactionType == TransactionEnum.TRANSFEROUT.name) {
    value = TransactionEnum.TRANSFEROUT;
  } else if (transactionType == TransactionEnum.TRANSFERIN.name) {
    value = TransactionEnum.TRANSFERIN;
  } else if (transactionType == TransactionEnum.REVERSED.name) {
    value = TransactionEnum.REVERSED;
  } else if (transactionType == TransactionEnum.POS.name) {
    value = TransactionEnum.POS;
  } else {
    value = TransactionEnum.ALL;
  }
  return value;
}

String getEnumName(TransactionEnum transactionType) {
  String? value;
  switch (transactionType) {
    case TransactionEnum.POS:
      value = "POS";
      break;
    case TransactionEnum.BILLS:
      value = "BILLS";
      break;
    case TransactionEnum.TRANSFEROUT:
      value = "TRANSFER OUT";
      break;
    case TransactionEnum.TRANSFERIN:
      value = "TRANSFER IN";
      break;
    case TransactionEnum.REVERSED:
      value = "REVERSED";
      break;
    default:
      value = "Transaction";
  }

  return value;
}
