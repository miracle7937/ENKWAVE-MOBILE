package com.etop_pos_plugin.etop_pos_plugin;

import android.app.Activity;
import android.content.Intent;
import android.os.RemoteException;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.etop_pos_plugin.networking.model.EodModel;
import com.etop_pos_plugin.networking.model.NetworkVariables;
import com.etop_pos_plugin.networking.model.TransactionType;
import com.etop_pos_plugin.transctions.PosOperations;
import com.etop_pos_plugin.utils.DeviceHelper;
import com.etop_pos_plugin.utils.EODPrinting;
import com.etop_pos_plugin.utils.ETopMVDevicePrep;
import com.etop_pos_plugin.utils.RePrintReceipt;
import com.etop_pos_plugin.utils.TransactionFullReport;
import com.google.gson.Gson;
import com.horizonpay.utils.ToastUtils;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** EtopPosPlugin */
public class EtopPosPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  private MethodChannel channel;
  private Activity activity;
  private static final int REQUEST_CODE_SECOND_ACTIVITY = 1;
  private  String TAG = EtopPosPlugin.class.getSimpleName();



  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "etop_pos_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    String method = call.method;
    switch (method) {
      case "getPlatformVersion":
        try {
          result.success("Serial NO " + DeviceHelper.getSysHandle().getSn());
        } catch (RemoteException e) {
          e.printStackTrace();
        }
        break;

        case "getSerialNo":
            try {
                result.success(DeviceHelper.getSysHandle().getSn());
            } catch (RemoteException e) {
                e.printStackTrace();
            }
            break;
        case "prep":
          String terminalID = (String) call.argument("terminalID");
          HashMap<String, String> terminalConfig = call.argument("terminalConfig");
          String imageUrl = terminalConfig.get("logoUrl");
          String showLoader = terminalConfig.get("showLoader");
          showLoader = showLoader != null ? showLoader : "true";
          final Result prepResult = result;
          NetworkVariables.getInstance().setTerminalData(terminalConfig);
          new PosOperations().keyExchange(
              activity,
              terminalID,
              imageUrl,
              showLoader.equalsIgnoreCase("true"),
              (success, message) -> {
                if (success) {
                  prepResult.success(true);
                } else {
                  prepResult.error("PREP_FAILED", message, null);
                }
              });
          break;
      case "pay":
        if(NetworkVariables.getInstance().getBaseURL().isEmpty()){
          ToastUtils.showLong("Please Download Terminal Keys");
          return;
        }
        HashMap transactionData = call.argument("transactionData");
        Log.d(TAG, transactionData + " =====================>");
         new PosOperations().pay(activity, TransactionType.PURCHASE, transactionData);
//        Intent intent = new Intent(activity, InsertCardActivity.class);
//        intent.putExtra("transaction_data", transactionData);
//        activity.startActivity(intent);
        break;
      case "balance_inquiry":
        if(NetworkVariables.getInstance().getBaseURL().isEmpty()){
          ToastUtils.showLong("Please Download Terminal Keys");
          return;
        }
        HashMap tranxData = call.argument("transactionData");
        Log.d(TAG, tranxData + " =====================>");
        new PosOperations().balanceInquiry(activity, TransactionType.BALANCE_INQUIRY, tranxData);
        result.success(null);
        break;

      case "eod":
        HashMap tanxData = (HashMap<String, Object>) call.argument("transactionData");
        Log.d(TAG,  " print eod ====================> " + tanxData);
        Gson gson = new Gson();
        TransactionFullReport report = gson.fromJson(gson.toJson(tanxData), TransactionFullReport.class);
        new EODPrinting(activity,report ).print();
        result.success(null);
        break;

      case "reprint":
        HashMap transData =call.argument("transactionData");
        String title = (String) transData.get("title");
        String merchantName = (String) transData.get("merchantName");
        HashMap data = (HashMap) transData.get("data");
        new RePrintReceipt(activity,data, merchantName, title ).print();
        result.success(null);
        break;
      default:
        result.notImplemented();

    }



  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    activity.setTheme(com.google.android.material.R.style.Theme_MaterialComponents_DayNight);

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    activity.setTheme(com.google.android.material.R.style.Theme_MaterialComponents_DayNight);

  }

  @Override
  public void onDetachedFromActivity() {

  }


  @Override
  public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    if (requestCode == REQUEST_CODE_SECOND_ACTIVITY) {
      if (resultCode == requestCode) {
        System.out.println("Printing All The Way");
      }
    }

    return false;
  }


}
//3867