package com.etop_pos_plugin.networking.model;

import android.os.RemoteException;

import com.etop_pos_plugin.utils.DeviceHelper;
import com.google.gson.annotations.SerializedName;

public class LogData {

    @SerializedName("terminalID")
    String terminalID;

    @SerializedName("amount")
    String amount;


    @SerializedName("transactionType")
    String transactionType;


    @SerializedName("RRN")
    String RRN;

    @SerializedName("pan")
    String pan;


    @SerializedName("cardName")
    String  cardName;

    @SerializedName("serialNO")
    String serialNO;

    @SerializedName("responseCode")
    String responseCode;


    @Override
    public String toString() {
        return "LogData{" +
                "terminalID='" + terminalID + '\'' +
                ", amount='" + amount + '\'' +
                ", transactionType='" + transactionType + '\'' +
                ", RRN='" + RRN + '\'' +
                ", pan='" + pan + '\'' +
                ", cardName='" + cardName + '\'' +
                ", serialNO='" + serialNO + '\'' +
                ", responseCode='" + responseCode + '\'' +
                '}';
    }

    public    LogData(TransactionRequest transactionRequest, String RRN) throws RemoteException {
        this.terminalID = transactionRequest.getTerminalID();
        this.amount = transactionRequest.getAmount();
        this.transactionType = "PURCHASE";
        this.RRN = RRN;
        this.pan = transactionRequest.getCardPan();
        this.serialNO = DeviceHelper.getSysHandle().getSn();
    }


    public String getTerminalID() {
        return terminalID;
    }

    public void setTerminalID(String terminalID) {
        this.terminalID = terminalID;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public String getRRN() {
        return RRN;
    }

    public void setRRN(String RRN) {
        this.RRN = RRN;
    }



    public String getPan() {
        return pan;
    }

    public void setPan(String pan) {
        this.pan = pan;
    }

    public String getCardName() {
        return cardName;
    }

    public void setCardName(String cardName) {
        this.cardName = cardName;
    }

    public String getDeviceNO() {
        return serialNO;
    }

    public void setDeviceNO(String deviceNO) {
        this.serialNO = deviceNO;
    }

    public String getResponseCode() {
        return responseCode;
    }

    public void setResponseCode(String responseCode) {
        this.responseCode = responseCode;
    }


}
