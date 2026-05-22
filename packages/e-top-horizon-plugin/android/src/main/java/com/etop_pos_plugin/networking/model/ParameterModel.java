package com.etop_pos_plugin.networking.model;

public class ParameterModel {
    String ctMkDatetime = "";
    String mid = "";
    String timeout = "";
    String currencyCode = "";
    String countryCode = "";
    String callHome = "";
    String mnl = "";
    String mcc = "";

    public String getCtMkDatetime() {
        return ctMkDatetime;
    }

    public String getMid() {
        return mid;
    }

    public String getTimeout() {
        return timeout;
    }

    public String getCurrencyCode() {
        return currencyCode;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public String getCallHome() {
        return callHome;
    }

    public String getMnl() {
        return mnl;
    }

    public String getMcc() {
        return mcc;
    }

    public void setCtMkDatetime(String ctMkDatetime) {
        this.ctMkDatetime = ctMkDatetime;
    }

    public void setMid(String mid) {
        this.mid = mid;
    }

    public void setTimeout(String timeout) {
        this.timeout = timeout;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public void setCallHome(String callHome) {
        this.callHome = callHome;
    }

    public void setMnl(String mnl) {
        this.mnl = mnl;
    }

    public void setMcc(String mcc) {
        this.mcc = mcc;
    }
}
