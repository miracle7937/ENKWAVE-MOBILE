package com.etop_pos_plugin.utils;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.RemoteException;
import android.util.Log;


import com.etop_pos_plugin.networking.model.PrepResultRecord;
import com.etop_pos_plugin.networking.prep.SynchronizePrep;
import com.horizonpay.smartpossdk.aidl.pinpad.IAidlPinpad;
import com.horizonpay.smartpossdk.data.PinpadConst;
import com.horizonpay.utils.ToastUtils;

import java.util.Objects;

import io.reactivex.Single;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;

public class ETopMVDevicePrep {

    public static class PinPadKeyType {
        public static final int TPINK = 0;

        public PinPadKeyType() {
        }
    }

    private static final String TAG = "OurPassEMVModule";
    private static final int MASTER_KEY_INDEX = 0;
    private static final int WORK_KEY_INDEX = 0;
    IAidlPinpad iAidlPinpad;
    String terminalId;
    String imageURL;
    private Context mContext;
    ProgressDialog progressDialog;
    CustomLoader customLoader;
    boolean showLoader;
    private final PrepCompletionListener completionListener;


    public ETopMVDevicePrep(String terminalId, String imageURl, Context context,
                            CustomLoader customLoader, boolean showLoader) {
        this(terminalId, imageURl, context, customLoader, showLoader, null);
    }

    public ETopMVDevicePrep(String terminalId, String imageURl, Context context,
                            CustomLoader customLoader, boolean showLoader,
                            PrepCompletionListener completionListener) {
        this.terminalId = terminalId;
        this.imageURL = imageURl;
        this.mContext = context;
        this.customLoader = customLoader;
        this.showLoader = showLoader;
        this.completionListener = completionListener;
        progressDialog = new ProgressDialog(mContext);
        progressDialog.setMessage("Please wait");
        progressDialog.setCanceledOnTouchOutside(false);
    }


    @SuppressLint("CheckResult")
    public void KeyExchange() {

        if (!NetworkUtils.isNetworkConnected(mContext)) {
            showResult("Not  network connection", true);
            return;
        }
//        progressDialog.show();

        String fileUrl =  new  PrefManager().getLOGOFileLocation();
        if( !StringUtil.isNotEmpty(fileUrl)  &&  StringUtil.isNotEmpty(imageURL)){
            Log.d("FileUrl", fileUrl);
            Log.d("imageURl", imageURL);
            new DownloadImageTask(mContext).execute(imageURL);
        }
        try {
            iAidlPinpad = DeviceHelper.getPinpad();
            iAidlPinpad.setKeyAlgorithm(PinpadConst.KeyAlgorithm.DES);
            SynchronizePrep param = new SynchronizePrep(terminalId);
            Single.fromCallable(param::Init).
                    subscribeOn(Schedulers.io()).
                    observeOn(AndroidSchedulers.mainThread()).
                    subscribe(result -> {
                        if (result == null
                                || result.getParameterModel() == null
                                || !StringUtil.isNotEmpty(result.getParameterModel().getCountryCode())) {
                            failPrep("Parameter download failed. Check terminal network and POS host (ip/port).");
                            return;
                        }
                        if (result.getMasterKeyModel() == null
                                || result.getPinKeyModel() == null) {
                            failPrep("Key download incomplete. Try again.");
                            return;
                        }
                        loadKeys(result);
                    }, error -> failPrep(error.getMessage() != null
                            ? error.getMessage()
                            : "Terminal prep failed"));

        } catch (Exception e) {
            failPrep(e.getMessage() != null ? e.getMessage() : "Terminal prep failed");
        }
    }

    private void failPrep(String message) {
        if (completionListener != null) {
            completionListener.onComplete(false, message);
        }
        showResult(message, true);
    }

    private void completePrepSuccess() {
        if (completionListener != null) {
            completionListener.onComplete(true, "Terminal ready");
        }
    }

    private void loadKeys(PrepResultRecord parameters) {
        new PrefManager().savePrepData(parameters);
        try {
            byte[] masterKey = HexUtil.hexStringToByte(
                    parameters.getMasterKeyModel().getClearMasterKey());
            boolean masterOk = iAidlPinpad.injectClearTMK(MASTER_KEY_INDEX, masterKey, new byte[4]);
            if (!masterOk) {
                failPrep("loadClearMasterKey failed");
                return;
            }
            loadWorkKey(parameters.getPinKeyModel().getClearPinKey());
        } catch (Exception e) {
            failPrep("loadClearMasterKey failed");
            AppLog.d(TAG, e.getMessage());
        }
    }

    private void loadWorkKey(String securePinKey) {
//        progressDialog.hide();
        try {
            byte[] pinKey = HexUtil.hexStringToByte(securePinKey);
            byte[] kcv = HexUtil.hexStringToByte("D2DB51F1");
            kcv = HexUtil.hexStringToByte("00000000");
            boolean result = iAidlPinpad.injectWorkKey(WORK_KEY_INDEX, PinPadKeyType.TPINK, pinKey, kcv);
            if (result) {
                new PrefManager().savePrepTime(System.currentTimeMillis());
                completePrepSuccess();
                showResult("Terminal ready", false);
            } else {
                failPrep("load pin key failed");
            }
        } catch (RemoteException e) {
            failPrep("load pin key failed");
            AppLog.d(TAG, e.getMessage());
        }


    }


    private void showResult(String text, boolean isError) {
        if(showLoader){
            customLoader.hideLoader();
        }
//        if(progressDialog.isShowing()){
//            progressDialog.hide();
//        }
        if(isError){

            ToastUtils.showLong("FAILED: " + text);
        }else{
            ToastUtils.showLong("SUCCESS");
        }
        AppLog.d("showLogs", text);
    }
}
