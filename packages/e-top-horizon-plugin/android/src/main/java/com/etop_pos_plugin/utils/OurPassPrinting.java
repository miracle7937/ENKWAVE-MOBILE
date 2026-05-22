package com.etop_pos_plugin.utils;

import static com.etop_pos_plugin.utils.PrefManager.MERCHANT_NAME_KEY;

import static java.lang.Thread.sleep;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.RemoteException;

import com.etop_pos_plugin.etop_pos_plugin.EtopPosPlugin;
import com.horizonpay.smartpossdk.aidl.printer.AidlPrinterListener;
import com.horizonpay.smartpossdk.aidl.printer.IAidlPrinter;
import com.horizonpay.smartpossdk.data.PrinterConst;
import com.horizonpay.utils.ToastUtils;



import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;


public class OurPassPrinting {
    IAidlPrinter printer;
    Map<String, String> mp = new HashMap<>();
    Map<String, String> institutionParameters = new HashMap<>();
    Context context;
    boolean printDouble;
    String MERCHANT_NAME;
    String title;



    public OurPassPrinting(Context context, Map<String, String> mp ,String merchantName, String title) {
        try {
            printer = DeviceHelper.getPrinter();
            this.mp = mp;
            this.context = context;
            this.MERCHANT_NAME = merchantName;
            this.title = title;
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    public OurPassPrinting(Context context, Map<String, String> mp, boolean printDouble,  String merchantName, String title) {
        try {
            printer = DeviceHelper.getPrinter();
            this.mp = mp;
            this.context = context;
            this.printDouble = printDouble;
            this.MERCHANT_NAME = merchantName;
            this.title = title;

        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private void setPrintLevel(int level) {
        try {
            printer.setPrintGray(level);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }



    public static Bitmap getImageFromAssetsFile(Context context, String fileName) {
        Bitmap image = null;
        AssetManager am = context.getResources().getAssets();
        try {
            InputStream is = am.open(fileName);
            image = BitmapFactory.decodeStream(is);
            is.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        AppLog.d("OurPassPrinting", "bitMap  =" + image);
        return image;
    }






    private Bitmap generateTestBitmap(String title) {
        PrefManager prefManager = new PrefManager();
        HashMap<String, String> prefDetails = prefManager.getTerminalDetails();
        CombBitmap combBitmap = new CombBitmap();
        Bitmap bitmap = null;

        try {

             bitmap = BitmapImageHelper.getImageBitmap(context);
            if(bitmap != null){
                combBitmap.addBitmap(bitmap);
            }
        } catch (Exception e) {
            AppLog.d("ExceptionOurPassPrinting", "Exception  =" + e);
            e.printStackTrace();
        }


        combBitmap.addBitmap(GenerateBitmap.generateGap(40));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap(this.title, 20, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.generateGap(20));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap(this.MERCHANT_NAME, 26, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap(title, 20, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.generateGap(40));

        combBitmap.addBitmap(GenerateBitmap.generateLine(1)); // print one line
        for (Map.Entry<String, String> pair : mp.entrySet()) {
            if(pair.getValue() != null){
                combBitmap.addBitmap(GenerateBitmap.str2Bitmap(pair.getKey(), pair.getValue(), 22, true, false));
            }

        }

        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("--------------------------------------", 20, GenerateBitmap.AlignEnum.CENTER, true, false)); // 打印一行直线



        combBitmap.addBitmap(GenerateBitmap.generateLine(1)); // print one line
        if (mp.get("Message") != null) {
            combBitmap.addBitmap(GenerateBitmap.str2Bitmap(mp.get("Message"), 27, GenerateBitmap.AlignEnum.CENTER, true, false));
        }
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("Powered by Enkwave", 22, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("www.enkwave.com", 22, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("support@enkwave.com", 22, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.generateGap(60)); // print row gap
        combBitmap.addBitmap(GenerateBitmap.generateLine(1)); // print one line
        combBitmap.addBitmap(GenerateBitmap.generateGap(60)); // print row gap
        Bitmap bp = combBitmap.getCombBitmap();
        return bp;
    }

    public void print() {
        try {
            ArrayList<Bitmap> items = new ArrayList<>();
            items.add(generateTestBitmap("****** Transaction Receipts ******"));
            if (printDouble) {
                items.add(generateTestBitmap("****** Transaction Receipts ******"));
            }

            for (int i =0;  i < items.size(); i++) {

                printer.printBmp(true, false, items.get(i), 0, new AidlPrinterListener.Stub() {
                    @Override
                    public void onError(int i) {
                        switch (i) {
                            case PrinterConst.RetCode.ERROR_PRINT_NOPAPER:
                                showMessage("Print Failed (Please check paper)");
                                break;
                            case PrinterConst.RetCode.ERROR_DEV:
                                showMessage("Print Failed (Error device)");
                                break;
                            case PrinterConst.RetCode.ERROR_DEV_IS_BUSY:
                                showMessage("Print Failed (Device is busy)");
                                break;
                            default:
                            case PrinterConst.RetCode.ERROR_OTHER:
                                showMessage("Print Failed (Other error)");
                                break;
                        }
                    }

                    @Override
                    public void onPrintSuccess() throws RemoteException {
                        showMessage("PRINT SUCCESS");
                    }
                });

                if(i != items.size()-1){
                    sleep(5000);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void showMessage(String message) {
        ToastUtils.showShort(message);
    }




}
