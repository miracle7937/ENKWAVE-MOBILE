package com.etop_pos_plugin.networking.model;

public class TransactionRequest {
    String Sessionkey;
    String PinBlock;
    String CardData;
    String Amount;
    String Token;
    String MerchantName;
    String MerchantID;
    String MerchantCategoryCode;
    String CSN;
    String ExpiryDate;
    String Track2data;
    String Type;
    String TerminalID;
    String ProcessingCode;
    String ServiceCode;
    String CardPan;
    String AccountType;
    String   ICCData;

    public String getICCData() {
        return ICCData;
    }

    public void setICCData(String ICCData) {
        this.ICCData = ICCData;
    }

    public String getAccountType() {
        return AccountType;
    }

    public void setAccountType(String accountType) {
        AccountType = accountType;
    }

    public TransactionRequest() {
    }

    public String getCardPan() {
        return this.CardPan;
    }

    public void setCardPan(String cardPan) {
        this.CardPan = cardPan;
    }

    public String getServiceCode() {
        return this.ServiceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.ServiceCode = serviceCode;
    }

    public String getProcessingCode() {
        return this.ProcessingCode;
    }

    public void setProcessingCode(String processingCode) {
        this.ProcessingCode = processingCode;
    }

    public String getTerminalID() {
        return this.TerminalID;
    }

    public void setTerminalID(String terminalID) {
        this.TerminalID = terminalID;
    }

    public String getType() {
        return this.Type;
    }

    public void setType(String type) {
        this.Type = type;
    }

    public String getSessionkey() {
        return this.Sessionkey;
    }

    public void setSessionkey(String sessionkey) {
        this.Sessionkey = sessionkey;
    }

    public String getPinBlock() {
        return this.PinBlock;
    }

    public void setPinBlock(String pinBlock) {
        this.PinBlock = pinBlock;
    }

    public String getCardData() {
        return this.CardData;
    }

    public void setCardData(String cardData) {
        this.CardData = cardData;
    }

    public String getAmount() {
        return this.Amount;
    }

    public void setAmount(String amount) {
        this.Amount = amount;
    }

    public String getToken() {
        return this.Token;
    }

    public void setToken(String token) {
        this.Token = token;
    }

    public String getMerchantName() {
        return this.MerchantName;
    }

    public void setMerchantName(String merchantName) {
        this.MerchantName = merchantName;
    }

    public String getMerchantID() {
        return this.MerchantID;
    }

    public void setMerchantID(String merchantID) {
        this.MerchantID = merchantID;
    }

    public String getMerchantCategoryCode() {
        return this.MerchantCategoryCode;
    }

    public void setMerchantCategoryCode(String merchantCategoryCode) {
        this.MerchantCategoryCode = merchantCategoryCode;
    }

    public String getCSN() {
        return this.CSN;
    }

    public void setCSN(String CSN) {
        this.CSN = CSN;
    }

    public String getExpiryDate() {
        return this.ExpiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.ExpiryDate = expiryDate;
    }

    public String getTrack2data() {
        return this.Track2data;
    }

    public void setTrack2data(String track2data) {
        this.Track2data = track2data;
    }

    @Override
    public String toString() {
        return "TransactionRequest{" +
                "Sessionkey='" + Sessionkey + '\'' +
                ", PinBlock='" + PinBlock + '\'' +
                ", CardData='" + CardData + '\'' +
                ", Amount='" + Amount + '\'' +
                ", Token='" + Token + '\'' +
                ", MerchantName='" + MerchantName + '\'' +
                ", MerchantID='" + MerchantID + '\'' +
                ", MerchantCategoryCode='" + MerchantCategoryCode + '\'' +
                ", CSN='" + CSN + '\'' +
                ", ExpiryDate='" + ExpiryDate + '\'' +
                ", Track2data='" + Track2data + '\'' +
                ", Type='" + Type + '\'' +
                ", TerminalID='" + TerminalID + '\'' +
                ", ProcessingCode='" + ProcessingCode + '\'' +
                ", ServiceCode='" + ServiceCode + '\'' +
                ", CardPan='" + CardPan + '\'' +
                ", AccountType='" + AccountType + '\'' +
                ", ICCData='" + ICCData + '\'' +
                '}';
    }
}
