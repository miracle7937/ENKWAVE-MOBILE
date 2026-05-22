package com.etop_pos_plugin.utils;


import static com.etop_pos_plugin.pay.TransactionResultCode.ERROR_TRANSCATION_CANCEL;
import static com.etop_pos_plugin.pay.TransactionResultCode.ERROR_TRANSCATION_TIMEOUT;
import static com.etop_pos_plugin.pay.TransactionResultCode.ERROR_UNKNOWN;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.RemoteException;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;


import com.etop_pos_plugin.activity.TransactionStatusActivity;
import com.etop_pos_plugin.networking.http.ProcessFlowTransaction;
import com.etop_pos_plugin.networking.miscellaneous.Utilities;
import com.etop_pos_plugin.networking.model.NetworkVariables;
import com.etop_pos_plugin.networking.model.PrepResultRecord;
import com.etop_pos_plugin.networking.model.TransactionRequest;
import com.etop_pos_plugin.networking.model.TransactionResponseModel;
import com.etop_pos_plugin.networking.model.TransactionType;
import com.etop_pos_plugin.networking.transaction.TransactionPurchase;
import com.etop_pos_plugin.pay.CardReadMode;
import com.etop_pos_plugin.pay.CreditCard;
import com.etop_pos_plugin.pay.OnlineRespEntitiy;
import com.etop_pos_plugin.pay.PayProcessor;
import com.etop_pos_plugin.pay.TransactionResultCode;
import com.google.gson.Gson;
import com.horizonpay.smartpossdk.BuildConfig;
import com.horizonpay.smartpossdk.aidl.cardreader.IAidlCardReader;
import com.horizonpay.smartpossdk.aidl.emv.AidEntity;
import com.horizonpay.smartpossdk.aidl.emv.AidlCheckCardListener;
import com.horizonpay.smartpossdk.aidl.emv.AidlEmvStartListener;
import com.horizonpay.smartpossdk.aidl.emv.CandidateAID;
import com.horizonpay.smartpossdk.aidl.emv.EmvFinalSelectData;
import com.horizonpay.smartpossdk.aidl.emv.EmvTags;
import com.horizonpay.smartpossdk.aidl.emv.EmvTransData;
import com.horizonpay.smartpossdk.aidl.emv.EmvTransOutputData;
import com.horizonpay.smartpossdk.aidl.emv.IAidlEmvL2;
import com.horizonpay.smartpossdk.aidl.magcard.TrackData;
import com.horizonpay.smartpossdk.aidl.pinpad.AidlPinPadInputListener;
import com.horizonpay.smartpossdk.aidl.pinpad.IAidlPinpad;
import com.horizonpay.smartpossdk.data.EmvConstant;
import com.horizonpay.smartpossdk.data.PinpadConst;
import com.horizonpay.utils.ConvertUtils;
import com.horizonpay.utils.ToastUtils;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;


import javax.xml.transform.Source;

import io.reactivex.Single;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;

public class ETopPayProcessor {
    public enum CardReadMode {
        MANUAL,
        SWIPE,
        FALLBACK_SWIPE,
        CONTACT,
        CONTACTLESS,
        CONTACTLESS_MSD,
    }

    IAidlEmvL2 mEmvL2;
    private IAidlPinpad mPinPad;
    PPayProcessor pPayProcessor;
    CustomLoader customLoader;
    HashMap<String, String> transactionData;
    Activity mContext;
    boolean printSingle, printDouble;
    ProgressDialog progressDialog;
    AlertDialog.Builder alertBuilder;
    TransactionType transactionType;
    String TAG =ETopPayProcessor.class.toString();

    private Handler uiThreadHandler = new Handler(Looper.getMainLooper());

    public interface PayProcessorListener {
        void onRetry(int retryFlag);

        void onCardDetected(CardReadMode cardReadMode, CreditCard creditCard);

        OnlineRespEntitiy onPerformOnlineProcessing(CreditCard creditCard, long amount);

        void onCompleted(TransactionResultCode result, CreditCard creditCard);

    }

//    void showTransactionAlert(String message, HashMap<String, String> params) {
//        alertBuilder.setTitle(message);
//        StringBuilder stringBuilder = new StringBuilder();
//        for (Map.Entry<String, String> pair : params.entrySet()) {
//            stringBuilder.append(String.format("%s: ", pair.getKey())).append(pair.getValue()).append("\n");
//        }
//        alertBuilder.setMessage(stringBuilder)
//                .setCancelable(false)
//                .setPositiveButton("OKAY", (dialog, id) -> dialog.dismiss());
//        AlertDialog alert = alertBuilder.create();
//        alert.show();
//    }

    public ETopPayProcessor(Activity context) {
        this.mContext = context;
        pPayProcessor = new PPayProcessor();
        progressDialog = new ProgressDialog(mContext);
        progressDialog.setMessage("Please wait");
        progressDialog.setCanceledOnTouchOutside(false);
        alertBuilder = new AlertDialog.Builder(mContext);


        try {
            mEmvL2 = DeviceHelper.getEmvHandler();
            mPinPad = DeviceHelper.getPinpad();
            downloadAID();

        } catch (RemoteException e ) {
            e.printStackTrace();
        }
    }
    private void downloadAID() {
        List<AidEntity> aidEntityList = AidsUtil.getAllAids();
        boolean ret = false;
        for (int i = 0; i < aidEntityList.size(); i++) {
            String tip = "Download aid" + String.format("(%d)", i);

            AidEntity emvAidPara = aidEntityList.get(i);
            try {
                ret = mEmvL2.addAid(emvAidPara);
                if (!ret) {
                    break;
                }
            } catch (RemoteException e) {
                e.printStackTrace();
            }

        }
    }

    private static boolean shouldExcludeKey(String key, String[] excludedKeys) {
        for (String excludedKey : excludedKeys) {
            if (key.equals(excludedKey)) {
                return true;
            }
        }
        return false;
    }
    public void payNow( TransactionType transactionType, HashMap<String, String> transactionData, boolean printDouble, CustomLoader customLoader) {
        Debug.print("make payment =================>"+ transactionData);
        if (!NetworkUtils.isNetworkConnected(mContext)) {
            ToastUtils.showLong("Not  network connection");
            return;
        }
        this.transactionData = transactionData;
        this.printSingle = true;
        this.printDouble = printDouble;
        this.customLoader= customLoader;
        this.transactionType = transactionType;
//        ToastUtils.showShort("Insert card");
        //check if pre time is exceeded
        boolean keyPassedTime=   DateUtils.hourPassed(3, new PrefManager().getPrepTime());
        if(keyPassedTime){
            Debug.print( "Fetching key: " + NetworkVariables.getInstance().getPort());
            uiThreadHandler.post(() -> customLoader.updateText("Downloading keys..."));
            new ETopMVDevicePrep(ETopPayProcessor.this.transactionData.get("tid"), null, mContext, customLoader, true).KeyExchange();
        }
        pPayProcessor.pay(transactionData.get("amount"), processorListener);
    }

    private PayProcessorListener processorListener = new PayProcessorListener() {
        @Override
        public void onRetry(int retryFlag) {
        }


        @Override
        public void onCardDetected(final CardReadMode cardReadMode, CreditCard creditCard) {
            uiThreadHandler.post(() -> {
                if (progressDialog.isShowing()) {
                    progressDialog.hide();
                }
            });
        }

        @SuppressLint("CheckResult")
        @Override
        public OnlineRespEntitiy onPerformOnlineProcessing(CreditCard creditCard, long amount) {
//            uiThreadHandler.post(() -> progressDialog.show());
            uiThreadHandler.post(() -> customLoader.updateText("Processing transaction...."));

            PrefManager prefManager = new PrefManager();
            PrepResultRecord prepResultRecord = prefManager.getPrepData();
            TransactionRequest tranReqObj = new TransactionRequest();
            tranReqObj.setAmount(transactionData.get("amount"));
            tranReqObj.setExpiryDate(creditCard.getExpireDate());
            tranReqObj.setCardPan(creditCard.getCardNumber());
            tranReqObj.setCardData(creditCard.getEmvData().getIccData());
            tranReqObj.setProcessingCode( transactionData.get("accountType") );
            tranReqObj.setPinBlock(creditCard.getPIN());
            tranReqObj.setSessionkey(prepResultRecord.getSessionKeyModel().getClearSessionKey());
            tranReqObj.setTerminalID(transactionData.get("terminalNo"));
            tranReqObj.setMerchantName(prepResultRecord.getParameterModel().getMnl());
            tranReqObj.setMerchantID(prepResultRecord.getParameterModel().getMid());
            tranReqObj.setTrack2data(creditCard.getEmvData().getTrack2());
            tranReqObj.setICCData(creditCard.geticcIIData());
            String csn = creditCard.getCardSequenceNumber();
            if (csn.length() == 2) {
                csn = "0" + csn;
            }
            tranReqObj.setCSN(csn);
            tranReqObj.setMerchantCategoryCode(prepResultRecord.getParameterModel().getMcc());
            int indexOfToken = creditCard.getEmvData().getTrack2().indexOf("D");
            int indexOfServiceCode = indexOfToken + 5;
            int lengthOfServiceCode = 3;
            String serviceCode = creditCard.getEmvData().getTrack2().substring(indexOfServiceCode, indexOfServiceCode + lengthOfServiceCode);
            tranReqObj.setServiceCode(serviceCode);
            Disposable subscribe = Single.fromCallable(() ->
                            new ProcessFlowTransaction().go( ETopPayProcessor.this.transactionType, tranReqObj,prepResultRecord.getParameterModel()
                                   )).
                    subscribeOn(Schedulers.io()).
                    observeOn(AndroidSchedulers.mainThread()).
                    subscribe(result -> handleResponse(result, creditCard), error -> {

//                        if exception please prep again
                        error.printStackTrace();
                        System.out.println(error+ "=======================M "+ error);
                        uiThreadHandler.post(() ->customLoader.updateText("Downloading keys..."));
                        new ETopMVDevicePrep(transactionData.get("tid"),null, mContext, customLoader, true).KeyExchange();
                        uiThreadHandler.post(() -> {
                            if (progressDialog.isShowing()) {
                                progressDialog.hide();
                                ToastUtils.showShort("An unexpected error occured:: " + error);
                            }
                        });

                    });
            return null;
        }

        @SuppressLint("SimpleDateFormat")
        public void handleResponse(TransactionResponseModel transResponse, CreditCard creditCard) {
            HashMap<String, String> parameters = new HashMap<>();
            parameters.put("Terminal Id", ETopPayProcessor.this.transactionData.get("tid"));
            parameters.put("Card Pan", HexUtil.mask(creditCard.getCardNumber()));
            parameters.put("ExpiryDate", creditCard.getExpireDate());
            parameters.put("Response Code", transResponse.getRespCode());
            parameters.put("Message", transResponse.getResponseMessage());
            parameters.put("Transaction ID", transResponse.getReceiptNumber());
            parameters.put("RRN", transResponse.getRRN());
            parameters.put("STAN", transResponse.getSTAN());
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            parameters.put("DateTime", sdf.format(new Date()));
            if(ETopPayProcessor.this.transactionType == TransactionType.BALANCE_INQUIRY){
                if(transResponse.getAccountBalance() != null){
                    parameters.put("Account Balance", transResponse.getAccountBalance());
                }

            }else{
                parameters.put("Amount", "NGN"+transactionData.get("amount"));

            }

            PrefManager prefManager = new PrefManager();
            prefManager.setLastTransaction(parameters);

            uiThreadHandler.post(() -> {
                if (progressDialog.isShowing()) {
                    progressDialog.hide();
                }
//                showTransactionAlert(transResponse.getResponseMessage(), parameters);
                //end process if it null
                if(!StringUtil.isNotEmpty(transResponse.getRespCode())){
                    ToastUtils.showShort("An Error Occurred " );
                    return;
                }

                uiThreadHandler.post(() -> customLoader.hideLoader());
                //move to status screen
                Intent intent = new Intent( mContext, TransactionStatusActivity.class);
                intent.putExtra("status_page_data", new Gson().toJson(transResponse));
                intent.putExtra("transaction_data", new Gson().toJson(transactionData));
                intent.putExtra("card_data", new Gson().toJson(creditCard));
                mContext.startActivityForResult(intent, 1);
            });
            if (printDouble) {
                OurPassPrinting ourPassPrinting = new OurPassPrinting(mContext, parameters ,true,  ETopPayProcessor.this.transactionData.get("merchantName"), transResponse.getTransactionType().getDescription().toUpperCase());
                ourPassPrinting.print();
            } else if (printSingle) {
                OurPassPrinting ourPassPrinting = new OurPassPrinting(mContext, parameters, ETopPayProcessor.this.transactionData.get("merchantName"), transResponse.getTransactionType().getDescription().toUpperCase());
                ourPassPrinting.print();
            }
        }


        @Override
        public void onCompleted(TransactionResultCode result, CreditCard creditCard) {
            if(result ==TransactionResultCode.ERROR_TRANSCATION_CANCEL
                    ||result == TransactionResultCode.ERROR_TRANSCATION_TIMEOUT
                    ||result == ERROR_UNKNOWN ||
                    result == TransactionResultCode.DECLINED_BY_TERMINAL_NEED_REVERSE   ){
                uiThreadHandler.post(() -> customLoader.hideLoader());
            }else {
                System.out.println("onPerformOnlineProcessing ================================== "+result);

            }
        }
    };
}

class PPayProcessor {

    private IAidlCardReader mCardReader;
    private IAidlEmvL2 mEmvL2;
    private IAidlPinpad mPinPad;
    private ETopPayProcessor.PayProcessorListener mListener;
    private long mAmount;
    private CardReadMode mCardReadMode = CardReadMode.MANUAL;
    private OnlineRespEntitiy mOnlineRespEntitiy;
    private long startTick;
    private final String LOG_TAG = PayProcessor.class.getSimpleName();
    private CreditCard creditCard;

    public PPayProcessor() {
        try {
            mCardReader = DeviceHelper.getCardReader();
            mEmvL2 = DeviceHelper.getEmvHandler();
            mPinPad = DeviceHelper.getPinpad();
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }


    private void init() {
        mOnlineRespEntitiy = null;
        mCardReadMode = CardReadMode.MANUAL;

    }

    public void pay(String amount, ETopPayProcessor.PayProcessorListener listener) {
        init();
        mListener = listener;
        String amountISO = HexUtil.padLeft(amount, 12, '0');
        mAmount = Long.parseLong(amountISO);
        try {
            mListener.onRetry(0);
            startTick = System.currentTimeMillis();
            creditCard = new CreditCard();
            mCardReader.searchCard(true, true, true, 100, checkCardListener);
        } catch (RemoteException e) {
            mListener.onCompleted(ERROR_UNKNOWN, new CreditCard());
            e.printStackTrace();

        }
    }

    private AidlCheckCardListener.Stub checkCardListener = new AidlCheckCardListener.Stub() {
        @Override
        public void onFindMagCard(TrackData data) throws RemoteException {
            AppLog.d(LOG_TAG, "card NO:" + data.getCardNo());
            mCardReadMode = CardReadMode.SWIPE;
            creditCard.setCardReadMode(CardReadMode.SWIPE);
            creditCard.setCardNumber(data.getCardNo());
            creditCard.setExpireDate(data.getExpiryDate());
            creditCard.setHolderName(data.getCardholderName());
            creditCard.setServiceCode(data.getServiceCode());
            CreditCard.MagData magData = new CreditCard.MagData(data.getTrack1Data(), data.getTrack2Data());
            creditCard.setMagData(magData);
            mListener.onCardDetected(ETopPayProcessor.CardReadMode.SWIPE, creditCard);
        }

        @Override
        public void onSwipeCardFail() throws RemoteException {
            TransactionResultCode transactionResultCode = ERROR_UNKNOWN;
            mListener.onCompleted(transactionResultCode, new CreditCard());

        }

        @Override
        public void onFindICCard() throws RemoteException {
            mCardReadMode = CardReadMode.CONTACT;
            AppLog.i(LOG_TAG, "onFindICCard: ");
            AppLog.i(LOG_TAG, "time = " + (System.currentTimeMillis() - startTick) + "ms");
            creditCard.setCardReadMode(CardReadMode.CONTACT);
            mListener.onCardDetected(ETopPayProcessor.CardReadMode.CONTACT, creditCard);
            stopSearch();
            AppLog.i(LOG_TAG, "startEMVProcess>>>>>: ");
            startEMVProcess();
        }

        @Override
        public void onFindRFCard(int ctlsCardType) throws RemoteException {
            mCardReadMode = CardReadMode.CONTACTLESS;
            AppLog.d(LOG_TAG, "onFindRFCard: ");
            AppLog.i(LOG_TAG, "time = " + (System.currentTimeMillis() - startTick) + "ms");
            creditCard.setCardReadMode(CardReadMode.CONTACTLESS);
            mListener.onCardDetected(ETopPayProcessor.CardReadMode.CONTACTLESS, creditCard);
            stopSearch();
            startEMVProcess();
        }

        @Override
        public void onTimeout() throws RemoteException {
            AppLog.d(LOG_TAG, "SearchCard = onTimeout ");
            mListener.onCompleted(ERROR_TRANSCATION_TIMEOUT, new CreditCard());
        }

        @Override
        public void onCancelled() throws RemoteException {
            AppLog.d(LOG_TAG, "SearchCard = onCancelled ");
            mListener.onCompleted(ERROR_UNKNOWN, new CreditCard());

        }

        @Override
        public void onError(int errCode) throws RemoteException {
            AppLog.e(LOG_TAG, "SearchCard = onError " + errCode);
            mListener.onCompleted(ERROR_UNKNOWN, new CreditCard());

        }
    };

    private AidlEmvStartListener.Stub emvStartListener = new AidlEmvStartListener.Stub() {
        @Override
        public void onRequestAmount() throws RemoteException {
            AppLog.d(LOG_TAG, "emvStartListener onRequestAmount: ");
            mEmvL2.requestAmountResp(String.valueOf(mAmount));
        }

        @Override
        public void onRequestAidSelect(int times, List<CandidateAID> aids) throws RemoteException {
            AppLog.d(LOG_TAG, "onRequestAidSelect: ");
            selApp(aids);
        }

        @Override
        public void onFinalSelectAid(EmvFinalSelectData emvFinalSelectData) throws RemoteException {
            AppLog.d(LOG_TAG, "onFinalSelectAid: " + emvFinalSelectData.getAid());
            mEmvL2.requestFinalSelectAidResp("");
        }

        @Override
        public void onConfirmCardNo(final String cardNo) throws RemoteException {
            AppLog.d(LOG_TAG, "onConfirmCardNo: " + cardNo);
            AppLog.i(LOG_TAG, "time = " + (System.currentTimeMillis() - startTick) + "ms");
            mEmvL2.confirmCardNoResp(true);
        }


        @Override
        public void onRequestPin(boolean isOnlinePIN, int leftTimes) throws RemoteException {
            AppLog.d(LOG_TAG, "onCardHolderInputPin isOnlinePin: " + isOnlinePIN + "offlinePIN leftTimes: " + leftTimes);

            String PAN = mEmvL2.getTagValue("5A");
            if (PAN != null) {
                PAN = PAN.replace("F", "");
            }
            AppLog.d(LOG_TAG, "onRequestPin: PAN " + PAN);
            if (isOnlinePIN) {
                inputOnlinePIN(PAN);
            } else {
                AppLog.d(LOG_TAG, "onRequestPin: offline PIN");
                inputOfflinePIN(PAN, leftTimes);
            }
        }

        @Override
        public void onResquestOfflinePinDisp(int i) throws RemoteException {
            if (i == 0) {
                AppLog.d(LOG_TAG, "onResquestOfflinePinDisp: PIN OK !");
            } else {
                AppLog.d(LOG_TAG, "WRONG PIN --> " + i + "Chance Left");
            }
        }


        @Override
        public void onRequestOnline(EmvTransOutputData emvTransOutputData) throws RemoteException {
            getEmvCardInfo();
            String respCode = "00";
            String iccData = "";
            AppLog.d(LOG_TAG, "onRequestOnline PIN : " + creditCard.getPIN());
            AppLog.d(LOG_TAG, "onRequestOnline: true");
            AppLog.d(LOG_TAG, "time = " + (System.currentTimeMillis() - startTick) + "ms");
            String newIccData = getIcdcData();
            if (BuildConfig.DEBUG == true) {
                AppLog.d(LOG_TAG, "onRequestOnline: Simulate Online process>>>>");
                iccData = onlineProc();
                creditCard.seticcIIData(newIccData);
                mOnlineRespEntitiy = mListener.onPerformOnlineProcessing(creditCard, mAmount);

            } else {
                creditCard.seticcIIData(newIccData);
                mOnlineRespEntitiy = mListener.onPerformOnlineProcessing(creditCard, mAmount);
            }

            if (mOnlineRespEntitiy != null) {
                respCode = mOnlineRespEntitiy.getRespCode();
                iccData = mOnlineRespEntitiy.getIccData();
            }
            mEmvL2.requestOnlineResp(respCode, iccData);
        }

        private String getIcdcData() throws RemoteException {
            String iccDataConcatenated = "";
            String v9F26 = mEmvL2.getTagValue("9F26");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F26", v9F26);
            String v9F27 = mEmvL2.getTagValue("9F27");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F27", v9F27);
            String v9F33 = mEmvL2.getTagValue("9F33");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F33", v9F33);
            String v5F34 = mEmvL2.getTagValue("5F34");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("5F34", v5F34);
            String v9F35 = mEmvL2.getTagValue("9F35");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F35", v9F35);
            String v9F34 = mEmvL2.getTagValue("9F34");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F34", v9F34);
            String v9F10 = mEmvL2.getTagValue("9F10");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F10", v9F10);
            String v9F37 = mEmvL2.getTagValue("9F37");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F37", v9F37);
            String v9F36 = mEmvL2.getTagValue("9F36");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F36", v9F36);
            String v95 = mEmvL2.getTagValue("95");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("95", v95);
            String v9A = mEmvL2.getTagValue("9A");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9A", v9A);
            String v9C = mEmvL2.getTagValue("9C");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9C", v9C);
            String v9F02 = mEmvL2.getTagValue("9F02");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F02", v9F02);
            String v5F2A = mEmvL2.getTagValue("5F2A");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("5F2A", v5F2A);
            String v82 = mEmvL2.getTagValue("82");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("82", v82);
            String v9F1A = mEmvL2.getTagValue("9F1A");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F1A", v9F1A);
            String v9F1E = mEmvL2.getTagValue("9F1E");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F1E", v9F1E);
            String v84 = mEmvL2.getTagValue("84");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("84", v84);
            String v9F09 = mEmvL2.getTagValue("9F09");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F09", v9F09);
            String v9F03 = mEmvL2.getTagValue("9F03");
            iccDataConcatenated = iccDataConcatenated + ConcatLenght2Str("9F03", v9F03);
            return iccDataConcatenated;
        }

        public String ConcatLenght2Str(String tag, String value) {
            int lenght = value.length() / 2;
            String hexlenght;
            if (lenght <= 9) {
                hexlenght = "0" + lenght;
            } else {
                hexlenght = Integer.toHexString(lenght);
            }

            String tlv = tag + hexlenght + value;
            return tlv;
        }


        @Override
        public void onFinish(final int emvResult, EmvTransOutputData emvTransOutputData) throws RemoteException {
            AppLog.d(LOG_TAG, "CallBack onFinish: ");
            AppLog.d(LOG_TAG, "time = " + (System.currentTimeMillis() - startTick) + "ms");

            emvFinish(emvResult, emvTransOutputData);
            AppLog.e(LOG_TAG, "onError: onFinish: ");
        }

        @Override
        public void onError(int errCode) throws RemoteException {
            AppLog.e(LOG_TAG, "onError: errcode: " + errCode);
            emvFinish(EmvConstant.EmvTransResultCode.ERROR_UNKNOWN, new EmvTransOutputData());
        }

    };

    public String getEmvRecordTLV() {
        final String[] standard_Tags = {
                "9f26",
                "9f27",
                "9f10",
                "9f37",
                "9f36",
                "95",
                "9a",
                "9c",
                "9f02",
                "5f2a",
                "9f1a",
                "82",
                "9f33",
                "9f34",
                "9f03",
                "84",
                "9F08",
                "9f09",
                "9f35",
                "9f1e",
                "9F53",
                "9f41",
                "9f63",
                "9F6E",
                "9F4C",
                "9F5D",
                "9B",
                "5F34",
                "50",
                "9F12",
                "91",
                "DF31",
                "8F",
                "9F6B",
                "5F34",
                "9F26",
                "9F27",
                "9F10",
                "9F37",
                "9F36",
                "95",
                "9A",
                "9C",
                "9F02",
                "5F2A",
                "82",
                "9F1A",
                "9F03",
                "9F33",
                "9F34",
                "9F35",
                "9F1E",
                "9F09",
                "84",
        };
        try {
            return mEmvL2.getTlvByTags(standard_Tags);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void getEmvCardInfo() {
        creditCard.setCardReadMode(mCardReadMode);
        try {
            String cardsn = mEmvL2.getTagValue(EmvTags.EMV_TAG_IC_PANSN);
            if (cardsn != null && !cardsn.isEmpty()) {
                creditCard.setCardSequenceNumber(cardsn);
            }

            String track2 = mEmvL2.getTagValue(EmvTags.EMV_TAG_IC_TRACK2DATA);
            if (track2 == null || track2.isEmpty()) {
                track2 = mEmvL2.getTagValue(EmvTags.M_TAG_IC_9F6B);
            }
            if (track2 != null && track2.length() > 20) {
                if (track2.endsWith("F") || track2.endsWith("f")) {
                    track2 = track2.substring(0, track2.length() - 1);
                }
                String formatTrack2 = track2.toUpperCase().replace('=', 'D');

                int idx = formatTrack2.indexOf('D');
                String expDate = track2.substring(idx + 1, idx + 5);

                creditCard.setExpireDate(expDate);

                String pan = track2.substring(0, idx);
                creditCard.setCardNumber(pan);
                CreditCard.EmvData emvData = new CreditCard.EmvData("", formatTrack2, getEmvRecordTLV());
                creditCard.setEmvData(emvData);
            }

            String name = EmvUtil.readCardHolder();
            creditCard.setHolderName(ConvertUtils.formatHexString(name));
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private String onlineProc() throws RemoteException {
        StringBuilder builder = new StringBuilder();
        String arqcTlv = mEmvL2.getTlvByTags(EmvUtil.arqcTLVTags);
        builder.append(arqcTlv);
        AppLog.d(LOG_TAG, "onlineProc: arqcTlv: " + arqcTlv);
        byte[] arpcData = EmvUtil.getExampleARPCData();
        if (arpcData == null) {
            return "";
        }
        return HexUtil.bytesToHexString(arpcData);
    }

    private void emvFinish(int emvResult, EmvTransOutputData emvTransOutputData) throws RemoteException {
        TransactionResultCode transactionResultCode = TransactionResultCode.DECLINED_BY_ONLINE;
        AppLog.d(LOG_TAG, "emvFinish Result: " + emvResult);
        AppLog.d(LOG_TAG, "emvFinish AC: " + emvTransOutputData.getAcType());
        AppLog.d(LOG_TAG, "emvFinish PIN : " + creditCard.getPIN());
        if (emvResult == EmvConstant.EmvTransResultCode.SUCCESS) { // SUCCESS
            switch (emvTransOutputData.getAcType()) {
                case EmvConstant.EmvACType.AAC: //Trans End
                    if (mOnlineRespEntitiy == null) {
                        transactionResultCode = TransactionResultCode.DECLINED_BY_OFFLINE;
                    } else if ("00".equals(mOnlineRespEntitiy.getRespCode())) {
                        transactionResultCode = TransactionResultCode.DECLINED_BY_TERMINAL_NEED_REVERSE;
                    } else {
                        transactionResultCode = TransactionResultCode.DECLINED_BY_ONLINE;
                    }
                    break;

                case EmvConstant.EmvACType.TC:  //Trans accept
                    if (mOnlineRespEntitiy == null) {
                        transactionResultCode = TransactionResultCode.APPROVED_BY_OFFLINE;
                    } else {
                        transactionResultCode = TransactionResultCode.APPROVED_BY_ONLINE;
                    }
                    break;

                case EmvConstant.EmvACType.ARQC: //ARQC
                    AppLog.d(LOG_TAG, "onFinish: ARQC");
                    break;
            }
            AppLog.d(LOG_TAG, "emvFinish: " + transactionResultCode.toString());
        } else if (emvResult == EmvConstant.EmvTransResultCode.EMV_RESULT_NOAPP) {  // fallback
            mCardReader.searchCard(true, false, false, 30, new AidlCheckCardListener.Stub() {
                @Override
                public void onFindMagCard(TrackData trackData) throws RemoteException {
                    AppLog.d(LOG_TAG, "card NO:" + trackData.getCardNo());
                    mCardReadMode = CardReadMode.SWIPE;
                    CreditCard creditCard = new CreditCard();
                    creditCard.setCardReadMode(CardReadMode.SWIPE);
                    creditCard.setCardNumber(trackData.getCardNo());
                    creditCard.setExpireDate(trackData.getExpiryDate());
                    creditCard.setServiceCode(trackData.getServiceCode());
                    CreditCard.MagData magData = new CreditCard.MagData(trackData.getTrack1Data(), trackData.getTrack2Data());
                    creditCard.setMagData(magData);
                    mListener.onCardDetected(ETopPayProcessor.CardReadMode.SWIPE, creditCard);

                    StringBuilder builder = new StringBuilder();
                    builder.append("Card: " + trackData.getCardNo());
                    builder.append("\nTk1: " + trackData.getTrack1Data());
                    builder.append("\nTk2: " + trackData.getTrack2Data());
                    builder.append("\nTk3: " + trackData.getTrack3Data());
                    builder.append("\ntrackKSN: " + trackData.getKsn());
                    builder.append("\nExpiryDate: " + trackData.getExpiryDate());
                    builder.append("\nCardholderName: " + trackData.getCardholderName());
                    AppLog.d(LOG_TAG, "FallBack onFindMagCard: " + builder.toString());
                    stopSearch();
                    magCardInputPIN(creditCard.getCardNumber());
                    mOnlineRespEntitiy = mListener.onPerformOnlineProcessing(creditCard, mAmount);
                    TransactionResultCode transactionResultCode = TransactionResultCode.APPROVED_BY_ONLINE;
                    mListener.onCompleted(transactionResultCode, creditCard);
                }

                @Override
                public void onSwipeCardFail() throws RemoteException {

                }

                @Override
                public void onFindICCard() throws RemoteException {

                }

                @Override
                public void onFindRFCard(int i) throws RemoteException {

                }

                @Override
                public void onTimeout() throws RemoteException {
                    AppLog.d(LOG_TAG, "fallback onTimeout: ");
                }

                @Override
                public void onCancelled() throws RemoteException {
                    AppLog.d(LOG_TAG, "fallback onCancelled: ");
                }

                @Override
                public void onError(int i) throws RemoteException {
                    AppLog.d(LOG_TAG, "fallback onError: " + i);
                }
            });
        } else if (emvResult == EmvConstant.EmvTransResultCode.EMV_RESULT_STOP) { //Cancel
            AppLog.d(LOG_TAG, "emvFinish: EMV_RESULT_STOP");
            transactionResultCode = ERROR_TRANSCATION_CANCEL;
        } else {

            AppLog.d(LOG_TAG, "emvFinish: Other result");
            if (mOnlineRespEntitiy != null && "00".equals(mOnlineRespEntitiy.getRespCode())) {
                transactionResultCode = TransactionResultCode.DECLINED_BY_TERMINAL_NEED_REVERSE;
            } else {
                transactionResultCode = ERROR_UNKNOWN;
            }

        }
        mListener.onCompleted(transactionResultCode, creditCard);
    }

    private Bundle setPinpadUI(boolean isOnline) {
        Bundle bundle = new Bundle();
        bundle.putBoolean(PinpadConst.PinpadShow.COMMON_NEW_LAYOUT, true);
        bundle.putString(PinpadConst.PinpadShow.COMMON_OK_TEXT, "Enter");
        bundle.putBoolean(PinpadConst.PinpadShow.COMMON_SUPPORT_BYPASS, false);
        bundle.putBoolean(PinpadConst.PinpadShow.COMMON_SUPPORT_KEYVOICE, false);
        bundle.putBoolean(PinpadConst.PinpadShow.COMMON_IS_RANDOM, true);
        if (isOnline) {
            bundle.putString(PinpadConst.PinpadShow.TITLE_HEAD_CONTENT, "Please Enter PIN");
        } else {
            bundle.putString(PinpadConst.PinpadShow.TITLE_HEAD_CONTENT, "Please Enter Offline PIN");
        }

        return bundle;
    }

    public void magCardInputPIN(String sPAN) {
        Bundle bundle = setPinpadUI(true);
        try {
            mPinPad.inputOnlinePin(bundle, new int[]{4, 6}, 300, sPAN, 0, PinpadConst.PinAlgorithmMode.ISO9564FMT1, new AidlPinPadInputListener.Stub() {
                @Override
                public void onConfirm(byte[] data, boolean noPin, String s) throws RemoteException {

                    AppLog.d(LOG_TAG, "PIN input:" + (noPin == true ? "NO" : "Yes"));
                    AppLog.d(LOG_TAG, "PIN Block:" + HexUtil.bytesToHexString(data));
                    // go for online processing.
                    mOnlineRespEntitiy = mListener.onPerformOnlineProcessing(creditCard, mAmount);
                }

                @Override
                public void onSendKey(int keyCode) throws RemoteException {
                    AppLog.d(LOG_TAG, "onSendKey:" + keyCode);
                }

                @Override
                public void onCancel() throws RemoteException {
                    AppLog.d(LOG_TAG, "onCancel: ");
                    mListener.onCompleted(ERROR_TRANSCATION_CANCEL, creditCard);
                }

                @Override
                public void onError(int errorCode) throws RemoteException {
                    AppLog.e(LOG_TAG, "onError: code:" + errorCode);
                    mListener.onCompleted(ERROR_UNKNOWN, creditCard);
                }
            });
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private void inputOnlinePIN(String sPAN) {
        Bundle bundle = setPinpadUI(true);

        try {
            mPinPad.inputOnlinePin(bundle, new int[]{4, 6}, 30, sPAN, 0, PinpadConst.PinAlgorithmMode.ISO9564FMT1, new AidlPinPadInputListener.Stub() {
                @Override
                public void onConfirm(byte[] data, boolean noPin, String s) throws RemoteException {
                    StringBuilder builder = new StringBuilder();
                    builder.append("\ntime = " + (System.currentTimeMillis() - startTick) + "ms");
                    builder.append("\nPIN input:" + (noPin == true ? "NO" : "Yes"));
                    builder.append("\nPIN Block:" + HexUtil.bytesToHexString(data));
                    builder.append("\nksn: " + s);
                    AppLog.d(LOG_TAG, builder.toString());
                    mEmvL2.requestPinResp(data, noPin);
                    creditCard.setPIN(HexUtil.bytesToHexString(data));
                }

                @Override
                public void onSendKey(int keyCode) throws RemoteException {
                    AppLog.d(LOG_TAG, "onSendKey:" + keyCode);
                }

                @Override
                public void onCancel() throws RemoteException {
                    AppLog.d(LOG_TAG, "inputOnlinePin onCancel: ");
                    mEmvL2.requestPinResp(null, false);
                }

                @Override
                public void onError(int errorCode) throws RemoteException {
                    AppLog.d(LOG_TAG, "onError: code:" + errorCode);
                    mEmvL2.requestPinResp(null, false);
                }
            });
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private void inputOfflinePIN(String pan, int lefttimes) {
        AppLog.d(LOG_TAG, "inputOfflinePIN: " + pan);
        Bundle bundle = new Bundle();
        bundle.putBoolean(PinpadConst.PinpadShow.COMMON_NEW_LAYOUT, true);
        bundle.putString(PinpadConst.PinpadShow.COMMON_OK_TEXT, "OK");
        bundle.putBoolean(PinpadConst.PinpadShow.COMMON_SUPPORT_BYPASS, false);
        bundle.putBoolean(PinpadConst.PinpadShow.COMMON_SUPPORT_KEYVOICE, false);
        bundle.putBoolean(PinpadConst.PinpadShow.COMMON_IS_RANDOM, true);
        if (lefttimes == 3) {
            bundle.putString(PinpadConst.PinpadShow.TITLE_HEAD_CONTENT, "Please Enter PIN:");
        } else if (lefttimes == 2) {
            bundle.putString(PinpadConst.PinpadShow.TITLE_HEAD_CONTENT, "Please Enter PIN:(2 Chances Left)");
        } else if (lefttimes == 1) {
            bundle.putString(PinpadConst.PinpadShow.TITLE_HEAD_CONTENT, "Please Enter PIN(Last Chance):");
        }

        try {
            mPinPad.inputOfflinePin(bundle, new int[]{4}, 30, new AidlPinPadInputListener.Stub() {
                @Override
                public void onConfirm(byte[] data, boolean noPin, String s) throws RemoteException {
                    StringBuilder builder = new StringBuilder();
                    builder.append("\ntime = " + (System.currentTimeMillis() - startTick) + "ms");
                    builder.append("\nPIN input:" + (noPin == true ? "NO" : "Yes"));
                    builder.append("\nPIN Block:" + HexUtil.bytesToHexString(data));
                    builder.append("\nksn: " + s);
                    mEmvL2.requestPinResp(data, noPin);
//                    creditCard.setPIN(ConvertUtils.bytes2HexString(data));
                    creditCard.setPIN("");
                }

                @Override
                public void onSendKey(int keyCode) throws RemoteException {
                    AppLog.d(LOG_TAG, "onSendKey: " + keyCode);
                }

                @Override
                public void onCancel() throws RemoteException {
                    AppLog.d(LOG_TAG, "inputOfflinePIN onCancel: ");
                    mEmvL2.requestPinResp(null, false);
                }

                @Override
                public void onError(int errorCode) throws RemoteException {
                    AppLog.e(LOG_TAG, "onError: code:" + errorCode);
                    mEmvL2.requestPinResp(null, false);
                }
            });
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }


    private void stopSearch() {
        try {
            mCardReader.cancelSearchCard();
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private void initEmvParam() {
        try {
            mEmvL2.setTermConfig(EmvUtil.getInitTermConfig());
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private <T> ArrayList<T> createArrayList(T... elements) {
        ArrayList<T> list = new ArrayList<T>();
        for (T element : elements) {
            list.add(element);
        }
        return list;
    }

    private void setEmvTransDataExt() {
        Bundle config = new Bundle();
        config.putInt(EmvConstant.EmvTransDataConstants.KERNEL_MODE, 0x01);
        config.putByte(EmvConstant.EmvTransDataConstants.TRANS_TYPE, (byte) 0x00);

        config.putStringArrayList(EmvConstant.EmvTerminalConstraints.CONFIG, createArrayList("DF81180170", "DF81190118", "DF811B0130"));
        try {
            mEmvL2.setTransDataConfigExt(config);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private void startEMVProcess() {
        initEmvParam();
        EmvTransData emvTransData = new EmvTransData();
        emvTransData.setAmount(mAmount);
        emvTransData.setOtherAmount(0);
        emvTransData.setForceOnline(true);
        emvTransData.setEmvFlowType(EmvConstant.EmvTransFlow.FULL);
        setEmvTransDataExt();   // Set ext trans data.
        try {
            mEmvL2.startEmvProcess(emvTransData, emvStartListener);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }


    private void selApp(List<CandidateAID> appList) {
//        String[] options = new String[appList.size()];
//        for (int i = 0; i < appList.size(); i++) {
//            options[i] = appList.get(i).getAppLabel();
//        }
//        AlertDialog.Builder alertBuilder = new AlertDialog.Builder(mContext);
//        alertBuilder.setTitle("Please select app");
//        alertBuilder.setItems(options, new DialogInterface.OnClickListener() {
//            @Override
//            public void onClick(DialogInterface dialogInterface, int index) {
//                try {
//                    mEmvL2.requestAidSelectResp(index);
//                } catch (RemoteException e) {
//
//                }
//            }
//        });
//        AlertDialog alertDialog1 = alertBuilder.create();
//        alertDialog1.show();
    }



}

