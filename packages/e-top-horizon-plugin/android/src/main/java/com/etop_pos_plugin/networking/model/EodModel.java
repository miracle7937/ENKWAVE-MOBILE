package com.etop_pos_plugin.networking.model;

import com.etop_pos_plugin.utils.CustomerData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EodModel
{


    private List<TransactionResponseModel> transaction;

    private  Object totalItems;

    public void setPayments(List<TransactionResponseModel> transaction) {
        this.transaction = transaction;
    }

    public void setTotalItems(Object totalItems) {
        this.totalItems = totalItems;
    }

    public List<TransactionResponseModel> getPayments() {
        return transaction;
    }

    public Object getTotalItems() {
        return totalItems;
    }

    public EodModel() {
        transaction = new ArrayList<>();
    }

    @Override
    public String toString() {
        return "EodModel{" +
                "payments=" + transaction +
                ", totalItems=" + totalItems +
                '}';
    }

    public  EodModel setAllData(HashMap<String,Object> hashMap){
        EodModel eodModel = new EodModel();
        eodModel.setTotalItems((int) hashMap.get("totalItems"));
        List<Map<String, Object>> paymentMaps = (List<Map<String, Object>>) hashMap.get("transaction");
        List<TransactionResponseModel> payments = eodModel.getPayments();
        for (Map<String, Object> paymentMap : paymentMaps) {
            TransactionResponseModel payment = new TransactionResponseModel();
            payment.setCardExpireData((String) paymentMap.get("cardExpireData"));
            payment.setRRN((String) paymentMap.get("RRN"));
            payment.setTransactionType(TransactionType.PURCHASE);
            payment.setSTAN((String) paymentMap.get("STAN"));
            payment.setPan((String) paymentMap.get("pan"));
            payment.setTransactionTime((String) paymentMap.get("transactionTime"));
            payment.setStatus((Boolean) paymentMap.get("status"));
            payment.setResponseMessage((String) paymentMap.get("responseMessage"));
          payments.add(payment);
        }
        eodModel.setPayments(payments);
      return eodModel;
    }
}







