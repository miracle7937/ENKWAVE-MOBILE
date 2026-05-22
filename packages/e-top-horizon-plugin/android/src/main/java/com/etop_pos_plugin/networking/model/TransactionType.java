package com.etop_pos_plugin.networking.model;

public enum TransactionType {
    PURCHASE("Purchase"),
    REVERSAL("Reversal"),
    REFUND("Refund"),
    BALANCE_INQUIRY("Balance Inquiry"),
    PRE_AUTH("Pre-Authorization"),
    PURCHASE_COMPLETION("Purchase Completion"),
    CASH_ADVANCE("Cash Advance"),
    CASH_BACK("Cash Back");

    private final String description;

    TransactionType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    @Override
    public String toString() {
        return description;
    }
}
