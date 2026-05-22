package com.etop_pos_plugin.networking.miscellaneous;



import com.etop_pos_plugin.utils.Debug;

import org.jpos.iso.ISOMsg;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class Utilities {
    private static final String TAG = Utilities.class.getSimpleName();

    public static byte[] StrToHexByte(String str) {

        if (str == null)
            return null;
        else if (str.length() < 2)
            return null;
        else {
            int len = str.length() / 2;
            byte[] buffer = new byte[len];
            for (int i = 0; i < len; i++) {
                buffer[i] = (byte) Integer.parseInt(
                        str.substring(i * 2, i * 2 + 2), 16);
            }
            return buffer;
        }
    }
    public static String padLeft(String data, int length, char padChar) {
        int remaining = length - data.length();
        String newData = data;

        for(int i = 0; i < remaining; ++i) {
            newData = padChar + newData;
        }

        return newData;
    }

    public static String getField4(String amountStr) {
        int index = amountStr.indexOf(".");
        if (amountStr.substring(index + 1, amountStr.length()).length() < 2) {
            amountStr = amountStr + "0";
        }
        amountStr = amountStr.replace(".", "");
        int amtlen = amountStr.length();
        StringBuilder amtBuilder = new StringBuilder();
        if (amtlen < 12) {
            for (int i = 0; i < (12 - amtlen); i++) {
                amtBuilder.append("0");
            }
        }
        amtBuilder.append(amountStr);
        amountStr = amtBuilder.toString();
        return amountStr;
    }

    public static String bytes2HexString(byte[] b) {
        String ret = "";
        for (byte element : b) {
            String hex = Integer.toHexString(element & 0xFF);
            if (hex.length() == 1) {
                hex = '0' + hex;
            }
            ret += hex.toUpperCase();
        }
        return ret;
    }







    public static void logISOMsg(ISO8583 msg, String[] storage)
    {
        Debug.print(TAG+ "----ISO MESSAGE-----");
        try {
            for (int i = 0; i < 129; i++)
            {
                try
                {
                    String log = new String(msg.getBit(i));
                    if (log != null)
                    {
                        Debug.print(TAG+ "Field " + i + " : " + log);
                        storage[i] = log;
                    }
                }catch (Exception e)
                {
                    //Do nothing about it
                }
            }
        } finally {
            Debug.print(TAG+ "--------------------");
        }

    }

    public static void logISOMsgII(ISO8583 msg)
    {
        Debug.print(TAG+ "----ISO MESSAGE-----");
        try {
            for (int i = 0; i < 129; i++)
            {
                try
                {
                    String log = new String(msg.getBit(i));
                    if (log != null)
                    {
                        Debug.print(TAG+ "Field " + i + " : " + log);
                    }
                }catch (Exception e)
                {
                    //Do nothing about it
                }
            }
        } finally {
            Debug.print(TAG+ "--------------------");
        }

    }

    public static String maskedPan(String cardNo)
    {
        if(cardNo == null)
            return "*****";
        int cardLength = cardNo.length();
        String firCardNo = cardNo.substring(0,6);
        String lastCardNo = cardNo.substring(cardLength - 4);
        String mid = "******";
        return (firCardNo + mid + lastCardNo);
    }

    public static String getDATEYYYYMMDD(String date)
    {
        if(date == null)
            return "*****";
        int year = Calendar.getInstance().get(Calendar.YEAR);
        String format = String.valueOf(year) + date;
        return format;
    }

    public static void logISOMsgMute(ISO8583 msg, String[] storage)
    {
        //Log.i(TAG, "----ISO STORAGE-----");
        try {
            for (int i = 0; i < 129; i++)
            {
                try
                {
                    String log = new String(msg.getBit(i));
                    if (log != null)
                    {
                        storage[i] = log;
                    }
                }catch (Exception e)
                {
                    //Do nothing about it
                }
            }
        } finally {
            //Log.i(TAG, "--------------------");
        }

    }


    public static byte[] getCustomPacketHeader(byte[] isobyte) {
        String cs = String.format("%04X", ISO8583Util.byteArrayAdd(isobyte, null).length);
        byte[] bcdlen = BCDASCII.hexStringToBytes(cs);
        Debug.print(TAG+ "Length 2: " + bcdlen.length);
        return ISO8583Util.byteArrayAdd(bcdlen, ISO8583Util.byteArrayAdd(null, null, null), isobyte);
    }

    public static String getCurrentTime()
    {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("E, MMM dd yyyy HH:mm:ss");
        return sdf.format(cal.getTime());
    }

    public static String getServiceCode(String track2Data) {
        int indexOfToken = track2Data.indexOf("D");
        int indexOfServiceCode = indexOfToken + 5;
        int lengthOfServiceCode = 3;
        return track2Data.substring(indexOfServiceCode, indexOfServiceCode + lengthOfServiceCode);
    }
    public static String parseLongIntoNairaKoboString(long tempAmount) {
        double amountNairaPart = (double)tempAmount / 100.0D;
        NumberFormat numFormatter = NumberFormat.getInstance(Locale.US);
        numFormatter.setMinimumFractionDigits(2);
        String amountInN = numFormatter.format(amountNairaPart);
        amountInN = "NGN" + amountInN;
        return amountInN;
    }
    public static String parseIntAccountTypeToString(int accountType) {
        String accountTypeString = "";
        switch(accountType) {
            case 0:
                accountTypeString = "Default";
                break;
            case 1:
            case 10:
                accountTypeString = "Savings";
                break;
            case 2:
            case 20:
                accountTypeString = "Current";
                break;
            case 3:
            case 30:
                accountTypeString = "Credit";
                break;
            case 4:
            case 40:
                accountTypeString = "Universal";
                break;
            case 5:
            case 50:
                accountTypeString = "Investment";
                break;
            default:
                throw new IllegalArgumentException();
        }

        return accountTypeString;
    }

    public static String padLeftZeros(String inputString, int length) {
        if (inputString.length() >= length) {
            return inputString;
        }
        StringBuilder sb = new StringBuilder();
        while (sb.length() < length - inputString.length()) {
            sb.append('0');
        }
        sb.append(inputString);

        return sb.toString();
    }


  public static boolean isEmpty(String s){
      return s == null || "null".equals(s) || s.trim().isEmpty();

  }
}
