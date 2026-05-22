package com.etop_pos_plugin.utils;

import com.etop_pos_plugin.networking.miscellaneous.Utilities;

import java.text.SimpleDateFormat;
import java.util.Date;

public class StringUtil {
    public static boolean isNotEmpty(String s) {
        return s != null && !s.isEmpty() && !s.equals("null");
    }

    public static String convertAmountToField4(String amountString) {
        return Utilities.padLeftZeros(String.valueOf((Integer.parseInt(amountString) * 100)), 12);
    }

    public  static  String  getRRN(){
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        String pre = dateFormat.format(new Date());
        return pre.substring(2);
    };
}
