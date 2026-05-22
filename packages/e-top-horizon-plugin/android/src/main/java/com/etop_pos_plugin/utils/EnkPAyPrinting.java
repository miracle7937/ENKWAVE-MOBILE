package com.etop_pos_plugin.utils;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.RemoteException;

import com.horizonpay.smartpossdk.aidl.printer.AidlPrinterListener;
import com.horizonpay.smartpossdk.aidl.printer.IAidlPrinter;
import com.horizonpay.smartpossdk.data.PrinterConst;
import com.horizonpay.utils.ToastUtils;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class EnkPAyPrinting {
    IAidlPrinter printer;
    Map<String, String> mp = new HashMap<>();
    Context context;
    boolean printDouble;
    String MERCHANT_NAME;


    public EnkPAyPrinting(Context context, Map<String, String> mp ,String merchantName) {
        try {
            printer = DeviceHelper.getPrinter();
            this.mp = mp;
            this.context = context;
            this.MERCHANT_NAME = merchantName;
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    public EnkPAyPrinting(Context context, Map<String, String> mp, boolean printDouble ,String merchantName) {
        try {
            printer = DeviceHelper.getPrinter();
            this.mp = mp;
            this.context = context;
            this.printDouble = printDouble;
            this.MERCHANT_NAME = merchantName;

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
        Bitmap bitmap;
        bitmap = getImageFromAssetsFile(context, "enk_pay.bmp");
        combBitmap.addBitmap(bitmap);
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap(this.MERCHANT_NAME, 22, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap(title, 20, GenerateBitmap.AlignEnum.CENTER, true, false));

        combBitmap.addBitmap(GenerateBitmap.generateLine(1)); // print one line
        for (Map.Entry<String, String> pair : mp.entrySet()) {
            combBitmap.addBitmap(GenerateBitmap.str2Bitmap(pair.getKey(), pair.getValue(), 22, true, false));

        }
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("--------------------------------------", 20, GenerateBitmap.AlignEnum.CENTER, true, false)); // 打印一行直线
        if (mp.get("Transaction Status") != null) {
            combBitmap.addBitmap(GenerateBitmap.str2Bitmap(mp.get("Transaction Status"), 27, GenerateBitmap.AlignEnum.CENTER, true, false));
        }
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("Powered by Enkwave", 22, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("www.enkapy.com", 22, GenerateBitmap.AlignEnum.CENTER, true, false));
        combBitmap.addBitmap(GenerateBitmap.str2Bitmap("help@enkapy.com", 22, GenerateBitmap.AlignEnum.CENTER, true, false));
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
