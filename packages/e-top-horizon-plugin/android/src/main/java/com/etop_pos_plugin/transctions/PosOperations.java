package com.etop_pos_plugin.transctions;

import android.app.Activity;
import android.app.ProgressDialog;

import com.etop_pos_plugin.networking.model.TransactionType;
import com.etop_pos_plugin.utils.CustomLoader;
import com.etop_pos_plugin.utils.ETopMVDevicePrep;
import com.etop_pos_plugin.utils.ETopPayProcessor;
import com.etop_pos_plugin.utils.PrepCompletionListener;

import java.util.HashMap;

public class PosOperations
{

    public  void  pay(Activity activity, TransactionType transactionType,  HashMap<String, String> transactionData ){
        CustomLoader customLoader = new CustomLoader(activity);
        customLoader.showLoader("Please insert your card....");
    new ETopPayProcessor(activity).payNow( transactionType, transactionData, false, customLoader);

    }

    public  void  balanceInquiry(Activity activity, TransactionType transactionType,  HashMap<String, String> transactionData ){
        CustomLoader customLoader = new CustomLoader(activity);
        customLoader.showLoader("Please insert your card....");
        new ETopPayProcessor(activity).payNow( transactionType, transactionData, false, customLoader);

    }


    public void keyExchange(Activity activity, String terminalID, String imageUrl,
                            boolean showLoader, PrepCompletionListener listener) {
        CustomLoader customLoader = new CustomLoader(activity);
        if (showLoader) {
            customLoader.showLoader("Downloading keys...");
        }
        new ETopMVDevicePrep(terminalID, imageUrl, activity, customLoader, showLoader, listener)
                .KeyExchange();
    }



}
