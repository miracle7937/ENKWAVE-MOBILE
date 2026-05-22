package com.etop_pos_plugin.networking.model;

import java.util.HashMap;

public class NetworkVariables {
    private static NetworkVariables instance;

    public static NetworkVariables getInstance() {
        if (instance == null) {
            instance = new NetworkVariables();
        }

        return instance;
    }


    public String getBaseURL() {
        return baseURL;
    }

    public void setBaseURL(String baseURL) {
        this.baseURL = baseURL;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public void setSsl(String ssl) {
        this.ssl = ssl;
    }

    public String getCompKey1() {
        return compKey1;
    }

    public void setCompKey1(String compKey1) {
        this.compKey1 = compKey1;
    }

    public String getCompKey2() {
        return compKey2;
    }

    public void setCompKey2(String compKey2) {
        this.compKey2 = compKey2;
    }

    private   String baseURL = "";
    private  String ip = "";
    private    String port = "";
    private     String ssl = "";
    private     String compKey1 = "";
    private     String compKey2 = "";

    public  void  setTerminalData(HashMap<String, String> data){
      baseURL = data.get("baseUrl");
        ip = data.get("ip");
        port = data.get("port");
        ssl = data.get("ssl");
        compKey1 = data.get("compKey1");
        compKey2 = data.get("compKey2");
    }

//    public static final String ip = "core.medusang.com";
//    public  static   final String port = "8080";
//    public static   final String ssl = "false";
//    public static   final String compKey1 = "AD9160FC7946955E7BC4E27A8D10C0DA";
//    public static   final String compKey2 = "BC986FA24F0A4BAFEE42C81910D8EF52";
//    public String getIp() {
//        return ip;
//    }

    public String getPort() {
        return port;
    }

    public String getSsl() {
        return ssl;
    }
}
