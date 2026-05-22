package com.etop_pos_plugin.utils;

import com.google.gson.annotations.SerializedName;

import java.util.HashMap;

public class CustomerData {
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getUserID() {
        return userID;
    }

    public String getEmail() {
        return email;
    }

    @SerializedName("customerName")
    private String customerName;

    @SerializedName("userID")
    private String userID;


    @SerializedName("phoneNumber")
    private String phoneNumber;

    @SerializedName("email")
    private String email;

    @SerializedName("tid")
    private String tid;

    @SerializedName("amount")
    private String amount;

    @SerializedName("accountType")
    private String accountType;




    public CustomerData() {
    }

    @Override
    public String toString() {
        return "InstitutionData{" +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", email='" + email + '\'' +
                ", tid='" + tid + '\'' +
                ", amount='" + amount + '\'' +
                ", accountType='" + accountType + '\'' +
                '}';
    }

    public String getAccountType() {
        return accountType;
    }



    public CustomerData(String customerName, String userID,
                        String phoneNumber, String email, String tid, String amount, String accountType) {
            this.customerName = customerName;
            this.userID = userID;
            this.phoneNumber = phoneNumber;
            this.email = email;
            this.tid = tid;
            this.amount = amount;
            this.accountType = accountType;

        }






        public String getPhoneNumber() {
            return phoneNumber;
        }

        public void setPhoneNumber(String phoneNumber) {
            this.phoneNumber = phoneNumber;
        }


        public void setEmail(String email) {
            this.email = email;
        }

        public String getTid() {
            return tid;
        }

        public void setTid(String tid) {
            this.tid = tid;
        }

        public String getAmount() {
            return amount;
        }

        public void setAmount(String amount) {
            this.amount = amount;
        }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }



    public static CustomerData convertHashMapToStudentData(HashMap<String, String> dataMap) {
        CustomerData studentData = new CustomerData();
        studentData.setUserID(dataMap.get("userID"));
        studentData.setCustomerName(dataMap.get("customerName"));
        studentData.setPhoneNumber(dataMap.get("phoneNumber"));
        studentData.setEmail(dataMap.get("email"));
        studentData.setTid(dataMap.get("tid"));
        studentData.setAmount(dataMap.get("amount"));
        studentData.setAccountType(dataMap.get("accountType"));

        return studentData;
    }
    }

