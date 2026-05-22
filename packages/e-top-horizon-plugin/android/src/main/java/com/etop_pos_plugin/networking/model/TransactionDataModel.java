package com.etop_pos_plugin.networking.model;


public class TransactionDataModel {
    String amount;
    String tid;
    String   accountType;
    String transactionType;
    String systemTraceNO;
    String originalForwardingInstCode;
    String originalTransmissionDatetime;
    String merchantName;
    String merchantLogo;
    int numberOfReceipt;

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getTid() {
        return tid;
    }

    public void setTid(String tid) {
        this.tid = tid;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public String getSystemTraceNO() {
        return systemTraceNO;
    }

    public void setSystemTraceNO(String systemTraceNO) {
        this.systemTraceNO = systemTraceNO;
    }

    public String getOriginalForwardingInstCode() {
        return originalForwardingInstCode;
    }

    public void setOriginalForwardingInstCode(String originalForwardingInstCode) {
        this.originalForwardingInstCode = originalForwardingInstCode;
    }

    public String getOriginalTransmissionDatetime() {
        return originalTransmissionDatetime;
    }

    public void setOriginalTransmissionDatetime(String originalTransmissionDatetime) {
        this.originalTransmissionDatetime = originalTransmissionDatetime;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }

    public String getMerchantLogo() {
        return merchantLogo;
    }

    public void setMerchantLogo(String merchantLogo) {
        this.merchantLogo = merchantLogo;
    }
}