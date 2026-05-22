enum TransactionType {
  purchase,
  balance$Inquiry,
  reversal,
  refund,
  pre$Auth,
  cash$Advance,
  transaction$Completion,
  cash$Back
}

extension ParseToString on TransactionType {
  String toShortString() {
    return toString().split('.').last.replaceAll("\$", " ");
  }
}
