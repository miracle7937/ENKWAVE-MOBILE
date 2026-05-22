package com.etop_pos_plugin.utils;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.RemoteException;

import com.etop_pos_plugin.networking.miscellaneous.Utilities;
import com.etop_pos_plugin.networking.model.EodModel;
import com.etop_pos_plugin.networking.model.TransactionResponseModel;
import com.horizonpay.smartpossdk.aidl.printer.AidlPrinterListener;
import com.horizonpay.smartpossdk.aidl.printer.IAidlPrinter;
import com.horizonpay.smartpossdk.data.PrinterConst;
import com.horizonpay.utils.ToastUtils;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EODPrinting {
    IAidlPrinter printer;
    Context context;
    boolean printDouble;
    TransactionFullReport report;


    public EODPrinting(Context context, TransactionFullReport report) {
        try {
            printer = DeviceHelper.getPrinter();
            this.context = context;
            this.report = report;
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    public EODPrinting(Context context, TransactionFullReport report, boolean printDouble) {
        try {
            printer = DeviceHelper.getPrinter();
            this.context = context;
            this.printDouble = printDouble;
            this.report = report;
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
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap(this.report.getMerchant_name(), 26, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap(title, 20, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.generateGap(40));

        combBitmap.addBitmap(GenerateBitmap.generateLine(1)); // print one line
        for (TransactionFullReport.Transaction pair : report.getTransaction()) {

            combBitmap.addBitmap(GenerateBitmap.str2Bitmap("Amount", "NGN"+pair.getAmount(), 22, true, false));
            combBitmap.addBitmap(GenerateBitmap.str2Bitmap("RRN", pair.getRrn(), 22, true, false));;
            combBitmap.addBitmap(GenerateBitmap.str2Bitmap("Date", pair.getDate_time(), 15, true, false));
            combBitmap.addBitmap(GenerateBitmap.str2Bitmap("Transaction Type", "PURCHASE", 15, true, false));
            combBitmap.addBitmap(GenerateBitmap.str2Bitmap("Card NO", pair.getCard_pan(), 15, true, false));
            combBitmap.addBitmap(GenerateBitmap.str2Bitmap("Success", String.valueOf(pair.getStatus().equals("00")), 15, true, false));





            combBitmap.addBitmap(GenerateBitmap.str2Bitmap("--------------------------------------", 20, GenerateBitmap.AlignEnum.CENTER, true, false)); // 打印一行直线

        }



        combBitmap.addBitmap(GenerateBitmap.generateGap(30)); // print row gap
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("Total",String.valueOf(report.getTransaction().size()), 22, true, false));
        combBitmap.addBitmap(GenerateBitmap.generateGap(30)); // print row gap




        combBitmap.addBitmap(GenerateBitmap.generateLine(1)); // print one line
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
            items.add(generateTestBitmap("****** Customer Copy ******"));
            if (printDouble) {
                items.add(generateTestBitmap("****** Merchant Copy ******"));
            }
            for (Bitmap bitmap: items) {
                printer.printBmp(true, false, bitmap, 0, new AidlPrinterListener.Stub() {
                    @Override
                    public void onError(int i) throws RemoteException {
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
            }

        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    void showMessage(String message) {
        ToastUtils.showShort(message);
    }
}

