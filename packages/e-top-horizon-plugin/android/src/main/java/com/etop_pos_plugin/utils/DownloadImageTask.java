package com.etop_pos_plugin.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class DownloadImageTask extends AsyncTask<String, Void, String>{
String TAG =  DownloadImageTask.class.getSimpleName();

    private final Context context;


    public DownloadImageTask(Context context) {
        this.context = context;

    }

    @Override
    protected String doInBackground(String... params) {
        String imageUrl = params[0];
        String imagePath = downloadImage(imageUrl);
        Log.d(TAG, "==========================>"+imagePath );
        return imagePath;
    }

    @Override
    protected void onPostExecute(String result) {
        if (result != null){
            new PrefManager().saveLOGO(result);
        }


    }

    private String downloadImage(String imageUrl) {
        try {
            URL url = new URL(imageUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setDoInput(true);
            connection.connect();

            InputStream input = connection.getInputStream();
            Bitmap bitmap = BitmapFactory.decodeStream(input);

            File directory = context.getFilesDir();
            File imageFile = new File(directory, "logo_image.jpg");

            if(bitmap != null){
                FileOutputStream fos = new FileOutputStream(imageFile);
                bitmap.compress(Bitmap.CompressFormat.PNG, 60, fos);
                fos.flush();
                fos.close();
                Log.d(TAG, " Successfully downloading image: " +  imageFile.getAbsolutePath());
                return imageFile.getAbsolutePath();


            }else {
                Log.d(TAG, " Failed downloading image: " );
                return  null;
            }
        } catch (IOException e) {
            Log.e(TAG, " Error downloading image: " + e.getMessage());
            return null;
        }
    }

    public interface ImageDownloadListener {
        void onImageDownloaded(String imagePath);
    }

}