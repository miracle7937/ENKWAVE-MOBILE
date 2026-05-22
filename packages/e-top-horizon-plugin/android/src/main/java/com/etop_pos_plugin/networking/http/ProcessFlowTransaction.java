package com.etop_pos_plugin.networking.http;

import android.util.Log;

import com.etop_pos_plugin.networking.model.GenericResponse;
import com.etop_pos_plugin.networking.model.LogData;
import com.etop_pos_plugin.networking.model.ParameterModel;
import com.etop_pos_plugin.networking.model.TransactionRequest;
import com.etop_pos_plugin.networking.model.TransactionResponseModel;
import com.etop_pos_plugin.networking.model.TransactionType;
import com.etop_pos_plugin.networking.transaction.TransactionBalanceInquiry;
import com.etop_pos_plugin.networking.transaction.TransactionPurchase;
import com.etop_pos_plugin.utils.DeviceHelper;
import com.etop_pos_plugin.utils.StringUtil;


import java.io.IOException;
import java.util.HashMap;
import java.util.concurrent.CompletableFuture;

import retrofit2.Response;

public class ProcessFlowTransaction {

    public TransactionResponseModel go(TransactionType transactionType, TransactionRequest tranReqObj, ParameterModel parameterModel) throws Exception {


        System.out.println(tranReqObj.toString());
        String rrn =  StringUtil.getRRN();
        TransactionResponseModel transactionResponseModel = null;
        if (transactionType == TransactionType.PURCHASE){
            LogData log  = new LogData(tranReqObj, rrn);
            try {
                Response<GenericResponse> response =
                        new HTTPServiceBuilder().tranNotification().logTransaction(log).execute();
                if (!response.isSuccessful()) {
                    Log.w("ProcessFlowTransaction",
                            "pos-logs failed (" + response.code() + "); continuing purchase");
                }
            } catch (IOException e) {
                Log.w("ProcessFlowTransaction", "pos-logs unreachable; continuing purchase", e);
            }
            transactionResponseModel=    new TransactionPurchase().doWork(rrn, tranReqObj,parameterModel );
            System.out.println("+=======================************************************============ "+ transactionResponseModel.toString());
            TransactionResponseModel finalResponseModel = transactionResponseModel;
            CompletableFuture.runAsync(() -> {
                try {
                    new HTTPServiceBuilder().tranNotification().notifyT(finalResponseModel).execute();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
        }else  if(transactionType == TransactionType.BALANCE_INQUIRY){
            transactionResponseModel=    new TransactionBalanceInquiry().doWork(rrn, tranReqObj,parameterModel );

        }
        assert transactionResponseModel != null;
        transactionResponseModel.setTransactionType(transactionType);
        return  transactionResponseModel;
    }
}
