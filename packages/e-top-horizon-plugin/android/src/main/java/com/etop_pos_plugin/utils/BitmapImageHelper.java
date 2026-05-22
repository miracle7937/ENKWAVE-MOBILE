package com.etop_pos_plugin.utils;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import com.etop_pos_plugin.etop_pos_plugin.R;

public class BitmapImageHelper {

    static public Bitmap getImageBitmap(Context activity) {
        String path = new PrefManager().getLOGOFileLocation();
        if (StringUtil.isNotEmpty(path)) {
            Log.d("BitmapImageHelper", "File Image exist " +  path);
            return BitmapFactory.decodeFile(path);
        } else {
            Log.d("BitmapImageHelper", "File Image do not exist use assets image " +  path);
            return BitmapFactory.decodeResource(activity.getResources(), R.mipmap.telpo);
        }
    }
}