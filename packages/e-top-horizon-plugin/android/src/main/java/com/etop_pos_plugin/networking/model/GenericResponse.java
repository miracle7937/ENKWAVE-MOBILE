package com.etop_pos_plugin.networking.model;

import com.google.gson.annotations.SerializedName;

public class GenericResponse {

    @SerializedName("status")
    public boolean status;

    @SerializedName("message")
    public String message;

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
