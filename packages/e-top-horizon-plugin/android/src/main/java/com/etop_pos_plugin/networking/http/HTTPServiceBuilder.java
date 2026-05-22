package com.etop_pos_plugin.networking.http;

import com.etop_pos_plugin.networking.model.NetworkVariables;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class HTTPServiceBuilder {
    HttpLoggingInterceptor loggingInterceptor = new HttpLoggingInterceptor();
    final String BaseURL= NetworkVariables.getInstance().getBaseURL();
//    final String BaseURL= "https://seashell-app-zydkq.ondigitalocean.app/";

    final Retrofit.Builder   baseBuilder= new Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .client(
                    getBaseOkhttpClientBuilder()
                            .build());
    private  OkHttpClient.Builder getBaseOkhttpClientBuilder() {
        OkHttpClient.Builder okHttpClientBuilder = new OkHttpClient.Builder();
        HttpLoggingInterceptor loggingInterceptor = new HttpLoggingInterceptor();
        loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        okHttpClientBuilder.addInterceptor(loggingInterceptor)
                .callTimeout(1, TimeUnit.MINUTES)
                .readTimeout(1, TimeUnit.MINUTES)
                .connectTimeout(1, TimeUnit.MINUTES);
        return okHttpClientBuilder;
    }


    public  TransactionNotification  tranNotification(){
        loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        OkHttpClient httpClient = new OkHttpClient.Builder()
                .addInterceptor(loggingInterceptor)
                .build();
        return new Retrofit.Builder()
                .baseUrl(this.BaseURL)
                .client(httpClient)
                .addConverterFactory(GsonConverterFactory.create())
                .build().create(TransactionNotification.class);
    }

}
