package com.etop_pos_plugin.utils;

import android.app.Activity;

public class ActivitySingleton {
    private static ActivitySingleton instance;
    private ActivitySingleton() {
        // Initialization code, if needed
    }

    public static ActivitySingleton getInstance() {
        if (instance == null) {
            instance = new ActivitySingleton();
        }
        return instance;
    }

    Activity activity;

    public Activity getActivity() {
        return activity;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }
}
