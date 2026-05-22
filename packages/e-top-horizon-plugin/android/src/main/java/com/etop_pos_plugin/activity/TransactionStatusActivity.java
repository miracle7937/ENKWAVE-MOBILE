package com.etop_pos_plugin.activity;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.WindowManager;
import android.widget.TextView;

import com.airbnb.lottie.LottieAnimationView;
import com.etop_pos_plugin.etop_pos_plugin.R;
import com.etop_pos_plugin.networking.model.TransactionDataModel;
import com.etop_pos_plugin.networking.model.TransactionResponseModel;
import com.etop_pos_plugin.networking.model.TransactionType;
import com.etop_pos_plugin.pay.CreditCard;
import com.etop_pos_plugin.utils.EnkPAyPrinting;
import com.etop_pos_plugin.utils.HexUtil;
import com.etop_pos_plugin.utils.CustomerData;
import com.etop_pos_plugin.utils.OurPassPrinting;
import com.etop_pos_plugin.utils.PrefManager;
import com.etop_pos_plugin.utils.StringUtil;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Locale;

public class TransactionStatusActivity extends AppCompatActivity {
    private static final int RESULT_CODE_REMOVED = 2;
    private LottieAnimationView animationView;
    TextView transactionType, transactionMessage, amountText , statusMessage;
    boolean isSuccess;



    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_status);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        animationView = findViewById(R.id.animation_view);
        transactionType = findViewById(R.id.statusTitle);
        transactionMessage = findViewById(R.id.messageText);
        amountText = findViewById(R.id.amountText);
        statusMessage = findViewById(R.id.statusMessage);

        String dataMap  =  getIntent().getStringExtra("status_page_data");
        String cardData =  getIntent().getStringExtra("card_data");
        String transactionData =  getIntent().getStringExtra("transaction_data");

        if( StringUtil.isNotEmpty(dataMap)){
            TransactionDataModel transactionDataModel = new Gson().fromJson(transactionData, TransactionDataModel.class);;
        TransactionResponseModel transactionResponseModel = new Gson().fromJson(dataMap, TransactionResponseModel.class);
            if(transactionResponseModel.getTransactionType() == TransactionType.BALANCE_INQUIRY){
                if(transactionResponseModel.getAccountBalance() != null ){
                    amountText.setText( "NGN "+ transactionResponseModel.getAccountBalance());
                }

            }else {
                amountText.setText( "NGN "+ transactionDataModel.getAmount());
            }
        transactionType.setText(transactionResponseModel.getTransactionType().toString().replaceAll("_", " "));
        statusMessage.setText(transactionResponseModel.getResponseMessage());
        isSuccess = transactionResponseModel.getRespCode().equals("00");

        if (isSuccess) {
            transactionMessage.setText(R.string.transaction_approved);
            transactionMessage.setTextColor(getResources().getColor(R.color.green));
        } else {
            transactionMessage.setText(R.string.transaction_decline);
            transactionMessage.setTextColor(getResources().getColor(R.color.app_red));

        }

        if (isSuccess) {
            animationView.setAnimation(R.raw.success);
        } else {
            animationView.setAnimation(R.raw.error);
        }
        findViewById(R.id.continue_button).setOnClickListener(v -> {
            Intent resultIntent = new Intent();
            setResult(RESULT_CODE_REMOVED, resultIntent);
            finish();

        });


        findViewById(R.id.reprint).setOnClickListener(v -> {
            handleResponsePrint(transactionResponseModel, new Gson().fromJson(cardData, CreditCard.class),  transactionDataModel );
        });
}
    }

    public void handleResponsePrint(TransactionResponseModel transResponse, CreditCard creditCard,  TransactionDataModel transactionDataModel) {
        HashMap<String, String> parameters = new HashMap<String, String>();


        parameters.put("Terminal Id", transactionDataModel.getTid());
        parameters.put("Card Pan", HexUtil.mask(creditCard.getCardNumber()));
        parameters.put("ExpiryDate", creditCard.getExpireDate());

        parameters.put("Response Code", transResponse.getRespCode());
        parameters.put("Message", transResponse.getResponseMessage());
        parameters.put("Transaction ID", transResponse.getReceiptNumber());
        parameters.put("RRN", transResponse.getRRN());
        if(transResponse.getTransactionType() == TransactionType.BALANCE_INQUIRY){
            if(transResponse.getAccountBalance() != null){
                parameters.put("Account Balance",  transResponse.getAccountBalance());
            }

        }else {
            parameters.put("Amount", "NGN"+ transactionDataModel.getAmount());

        }
        parameters.put("STAN", transResponse.getSTAN());


        PrefManager prefManager = new PrefManager();
        prefManager.setLastTransaction(parameters);

        OurPassPrinting ourPassPrinting = new OurPassPrinting(this, parameters,transactionDataModel.getMerchantName(), transResponse.getTransactionType().getDescription().toUpperCase(Locale.ROOT));
        ourPassPrinting.print();

    }
}