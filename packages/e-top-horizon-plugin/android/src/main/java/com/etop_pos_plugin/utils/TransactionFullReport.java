package com.etop_pos_plugin.utils;

import java.util.List;

public class TransactionFullReport {

    private String report_datetime;
    private String merchant_no;
    private String terminal_no;
    private String merchant_name;
    private int total_transaction;
    private int total_success;
    private int total_fail;
    private double total_purchase_amount;
    private List<Transaction> transaction;

    public String getMerchant_no() {
        return merchant_no;
    }

    public String getTerminal_no() {
        return terminal_no;
    }

    public String getMerchant_name() {
        return merchant_name;
    }

    public String getReport_datetime() {
        return report_datetime;
    }

    public int getTotal_transaction() {
        return total_transaction;
    }

    public int getTotal_success() {
        return total_success;
    }

    public int getTotal_fail() {
        return total_fail;
    }

    public double getTotal_purchase_amount() {
        return total_purchase_amount;
    }

    public List<Transaction> getTransaction() {
        return transaction;
    }

    public class Transaction {
        private String transaction_type;
        private String date_time;
        private String status;
        private double amount;
        private String rrn;
        private String card_pan;

        public String getCard_pan() {
            return card_pan;
        }

        public String getTransaction_type() {
            return transaction_type;
        }

        public String getDate_time() {
            return date_time;
        }

        public String getStatus() {
            return status;
        }

        public double getAmount() {
            return amount;
        }

        public String getRrn() {
            return rrn;
        }
        // Add getters and setters for all fields
    }

}
