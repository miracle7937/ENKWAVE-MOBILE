package com.etop_pos_plugin.utils;

import android.content.SharedPreferences;


import com.etop_pos_plugin.networking.model.PrepResultRecord;
import com.google.gson.Gson;

import java.util.HashMap;



public class PrefManager {
    private static final String PREF_NAME = "eTopCardLibrary";
    // shared pref mode
    int PRIVATE_MODE = 0;
    public SharedPreferences pref;
    public SharedPreferences.Editor editor;
    public static final String TERMINAL_MASTER_KEY = "tmk";
    public static final String TERMINAL_SESSION_KEY = "tsk";
    public static final String TERMINAL_PIN_KEY = "tpk";
    public static final String TERMINAL_ID_KEY = "tid";
    public static final String MERCHANT_ID_KEY = "mid";
    public static final String MERCHANT_CODE_KEY = "mCode";
    public static final String MERCHANT_NAME_KEY = "mName";
    // reprint keys
    public static final String T_Status = "Transaction Status";
    public static final String T_ExpiryDate = "ExpiryDate";
    public static final String T_Customer = "Customer";
    public static final String T_Amount = "Amount";
    public static final String T_Pan = "Card Pan";
    public static final String T_ResponseCode = "Response Code";
    public static final String PREP_DATA = "PREP_DATA";
    public static final String PREP_DATA_TIME = "PREP_DATA_TIME";
    public static final String LOGO_IMAGE = "LOGO_IMAGE";

    public PrefManager() {
        pref = MyApplication.getINSTANCE().getSharedPreferences(PREF_NAME, PRIVATE_MODE);
        editor = pref.edit();
    }


    public void savePrepData(PrepResultRecord prepResultRecord) {
        editor.putString(PREP_DATA, new Gson().toJson(prepResultRecord));
        editor.commit();
    }


    public void savePrepTime( Long value) {
        System.out.println(" Prep Time ===============> "+ value);
        editor.putLong(PREP_DATA_TIME, value);
        editor.commit();
    }
    public Long getPrepTime() {
       return pref.getLong(PREP_DATA_TIME, 0);

    }
    public PrepResultRecord getPrepData() {
        return  new Gson().fromJson(pref.getString(PREP_DATA, ""),PrepResultRecord.class );
    }

    public void saveLOGO( String value) {
        System.out.println(" Prep Time ===============> "+ value);
        editor.putString(LOGO_IMAGE, value);
        editor.commit();
    }
    public String getLOGOFileLocation() {
        return pref.getString(LOGO_IMAGE, "");

    }

    public void setCredentials(String tmk, String tsk, String tpk, String tid, String merchantId,
                               String merchantCode, String merchantName) {
        editor.putString(TERMINAL_MASTER_KEY, tmk);
        editor.putString(TERMINAL_SESSION_KEY, tsk);
        editor.putString(TERMINAL_PIN_KEY, tpk);
        editor.putString(TERMINAL_ID_KEY, tid);
        editor.putString(MERCHANT_ID_KEY, merchantId);
        editor.putString(MERCHANT_CODE_KEY, merchantCode);
        editor.putString(MERCHANT_NAME_KEY, merchantName);
        editor.commit();
    }

    public void setLastTransaction(HashMap<String, String> params) {
        for (String s : params.keySet()) {
            editor.putString(s, params.get(s));
        }
        editor.commit();
    }

    public HashMap<String, String> getLastTransaction() {
        HashMap<String, String> map = new HashMap<>();
        map.put(TERMINAL_ID_KEY, pref.getString(TERMINAL_ID_KEY, null));
        map.put(T_Customer, pref.getString(T_Customer, null));
        map.put(T_Pan, pref.getString(T_Pan, null));
        map.put(T_ExpiryDate, pref.getString(T_ExpiryDate, null));
        map.put(T_Amount, pref.getString(T_Amount, null));
        map.put(T_ResponseCode, pref.getString(T_ResponseCode, null));
        map.put(T_Status, pref.getString(T_Status, null));
        return map;
    }

    public void setTID(String tid) {
        editor.putString(TERMINAL_ID_KEY, tid);
        editor.commit();
    }

    public String getTID() {
        return pref.getString(TERMINAL_ID_KEY, null);
    }

    public HashMap<String, String> getTerminalDetails() {
        HashMap<String, String> parameters = new HashMap<String, String>();

        parameters.put(TERMINAL_MASTER_KEY, pref.getString(TERMINAL_MASTER_KEY, null));
        parameters.put(TERMINAL_SESSION_KEY, pref.getString(TERMINAL_SESSION_KEY, null));
        parameters.put(TERMINAL_PIN_KEY, pref.getString(TERMINAL_PIN_KEY, null));
        parameters.put(TERMINAL_ID_KEY, pref.getString(TERMINAL_ID_KEY, null));
        parameters.put(MERCHANT_ID_KEY, pref.getString(MERCHANT_ID_KEY, null));
        parameters.put(MERCHANT_CODE_KEY, pref.getString(MERCHANT_CODE_KEY, null));
        parameters.put(MERCHANT_NAME_KEY, pref.getString(MERCHANT_NAME_KEY, null));
        return parameters;
    }

}
