package com.etop_pos_plugin.networking.model;


import com.etop_pos_plugin.utils.CustomerData;
import com.etop_pos_plugin.utils.DeviceUtil;
import com.google.gson.annotations.SerializedName;

public class TransactionResponseModel {

    @SerializedName("status")
    boolean status;

    @SerializedName("successResponse")
    String successResponse;

    @SerializedName("systemTraceAuditNo")
    String systemTraceAuditNo;


    @SerializedName("acquiringInstitutionIdCode")
    String acquiringInstitutionIdCode;

    @SerializedName("forwardingInstCode")
    String forwardingInstCode;

    @SerializedName("receiptNumber")
    String receiptNumber;

    @SerializedName("authCode")
    String authCode;

    @SerializedName("respCode")
    String respCode;

    @SerializedName("rDate")
    String rDate;

    @SerializedName("responseMessage")
    String responseMessage;

    @SerializedName("transactionTime")
    String transactionTime;

    @SerializedName("terminalId")
    String terminalId;

    @SerializedName("transactionDate")
    String transactionDate;

    @SerializedName("transactionDateTime")
    String transactionDateTime;

    @SerializedName("userID")
    String userID;

    @SerializedName("amount")
    String amount;

    @SerializedName("transactionType")
    TransactionType transactionType = TransactionType.PURCHASE;

    @SerializedName("aid")
    String aid;

    @SerializedName("mid")
    String mid;

    @SerializedName("mcc")
    String mcc;

    @SerializedName("mnl")
    String mnl;

    @SerializedName("encryptedSessionKey")
    private String encryptedSessionKey;

    @SerializedName("clearSessionKey")
    private String clearSessionKey;

    @SerializedName("encryptedPinKey")
    private String encryptedPinKey;

    @SerializedName("clearPinKey")
    private String clearPinKey;

    @SerializedName("encryptedMasterKey")
    private String encryptedMasterKey;

    @SerializedName("clearMasterKey")
    private String clearMasterKey;

    @SerializedName("countryCode")
    private String countryCode;

    @SerializedName("currencyCode")
    private String currencyCode;

    @SerializedName("icData")
    private String icData;

    @SerializedName("pan")
    private String pan;

    @SerializedName("accountType")
    private String accountType;

    @SerializedName("cardExpireData")
    private String cardExpireData;

    @SerializedName("cardCardSequenceNum")
    private String cardCardSequenceNum;

    @SerializedName("track2Data")
    private String track2Data;

    @SerializedName("pinBlock")
    private String pinBlock;

    @SerializedName("RRN")
    private String RRN;

    @SerializedName("STAN")
    private String STAN;

    @SerializedName("cardHolderName")
    private String cardHolderName;

    @SerializedName("onlineCard")
    private String onlineCard;

    @SerializedName("serialNO")
    String serialNO;

    public String getAccountBalance() {
        return accountBalance;
    }

    public void setAccountBalance(String accountBalance) {
        this.accountBalance = accountBalance;
    }

    @SerializedName("AccountBalance")
    String accountBalance;


    @Override
    public String toString() {
        return "TransactionResponseModel{" +
                "status=" + status +
                ", successResponse='" + successResponse + '\'' +
                ", systemTraceAuditNo='" + systemTraceAuditNo + '\'' +
                ", acquiringInstitutionIdCode='" + acquiringInstitutionIdCode + '\'' +
                ", forwardingInstCode='" + forwardingInstCode + '\'' +
                ", receiptNumber='" + receiptNumber + '\'' +
                ", authCode='" + authCode + '\'' +
                ", respCode='" + respCode + '\'' +
                ", rDate='" + rDate + '\'' +
                ", responseMessage='" + responseMessage + '\'' +
                ", transactionTime='" + transactionTime + '\'' +
                ", terminalId='" + terminalId + '\'' +
                ", transactionDate='" + transactionDate + '\'' +
                ", transactionDateTime='" + transactionDateTime + '\'' +
                ", userID='" + userID + '\'' +
                ", amount='" + amount + '\'' +
                ", transactionType=" + transactionType +
                ", aid='" + aid + '\'' +
                ", mid='" + mid + '\'' +
                ", mcc='" + mcc + '\'' +
                ", mnl='" + mnl + '\'' +
                ", encryptedSessionKey='" + encryptedSessionKey + '\'' +
                ", clearSessionKey='" + clearSessionKey + '\'' +
                ", encryptedPinKey='" + encryptedPinKey + '\'' +
                ", clearPinKey='" + clearPinKey + '\'' +
                ", encryptedMasterKey='" + encryptedMasterKey + '\'' +
                ", clearMasterKey='" + clearMasterKey + '\'' +
                ", countryCode='" + countryCode + '\'' +
                ", currencyCode='" + currencyCode + '\'' +
                ", icData='" + icData + '\'' +
                ", pan='" + pan + '\'' +
                ", accountType='" + accountType + '\'' +
                ", cardExpireData='" + cardExpireData + '\'' +
                ", cardCardSequenceNum='" + cardCardSequenceNum + '\'' +
                ", track2Data='" + track2Data + '\'' +
                ", pinBlock='" + pinBlock + '\'' +
                ", RRN='" + RRN + '\'' +
                ", STAN='" + STAN + '\'' +
                ", cardHolderName='" + cardHolderName + '\'' +
                ", onlineCard='" + onlineCard + '\'' +
                ", serialNO='" + serialNO + '\'' +
                '}';
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getSuccessResponse() {
        return successResponse;
    }

    public void setSuccessResponse(String successResponse) {
        this.successResponse = successResponse;
    }

    public String getSystemTraceAuditNo() {
        return systemTraceAuditNo;
    }

    public void setSystemTraceAuditNo(String systemTraceAuditNo) {
        this.systemTraceAuditNo = systemTraceAuditNo;
    }

    public String getAcquiringInstitutionIdCode() {
        return acquiringInstitutionIdCode;
    }

    public void setAcquiringInstitutionIdCode(String acquiringInstitutionIdCode) {
        this.acquiringInstitutionIdCode = acquiringInstitutionIdCode;
    }

    public String getForwardingInstCode() {
        return forwardingInstCode;
    }

    public void setForwardingInstCode(String forwardingInstCode) {
        this.forwardingInstCode = forwardingInstCode;
    }

    public String getReceiptNumber() {
        return receiptNumber;
    }

    public void setReceiptNumber(String receiptNumber) {
        this.receiptNumber = receiptNumber;
    }

    public String getAuthCode() {
        return authCode;
    }

    public void setAuthCode(String authCode) {
        this.authCode = authCode;
    }

    public String getRespCode() {
        return respCode;
    }

    public void setRespCode(String respCode) {
        this.respCode = respCode;
    }

    public String getrDate() {
        return rDate;
    }

    public void setrDate(String rDate) {
        this.rDate = rDate;
    }

    public String getResponseMessage() {
        return responseMessage;
    }

    public void setResponseMessage(String responseMessage) {
        this.responseMessage = responseMessage;
    }

    public String getTransactionTime() {
        return transactionTime;
    }

    public void setTransactionTime(String transactionTime) {
        this.transactionTime = transactionTime;
    }

    public String getTerminalId() {
        return terminalId;
    }

    public void setTerminalId(String terminalId) {
        this.terminalId = terminalId;
    }

    public String getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(String transactionDate) {
        this.transactionDate = transactionDate;
    }

    public String getTransactionDateTime() {
        return transactionDateTime;
    }

    public void setTransactionDateTime(String transactionDateTime) {
        this.transactionDateTime = transactionDateTime;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public TransactionType getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(TransactionType transactionType) {
        this.transactionType = transactionType;
    }

    public String getAid() {
        return aid;
    }

    public void setAid(String aid) {
        this.aid = aid;
    }

    public String getMid() {
        return mid;
    }

    public void setMid(String mid) {
        this.mid = mid;
    }

    public String getMcc() {
        return mcc;
    }

    public void setMcc(String mcc) {
        this.mcc = mcc;
    }

    public String getMnl() {
        return mnl;
    }

    public void setMnl(String mnl) {
        this.mnl = mnl;
    }

    public String getEncryptedSessionKey() {
        return encryptedSessionKey;
    }

    public void setEncryptedSessionKey(String encryptedSessionKey) {
        this.encryptedSessionKey = encryptedSessionKey;
    }

    public String getClearSessionKey() {
        return clearSessionKey;
    }

    public void setClearSessionKey(String clearSessionKey) {
        this.clearSessionKey = clearSessionKey;
    }

    public String getEncryptedPinKey() {
        return encryptedPinKey;
    }

    public void setEncryptedPinKey(String encryptedPinKey) {
        this.encryptedPinKey = encryptedPinKey;
    }

    public String getClearPinKey() {
        return clearPinKey;
    }

    public void setClearPinKey(String clearPinKey) {
        this.clearPinKey = clearPinKey;
    }

    public String getEncryptedMasterKey() {
        return encryptedMasterKey;
    }

    public void setEncryptedMasterKey(String encryptedMasterKey) {
        this.encryptedMasterKey = encryptedMasterKey;
    }

    public String getClearMasterKey() {
        return clearMasterKey;
    }

    public void setClearMasterKey(String clearMasterKey) {
        this.clearMasterKey = clearMasterKey;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getCurrencyCode() {
        return currencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }

    public String getIcData() {
        return icData;
    }

    public void setIcData(String icData) {
        this.icData = icData;
    }

    public String getPan() {
        return pan;
    }

    public void setPan(String pan) {
        this.pan = pan;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public String getCardExpireData() {
        return cardExpireData;
    }

    public void setCardExpireData(String cardExpireData) {
        this.cardExpireData = cardExpireData;
    }

    public String getCardCardSequenceNum() {
        return cardCardSequenceNum;
    }

    public void setCardCardSequenceNum(String cardCardSequenceNum) {
        this.cardCardSequenceNum = cardCardSequenceNum;
    }

    public String getTrack2Data() {
        return track2Data;
    }

    public void setTrack2Data(String track2Data) {
        this.track2Data = track2Data;
    }

    public String getPinBlock() {
        return pinBlock;
    }

    public void setPinBlock(String pinBlock) {
        this.pinBlock = pinBlock;
    }

    public String getRRN() {
        return RRN;
    }

    public void setRRN(String RRN) {
        this.RRN = RRN;
    }

    public String getSTAN() {
        return STAN;
    }

    public void setSTAN(String STAN) {
        this.STAN = STAN;
    }

    public String getCardHolderName() {
        return cardHolderName;
    }

    public void setCardHolderName(String cardHolderName) {
        this.cardHolderName = cardHolderName;
    }

    public String getOnlineCard() {
        return onlineCard;
    }

    public void setOnlineCard(String onlineCard) {
        this.onlineCard = onlineCard;
    }

    public String getSerialNO() {
        return serialNO;
    }

    public void setSerialNO(String serialNO) {
        this.serialNO = serialNO;
    }


}


