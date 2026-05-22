package com.etop_pos_plugin.networking.http;

import com.etop_pos_plugin.networking.model.GenericResponse;
import com.etop_pos_plugin.networking.model.LogData;
import com.etop_pos_plugin.networking.model.NotificationResponse;
import com.etop_pos_plugin.networking.model.TransactionResponseModel;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Headers;
import retrofit2.http.POST;

public interface TransactionNotification
{

    @Headers({
            "dataKey: 03f3925b44df6728fbb156a4e380b379b16904cfae3c7d387f606e1d77e1e43e428cc5ea894ff4bfa96915edea068b4469184048bc7cfdb761eb3a654f3097f7"
    })
    @POST("pos")
    Call<NotificationResponse> notifyT(@Body TransactionResponseModel encryptedBody);

    @Headers({
            "dataKey: 03f3925b44df6728fbb156a4e380b379b16904cfae3c7d387f606e1d77e1e43e428cc5ea894ff4bfa96915edea068b4469184048bc7cfdb761eb3a654f3097f7",
    })
    @POST("pos-logs")
    Call<GenericResponse> logTransaction(@Body LogData logData);

}
